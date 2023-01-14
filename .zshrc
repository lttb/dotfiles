# vim:fileencoding=utf-8:foldmethod=marker

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
# setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
# WORDCHARS=${WORDCHARS//[\/]}


# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'


#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
# ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it does not exist or it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#


# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# }}} End configuration added by Zim install

ZSH_AUTOSUGGEST_USE_ASYNC="yes"

# HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=gray,fg=white,bold'

# PROMPT {{{

# RPROMPT="%F{245}%~"

PS1='%(2L.%B%F{yellow}(%L)%f%b .)%(!.%B%F{red}%n%f%b in .${SSH_TTY:+"%B%F{yellow}%n%f%b in "})${SSH_TTY:+"%B%F{green}%m%f%b in "}%B%F{cyan}%~%f%b${(e)git_info[prompt]}${VIRTUAL_ENV:+" via %B%F{yellow}${VIRTUAL_ENV:t}%b%f"}${duration_info}
%B%(1j.%F{blue}*%f .)%(?.%F{green}.%F{red}%?'

PS1=""
PS1="%F{245}%~
"

terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
PS1_2="
%F{245}%~"
PS1="%{$terminfo_down_sc$PS1_2$terminfo[rc]%}"

preexec() {
  local BREAK_LINE="
"
  local grey=245
  local red=1
  local yellow=3
  local blue=4
  local magenta=5
  local cyan=6
  local white=7

  zstyle ':zim:duration-info' format '%B%F{cyan}%d%f%b'

  zstyle ':zim:git-info:stashed' format '≡'
  zstyle ':zim:git-info:unindexed' format '*'
  zstyle ':zim:git-info:indexed' format '🚀'
  zstyle ':zim:git-info:ahead' format '⇡'
  zstyle ':zim:git-info:behind' format '⇣'
  zstyle ':zim:git-info:keys' format \
      'status' '%S%I%i%A%B' \
      'prompt' '%%F{245}%b%c%s${(e)git_info[status]:+" %F{245}[${(e)git_info[status]}]"}%f%%b'

  local styled_wd="%F{$blue}%~"
  local styled_duration_info="${VIRTUAL_ENV:+" via %B%F{yellow}${VIRTUAL_ENV:t}%b%f"}${duration_info}"
  local styled_git_branch='%f%b${(e)git_info[prompt]}'
  local styled_error="%B%(?..%F{124}∙)%f%b"

  PS1="
$styled_wd $styled_git_branch $styled_duration_info$styled_error
"

  RPROMPT=""

  # local EXIT="$?"
  # local styled_error=""

  # if [[ $EXIT -eq 0 ]]; then
  #   styled_error=" x"
  # else
  #   styled_error=" ●"
  # fi

  # PS1+="$styled_error"
#  RPROMPT="$styled_duration_info"
}

precmd() {

}
# }}}

# Key Bindings {{{
# kitty
bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word # ⌥→

backward-kill-dir () {
    local WORDCHARS=${WORDCHARS/\/}
    zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^[^?' backward-kill-dir # ⌥-bksp
# }}}

# aliases {{{
alias local-postgres="docker run -d --env-file ~/.secrets/dev/.env.pg  -p 5432:5432 -v pgdata:/var/lib/postgresql/data --rm --name local-postgres postgres"

# alias dotfiles='cd ~ &&\
#     export GIT_DIR=$HOME/.local/share/yadm/repo.git &&\
#     export GIT_WORK_TREE=$HOME &&\
#     nvim $(git ls-files --exclude-standard | tr "\r\n" " ")'

alias d='\
    GIT_DIR=$HOME/.local/share/yadm/repo.git \
    GIT_WORK_TREE=$HOME \
    nvim -- ":cd ~"'

alias cl="clear"

alias nv="neovide --multigrid --frame buttonless"

alias ssh="kitty +kitten ssh"

# alias ni='n $(cat .nvmrc)'
# alias nu='n use $(cat .nvmrc)'

# }}}

# functions {{{

code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

gob() {
    branch_search="$(\
        git branch --sort=-committerdate --format="%(if)%(HEAD)%(then)*%(else) %(end) %(refname:short): [%(committerdate)] @%(authorname) %(subject)" \
        | fzf \
        | sed 's/:.\{1,\}//' \
        | sed 's/^[* ]*//' \
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

lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# }}}

# GCP {{{
# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/lttb/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/lttb/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/lttb/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/lttb/google-cloud-sdk/completion.zsh.inc'; fi
# }}}

# required for zsh-notify
zmodload zsh/datetime

# npm completion {{{
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
# }}}

# fzf{{{
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
# --color=fg:#4b505b,bg:#fafafa,hl:#5079be
# --color=fg+:#4b505b,bg+:#fafafa,hl+:#3a8b84
# --color=info:#88909f,prompt:#d05858,pointer:#b05ccc
# --color=marker:#608e32,spinner:#d05858,header:#3a8b84'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}

# broot {{{
source ~/.config/broot/launcher/bash/br
# }}}

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

eval "$(fnm env)"
