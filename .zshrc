# vim:fileencoding=utf-8:foldmethod=marker

[ -z "$ZPROF" ] || zmodload zsh/zprof

setopt autocd

WORDCHARS=${WORDCHARS//[\/-]/}

source $HOME/.config/zsh/sheldon.zsh

zsh-defer safe_source $HOME/.secrets/private.zsh

export DELTA_FEATURES="+light"

[ -z "$ZPROF" ] || zprof
