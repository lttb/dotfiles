# Cache the terminfo strings
local terminfo_down=$terminfo[cud1]
local terminfo_up=$terminfo[cuu1]

# Precompute the fixed part of the prompt
local PS1_static="%{$terminfo_down$terminfo_up$terminfo[sc]$terminfo_down%}"

# Function to generate the dynamic part of the prompt
prompt_dir() {
  print -Pn $'\n%F{245}%~'
}

# Set the prompt
setopt prompt_subst
PS1="${PS1_static}\$(prompt_dir)%{$terminfo[rc]%}"

preexec() {
  # In the second line of the prompt $psvar[12] is read
  PROMPT=$'
%F{blue}%~%f %F{242}$(gitprompt)%f
'

  RPROMPT=''
}

precmd() {}

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
