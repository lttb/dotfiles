setopt NO_BG_NICE
setopt NO_NOTIFY

mise_env_tmp="/tmp/mise_env_$USER"

function async_mise_env() {
  rm -f "$mise_env_tmp" "${mise_env_tmp}.done"
  mise_env_tmp="$mise_env_tmp" zsh -c '/opt/homebrew/bin/mise hook-env -s zsh -f > "$mise_env_tmp" 2>/dev/null && touch "${mise_env_tmp}.done"' &!
}

function source_mise_env() {
  if [[ -f "${mise_env_tmp}" && -f "${mise_env_tmp}.done" ]]; then
    source "$mise_env_tmp"
    rm -f "$mise_env_tmp" "${mise_env_tmp}.done"
  fi
}

add-zsh-hook chpwd async_mise_env
add-zsh-hook precmd source_mise_env
