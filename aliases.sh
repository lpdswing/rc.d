export GREP_COLOR='1;31'
export LC_ALL="zh_CN.UTF-8"

# PATH setup
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ "$(uname)" = "Darwin" ]] && export PATH="/usr/local/sbin:$PATH"

# Common aliases
alias l='ls -Clho'
alias ll='ls -ClhF'
alias la='ls -A'
alias lla='ls -ClhFA'
alias rs='rsync -cvrzP --exclude={.git,.hg,.svn,.venv,.DS_Store}'
alias grep='grep -I --color=auto --exclude-dir={.git,.hg,.svn,.venv}'
alias psgrep='ps ax|grep -v grep|grep'
alias tree='tree -C --dirsfirst'
alias ping='ping -c 10'
alias rmds='find . -type f -name .DS_Store -delete'

# macOS specific
if [[ "$(uname)" = "Darwin" ]]; then
    alias tailf='tail -F'
fi

# Python aliases
alias py='python3'
alias ipy='ipython'
alias jpy='jupyter notebook'
alias rmpyc='find . | grep -wE "py[co]|__pycache__" | xargs rm -rvf'
alias pygrep='grep --include="*.py"'
alias serve='python3 -m http.server'

# Git aliases
alias gdf='git difftool'
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gmg='git merge --no-commit --squash'
