# ============================================================================
# 环境变量
# ============================================================================

export GREP_COLORS='mt=1;31'
export LC_ALL="zh_CN.UTF-8"
# export LESS='-NRF'
# export LESSOPEN='| pygmentize -g -O style=native %s'

# PATH 设置（避免重复添加）
[[ ! ":${PATH}:" =~ "/usr/local/sbin" ]] && export PATH="/usr/local/sbin:$PATH"
[[ ! ":${PATH}:" =~ "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ ! ":${PATH}:" =~ "$HOME/.local/utils" ]] && export PATH="$HOME/.local/utils:$PATH"

# ============================================================================
# 通用别名
# ============================================================================

alias l='ls -ClhoF'
alias li='ls -Clhoi'
alias ll='ls -ClhF'
alias la='ls -A'
alias lla='ls -ClhFA'
# alias rm='rm -v'  # 删目录会刷屏，按需启用
alias cp='cp -nv'
alias mv='mv -nv'
alias ln='ln -v'
alias rs="rsync -crvzptHP --exclude='.[A-Za-z0-9._-]*' --exclude={__pycache__,'*.pyc'}"
alias grep="grep -I --color=auto --exclude-dir='.[A-Za-z0-9._-]*'"
alias psgrep='pscm|grep -v grep|grep'
alias tree='tree -N -C --dirsfirst'
alias tailf='tail -F'
alias rmds='find . -type f -name .DS_Store -delete'

# 网络工具
alias ping='ping -i 0.2 -c 10'
alias ping6='ping6 -i 0.2 -c 10'
alias ip4="ifconfig | grep -w inet | awk '{print \$2}'| sort"
alias ip6="ifconfig | grep -w inet6 | awk '{print \$2}'| sort"

# tmux
alias tm='tmux attach || tmux'

# ============================================================================
# macOS 专用
# ============================================================================

if [[ "$(uname)" = "Darwin" ]]; then
    export HOMEBREW_NO_AUTO_UPDATE=true
    # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
    export HOMEBREW_NO_INSTALL_CLEANUP=1

    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    alias lock="sudo chflags schg"
    alias unlock="sudo chflags noschg"
fi

# ============================================================================
# Python
# ============================================================================

alias py='python'
alias ipy='ipython'
alias httpserver='python -m http.server'
alias pip-search='pip_search'
alias rmpyc='find . | grep -wE "py[co]|__pycache__" | xargs rm -rvf'
alias pygrep='grep --include="*.py"'

# uv - pip
if command -v uv >/dev/null 2>&1; then
    alias pip='uv pip'
    alias pip3='uv pip'
fi

alias venv='uv venv'
alias upy='uv python'

# ============================================================================
# Git
# ============================================================================

alias gad='git add'
alias gst='git status -sb'
alias gdf='git difftool'
alias glg='git log --stat --graph --max-count=10'
alias gpl='git pull'
alias gci='git commit'
alias gco='git checkout'
alias gsw='git switch'
alias gmg='git merge --no-commit --squash'

# ============================================================================
# 开发环境
# ============================================================================

# Homebrew
if command -v brew >/dev/null 2>&1; then
    BREWHOME="${HOMEBREW_PREFIX:-/usr/local}"
    export LDFLAGS="-L$BREWHOME/lib"
    export CPPFLAGS="-I$BREWHOME/include"
    export PKG_CONFIG_PATH="$BREWHOME/lib/pkgconfig"
fi

# Rust
if [[ -d "$HOME/.cargo" && ! ":${PATH}:" =~ "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Golang
if command -v go >/dev/null 2>&1; then
    export GOPATH="$HOME/src/Golang"
    export PATH="$GOPATH/bin:$PATH"
    export GOPROXY="https://goproxy.cn"
fi

# pnpm
if [[ -d "$HOME/.local/share/pnpm" ]]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    alias npm='pnpm'
    alias npx='pnpx'
fi
