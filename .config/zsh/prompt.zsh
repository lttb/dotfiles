terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
PS1_2="
%F{245}%~"
PS1="%{$terminfo_down_sc$PS1_2$terminfo[rc]%}"

preexec() {
  local BREAK_LINE="
"
  local black=0
  local yellow=3
  local blue=4
  local cyan=6

  zstyle ':zim:duration-info' format '%B%F{cyan}%d%f%b'

  zstyle ':zim:git-info:stashed' format '≡'
  zstyle ':zim:git-info:unindexed' format '*'
  zstyle ':zim:git-info:indexed' format '🚀'
  zstyle ':zim:git-info:ahead' format '⇡'
  zstyle ':zim:git-info:behind' format '⇣'
  zstyle ':zim:git-info:keys' format \
      'status' '%S%I%i%A%B' \
      'prompt' '%%F{245}%b%c%s${(e)git_info[status]:+" %F{245}[${(e)git_info[status]}]"}%f%%b'

  local styled_wd="%B%F{$black}%~"
  local styled_duration_info="${VIRTUAL_ENV:+" via %B%F{yellow}${VIRTUAL_ENV:t}%b%f"}${duration_info}"
  local styled_git_branch='%f%b${(e)git_info[prompt]}'
  local styled_error="%B%(?..%F{124}∙)%f%b"

  PS1="
$styled_wd $styled_git_branch $styled_duration_info$styled_error
"

  RPROMPT=""
}

precmd() {}

