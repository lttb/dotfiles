# vim:fileencoding=utf-8:foldmethod=marker

# Start configuration added by Zim install {{{
#
# User configuration sourced by all invocations of the shell
#

# Define Zim location
: ${ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim}
# }}} End configuration added by Zim install

. "$HOME/.cargo/env"

# make term compatible with zsh-notify
# export TERM_PROGRAM="Apple_Terminal"

export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket nvim"

export EDITOR="nvim"

export XDG_CONFIG_HOME="$HOME/.config"

# PATH {{{

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH

export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/share/neovim/bin

# pnpm {{{
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# }}}

# ruby {{{
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
# }}}

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# }}}

