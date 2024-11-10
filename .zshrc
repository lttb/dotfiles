# vim:fileencoding=utf-8:foldmethod=marker

# autoload -U +X bashcompinit && bashcompinit
# autoload -U +X compinit && compinit

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
WORDCHARS=${WORDCHARS//[\/\(\)\-]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

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

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

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
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

HISTORY_IGNORE="*'z#*'"

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=102,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'

source ${HOME}/.config/zsh/prompt.zsh

bindkey -s '^F' 'ji^M'

# Aliases {{{
alias local-postgres="docker run -d --env-file ~/.secrets/dev/.env.pg  -p 5432:5432 -v pgdata:/var/lib/postgresql/data --rm --name local-postgres postgres"

alias d='\
    GIT_DIR=$HOME/.local/share/yadm/repo.git \
    GIT_WORK_TREE=$HOME \
    nvim -c ":cd ~"'

alias cl="clear"

alias nv="neovide --frame transparent --title-hidden"

alias ssh="kitty +kitten ssh"

alias lg="lazygit"
alias gi="gitui -t themes/catppuccin/theme/frappe.ron"

alias yarn-auth='f(){npm_config_registry=https://registry.npmjs.org npx google-artifactregistry-auth};f'

# }}}

# Functions {{{

safe_source() {
  if [ -f "$1" ]; then . "$1"; fi
}

code() { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

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

# }}}

# GCP {{{

# }}}

# fzf {{{

# catppuccin frappe
# @see https://github.com/catppuccin/fzf
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
# --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
# --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# rose-pine light
# export FZF_DEFAULT_OPTS="
# 	--color=fg:#797593,bg:#faf4ed,hl:#d7827e
# 	--color=fg+:#575279,bg+:#f2e9e1,hl+:#d7827e
# 	--color=border:#dfdad9,header:#286983,gutter:#faf4ed
# 	--color=spinner:#ea9d34,info:#56949f,separator:#dfdad9
# 	--color=pointer:#907aa9,marker:#b4637a,prompt:#797593"

# rose-pine dark
# export FZF_DEFAULT_OPTS="
# 	--color=fg:#908caa,bg:#191724,hl:#ebbcba
# 	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
# 	--color=border:#403d52,header:#31748f,gutter:#191724
# 	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
# 	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

# github light
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS" \
#   --color=fg:#656d76,bg:#ffffff,hl:#ffffff \
#   --color=fg+:#1F2328,bg+:#deeeff,hl+:#953800 \
#   --color=info:#9a6700,prompt:#0969da,pointer:#8250df \
#   --color=marker:#1a7f37,spinner:#24292f,header:#eff1f3"

# custom light
export FZF_DEFAULT_OPTS="
	--color=fg:#797593,bg:#ffffff,hl:#d7827e
	--color=fg+:#575279,bg+:#f2e9e1,hl+:#d7827e
	--color=border:#dfdad9,header:#286983,gutter:#faf4ed
	--color=spinner:#ea9d34,info:#56949f,separator:#dfdad9
	--color=pointer:#907aa9,marker:#b4637a,prompt:#797593"

source <(fzf --zsh)

# }}}

eval "$(fnm env --use-on-cd --log-level=quiet)"

eval "$(zoxide init --cmd j zsh)"

safe_source ${HOME}/.config/broot/launcher/bash/br

# The next line updates PATH for the Google Cloud SDK.
# safe_source '~/google-cloud-sdk/path.zsh.inc'
safe_source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"

# The next line enables shell command completion for gcloud.
# safe_source "${HOME}/google-cloud-sdk/completion.zsh.inc"
safe_source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

safe_source "${HOME}/.secrets/private.zsh"

# bun completions
[ -s "/opt/homebrew/Cellar/bun/1.0.23/share/zsh/site-functions/_bun" ] && source "/opt/homebrew/Cellar/bun/1.0.23/share/zsh/site-functions/_bun"

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
