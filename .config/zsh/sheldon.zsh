shldn() {
  mkdir -p "$HOME/.zsh" && eval "$(sheldon source > "$HOME/.zsh/sheldon.zsh")"
}

[ ! -f "$HOME/.zsh/sheldon.zsh" ] && shldn

source $HOME/.zsh/sheldon.zsh
