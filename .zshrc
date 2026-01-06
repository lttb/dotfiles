# vim:fileencoding=utf-8:foldmethod=marker

[ -z "$ZPROF" ] || zmodload zsh/zprof

# setopt

export THEME_MODE="${GHOSTTY_THEME_MODE:-${KITTY_THEME_MODE:-light}}"

WORDCHARS=${WORDCHARS//[\/-]/}

source $HOME/.config/zsh/sheldon.zsh

zsh-defer safe_source $HOME/.zsh/mise-dir.zsh

zsh-defer safe_source $HOME/.secrets/private.zsh

export DELTA_FEATURES="+$THEME_MODE"

[ -z "$ZPROF" ] || zprof

# bun completions
# no need as they're handled by sheldon
# @see https://github.com/oven-sh/bun/issues/10897
