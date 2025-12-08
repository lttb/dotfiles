
# Simple per-directory mise env with caching (synchronous, safe)
# - On chpwd:
#   - Find nearest config (mise.toml or .tool-versions)
#   - Apply cached env if present and current
#   - Else run `mise hook-env -s zsh` from the config directory via subshell, cache it, and apply

# Config
MSE_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/mise-env"
MSE_CONFIG_FILES=("mise.toml" ".tool-versions")  # search order
MSE_DEBUG=${MSE_DEBUG:-0}

# Reentry guard to avoid nested chpwd execution
typeset -g MSE_IN_HANDLER=0

_mse_dbg() { (( MSE_DEBUG )) && print -r -- "[mise-env] $*"; }

# Find nearest config file walking up from $PWD
_mse_find_config() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    for f in "${MSE_CONFIG_FILES[@]}"; do
      [[ -f "$dir/$f" ]] && { print -r -- "$dir/$f"; return 0; }
    done
    dir="${dir:h}"
  done
  return 1
}

# Cache paths based on config file path
_mse_cache_paths_for_config() {
  local cfg="$1"
  mkdir -p "$MSE_CACHE_DIR" || true
  local key
  if [[ -n "$cfg" ]]; then
    key="$(printf "%s" "$cfg" | sha1sum 2>/dev/null | awk '{print $1}')"
    [[ -z "$key" ]] && key="$(printf "%s" "$cfg" | shasum | awk '{print $1}')"
  else
    key="no-config"
  fi
  local base="$MSE_CACHE_DIR/$key"
  print -r -- "$base.env" "$base.meta"
}

# Meta read/write (store cfg_path and mtime for basic staleness check)
_mse_read_meta() {
  local meta="$1"
  [[ -f "$meta" ]] || return 1
  local cfg_path cfg_mtime
  cfg_path="$(grep '^cfg_path=' "$meta" | sed -E 's/^cfg_path=//')"
  cfg_mtime="$(grep '^cfg_mtime=' "$meta" | sed -E 's/^cfg_mtime=//')"
  print -r -- "$cfg_path" "$cfg_mtime"
}
_mse_write_meta() {
  local meta="$1" cfg="$2" mtime="$3"
  {
    print -r -- "cfg_path=$cfg"
    print -r -- "cfg_mtime=$mtime"
    print -r -- "written_at=$(date +%s)"
  } >"$meta"
}

# File mtime portable-ish
_mse_mtime() {
  local f="$1"
  [[ -f "$f" ]] || { print -r -- "0"; return 0; }
  if stat -f "%m" "$f" >/dev/null 2>&1; then
    stat -f "%m" "$f"
  else
    stat -c "%Y" "$f" 2>/dev/null || print -r -- "0"
  fi
}

# Apply env from a file (eval export lines)
_mse_apply_env_file() {
  local envfile="$1"
  [[ -f "$envfile" ]] || return 1
  eval "$(<"$envfile")"
  return 0
}

# Compute env via mise for the config directory without changing parent PWD
_mse_compute_and_apply() {
  local cfg="$1" cache_env="$2" cache_meta="$3"
  local cfg_dir=""
  [[ -n "$cfg" ]] && cfg_dir="${cfg:h}"

  local out rc
  if [[ -n "$cfg_dir" ]]; then
    out="$(cd "$cfg_dir" && mise hook-env -s zsh 2>&1)"
    rc=$?
  else
    out="$(mise hook-env -s zsh 2>&1)"
    rc=$?
  fi

  if (( rc != 0 )); then
    _mse_dbg "mise hook-env failed (dir=${cfg_dir:-$PWD}): $out"
    return 1
  fi

  printf "%s\n" "$out" >"$cache_env"
  local mtime="$(_mse_mtime "$cfg")"
  _mse_write_meta "$cache_meta" "$cfg" "$mtime"
  _mse_dbg "cached env -> $cache_env (cfg=$cfg mtime=$mtime)"

  # Apply the newly computed env
  eval "$out"
  _mse_dbg "applied computed env"
  return 0
}

mse_chpwd_handler() {
  # Prevent reentry if something inside triggers chpwd indirectly
  (( MSE_IN_HANDLER )) && return 0
  MSE_IN_HANDLER=1

  local cfg
  if cfg="$(_mse_find_config)"; then
    _mse_dbg "cfg found: $cfg"
  else
    cfg=""
    _mse_dbg "no cfg for $PWD"
  fi

  local cache_env cache_meta
  read -r cache_env cache_meta < <(_mse_cache_paths_for_config "$cfg")

  local cfg_mtime curr_meta_cfg curr_meta_mtime
  cfg_mtime="$(_mse_mtime "$cfg")"
  read -r curr_meta_cfg curr_meta_mtime < <(_mse_read_meta "$cache_meta" || echo)

  # If cache exists and appears current, apply it
  if [[ -f "$cache_env" && "$curr_meta_cfg" == "$cfg" && "$curr_meta_mtime" == "$cfg_mtime" ]]; then
    if _mse_apply_env_file "$cache_env"; then
      _mse_dbg "applied cached env: $cache_env"
      MSE_IN_HANDLER=0
      return 0
    else
      _mse_dbg "failed to apply cached env, recomputing"
    fi
  else
    _mse_dbg "no current cache, recomputing"
  fi

  # Compute via mise and apply
  _mse_compute_and_apply "$cfg" "$cache_env" "$cache_meta"

  MSE_IN_HANDLER=0
}

# Register hook and run once
autoload -U add-zsh-hook
add-zsh-hook chpwd mse_chpwd_handler
mse_chpwd_handler
