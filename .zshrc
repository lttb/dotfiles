# vim:fileencoding=utf-8:foldmethod=marker

[ -z "$ZPROF" ] || zmodload zsh/zprof

eval "$(sheldon source)"

bindkey -s '^F' 'ji^M'

WORDCHARS=${WORDCHARS//[\/]}

zsh-defer source "$HOME/.cargo/env"
zsh-defer _evalcache zoxide init --cmd j zsh
zsh-defer _evalcache fnm env --use-on-cd --log-level=quiet
zsh-defer _evalcache fzf --zsh

zsh-defer safe_source "${HOME}/.secrets/private.zsh"

[ -z "$ZPROF" ] || zprof
