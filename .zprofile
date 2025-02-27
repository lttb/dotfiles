export NVIM_LISTEN_ADDRESS="/tmp/nvimsocket nvim"

export EDITOR="nvim"

export XDG_CONFIG_HOME="$HOME/.config"

export CLICOLOR=1

# PATH {{{

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# pnpm {{{
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# }}}

export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# ruby {{{
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
# }}}

# export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
# export PATH="$PATH:$GEM_HOME/bin"

export PATH="$PATH:$HOME/.yarn/bin"

export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"

export PATH=/opt/homebrew/bin:$PATH

export PATH="$HOME/.bun/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"

export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
# }}}
