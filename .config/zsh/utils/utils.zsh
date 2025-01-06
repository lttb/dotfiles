# Aliases {{{
alias local-postgres="docker run -d --env-file ~/.secrets/dev/.env.pg  -p 5432:5432 -v pgdata:/var/lib/postgresql/data --rm --name local-postgres postgres"

alias d='\
    DOTFILES=1 \
    GIT_DIR=$HOME/.local/share/yadm/repo.git \
    GIT_WORK_TREE=$HOME \
    nvim -c ":cd ~/.config"'
alias dd='\
    DOTFILES=1 \
    GIT_DIR=$HOME/.local/share/yadm/repo.git \
    GIT_WORK_TREE=$HOME \
    nv -- -c ":cd ~/.config"'

alias cl="clear"

alias nv="neovide --frame transparent --title-hidden"

alias lg="lazygit"
alias gi="gitui -t themes/catppuccin/theme/frappe.ron"

alias ll="eza --tree --level 1"

# inspired by omz
alias gst="git status"
alias ggp="git push"
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
# }}}
