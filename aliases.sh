# ============================================================================
# 通用别名
# ============================================================================

# ls → eza
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons'
    alias l='eza -lhF --icons'
    alias ll='eza -lhF --icons'
    alias la='eza -a --icons'
    alias lla='eza -lahF --icons'
    alias tree='eza --tree --icons'
else
    alias l='ls -ClhoF'
    alias ll='ls -ClhF'
    alias la='ls -A'
    alias lla='ls -ClhFA'
fi
# alias rm='rm -v'  # 删目录会刷屏，按需启用
alias cp='cp -nv'
alias mv='mv -nv'
alias ln='ln -v'
alias rs="rsync -crvzptHP --exclude='.[A-Za-z0-9._-]*' --exclude={__pycache__,'*.pyc'}"
alias grep="grep -I --color=auto --exclude-dir='.[A-Za-z0-9._-]*'"
alias psgrep='pscm|grep -v grep|grep'
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
alias rmpyc='find . | grep -wE "py[co]|__pycache__" | xargs rm -rvf'

# uv
if command -v uv >/dev/null 2>&1; then
    alias pip='uv pip'
    alias pip3='uv pip'
    alias venv='uv venv'
    alias upy='uv python'
fi

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
