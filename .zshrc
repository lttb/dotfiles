# vim:fileencoding=utf-8:foldmethod=marker

[ -z "$ZPROF" ] || zmodload zsh/zprof

setopt autocd

WORDCHARS=${WORDCHARS//[\/]/}

source $HOME/.config/zsh/sheldon.zsh

bindkey -v

# Yank to the system clipboard
function vi-yank-xclip {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

function br_detached {
  local cmd_file=$(mktemp)

  # Launch broot in a new split window and capture its raw output as the window ID
  local broot_window_id=$(kitty @ launch --allow-remote-control --cwd=current --location=hsplit broot --outcmd "$cmd_file" "$@")

  # Wait for the broot window to close
  while kitty @ ls --match id:"$broot_window_id" >/dev/null 2>&1; do
    sleep 0.1
  done

  # Check if broot wrote a command to the file
  if [[ -s "$cmd_file" ]]; then
    cmd=$(<"$cmd_file")
    rm -f "$cmd_file"
    # Execute the command directly in this shell
    BUFFER="$cmd"
    zle accept-line
  else
    rm -f "$cmd_file"
  fi
}

zle -N br_widget br_detached

bindkey "^F" br_widget

safe_source $HOME/.secrets/private.zsh

[ -z "$ZPROF" ] || zprof
