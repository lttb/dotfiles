# based on https://github.com/woefe/git-prompt.zsh/blob/0193adeb09fbc51fac738081a4718a3cf8427ff8/examples/pure.zsh#L10C1-L28C50

ZSH_GIT_PROMPT_FORCE_BLANK=1
ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_no_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_no_bold[grey]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg_no_bold[cyan]%}↓"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_no_bold[cyan]%}↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

setopt prompt_subst

terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
PS1_2="
%F{245}%~"
PS1="%{$terminfo_down_sc$PS1_2$terminfo[rc]%}"

clear

preexec() {
  # In the second line of the prompt $psvar[12] is read
  PROMPT=$'
%F{blue}%~%f %F{242}$(gitprompt)%f
'

  RPROMPT=''
}

zle-line-init() {
  emulate -L zsh

  [[ $CONTEXT == start ]] || return 0

  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done

  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  PROMPT='❯ '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt

  if ((ret)); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}

zle -N zle-line-init
