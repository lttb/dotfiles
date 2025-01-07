# vim:fileencoding=utf-8:foldmethod=marker

[ -z "$ZPROF" ] || zmodload zsh/zprof

setopt autocd

WORDCHARS=${WORDCHARS//[\/-]/}

source $HOME/.config/zsh/sheldon.zsh

zsh-defer safe_source $HOME/.secrets/private.zsh

[ -z "$ZPROF" ] || zprof

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
