# vim:fileencoding=utf-8:foldmethod=marker

[ -z "$ZPROF" ] || zmodload zsh/zprof

WORDCHARS=${WORDCHARS//[\/]}

source ~/.config/zsh/sheldon.zsh

safe_source "${HOME}/.secrets/private.zsh"

[ -z "$ZPROF" ] || zprof

