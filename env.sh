# ============================================================================
# 环境变量 & PATH 配置
# ============================================================================

export GREP_COLORS='mt=1;31'
export LC_ALL="zh_CN.UTF-8"
# export LESS='-NRF'
# export LESSOPEN='| pygmentize -g -O style=native %s'

# ============================================================================
# macOS - Homebrew 环境
# ============================================================================

if [[ "$(uname)" = "Darwin" ]]; then
    export HOMEBREW_NO_AUTO_UPDATE=true
    # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
    export HOMEBREW_NO_INSTALL_CLEANUP=1
fi

# ============================================================================
# Homebrew 开发标志
# ============================================================================

if command -v brew >/dev/null 2>&1; then
    BREWHOME="${HOMEBREW_PREFIX:-/usr/local}"
    export LDFLAGS="-L$BREWHOME/lib"
    export CPPFLAGS="-I$BREWHOME/include"
    export PKG_CONFIG_PATH="$BREWHOME/lib/pkgconfig"
fi

# ============================================================================
# Rust
# ============================================================================

if [[ -d "$HOME/.cargo" && ! ":${PATH}:" =~ "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# ============================================================================
# Golang
# ============================================================================

if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/src/Golang"
    export PATH="$GOPATH/bin:$PATH"
    export GOPROXY="https://goproxy.cn"
fi

# ============================================================================
# pnpm
# ============================================================================

if [[ -d "$HOME/.local/share/pnpm" ]]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
fi
