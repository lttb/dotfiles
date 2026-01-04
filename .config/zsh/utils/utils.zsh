# vim:fileencoding=utf-8:foldmethod=marker

# Aliases {{{
alias local-postgres="docker run -d --env-file ~/.secrets/dev/.env.pg  -p 5432:5432 -v pgdata:/var/lib/postgresql/data --rm --name local-postgres postgres"

alias d='\
    DOTFILES=1 \
    GIT_DIR=$HOME/.local/share/yadm/repo.git \
    GIT_WORK_TREE=$HOME \
    nvim -c ":cd ~"'
alias dd='\
    DOTFILES=1 \
    GIT_DIR=$HOME/.local/share/yadm/repo.git \
    GIT_WORK_TREE=$HOME \
    nv -- -c ":cd ~"'

alias cl="clear"

alias nv="neovide --frame transparent --title-hidden"

alias lg="lazygit"
alias gi="gitui -t themes/catppuccin/theme/frappe.ron"

alias ll="eza --tree --level 1"

# inspired by omz
alias gst="git status"
alias ggp="git push"
alias gco="git checkout"
alias gcam='git commit --all --message'
alias gd='git diff'

alias dev='docker run --rm -it -v "$(pwd)":/app -w /app -v "$HOME/.config/nvim":"/root/.config/nvim" -e LANG=en_US.UTF-8 my-neovim zsh'

alias fnoxenv='eval $(fnox hook-env -s zsh)'
# }}}

# Functions {{{
safe_source() {
  if [ -f "$1" ]; then . "$1"; fi
}

code() { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*; }

gob() {
  branch_search="$(
    git branch --sort=-committerdate --format="%(if)%(HEAD)%(then)*%(else) %(end) %(refname:short): [%(committerdate)] @%(authorname) %(subject)" |
      fzf |
      sed 's/:.\{1,\}//' |
      sed 's/^[* ]*//'
  )"

  git checkout $branch_search
}

yb() {
  yabai -m query --windows |
    jq ".[] | select(.app | test(\"$1\")).id" |
    xargs -L1 sh -c "
        yabai -m window \$0 --toggle float &&
        yabai -m window \$0 $2
      "
}

ybc() {
  yabai -m query --windows |
    jq ".[] | select(.app | test($(yabai -m query --windows --window | jq '.app'))).id" |
    xargs -L1 sh -c "
        yabai -m window \$0 --toggle float &&
        yabai -m window \$0 $1
      "
}

get_theme_mode() {
  # Query Kitty's background color using `kitten @ get-colors`
  local bg_color
  bg_color=$(kitty @ get-colors | grep "^background " | tr -s ' ' | cut -d' ' -f2)

  # Ensure we have a valid background color
  if [[ -z "$bg_color" ]]; then
    echo "unknown"
    return
  fi

  # Extract RGB values from the hex color (e.g., "#RRGGBB")
  local r=${bg_color:1:2}
  local g=${bg_color:3:2}
  local b=${bg_color:5:2}

  # Convert hexadecimal to decimal
  r=$((16#$r))
  g=$((16#$g))
  b=$((16#$b))

  # Calculate relative luminance (simplified formula)
  local luminance=$(((299 * r + 587 * g + 114 * b) / 1000))

  # Threshold for determining dark vs light (128 is a common midpoint)
  if ((luminance < 128)); then
    echo "dark"
  else
    echo "light"
  fi
}

zj() {
  if [[ $THEME_MODE == "dark" ]]; then
    zellij options --theme nord
  else
    zellij options --theme catppuccin-latte
  fi
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# }}}
