export GREP_COLOR='1;31'
###
 # @Author: lpdswing
 # @Date: 2020-11-06 15:40:19
 # @LastEditTime: 2021-02-20 15:24:39
 # @LastEditors: Please set LastEditors
 # @Description: In User Settings Edit
 # @FilePath: /.rc.d/aliases.sh
###
export LC_ALL="zh_CN.UTF-8"

if [ `uname` = "Darwin" ]; then
    export PATH="/usr/local/sbin:$PATH"
fi

if [ -d $HOME/.local/bin ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Custom alias
alias l='ls -Clho'
alias ll='ls -ClhF'
alias la='ls -A'
alias lla='ls -ClhFA'
alias rs='rsync -cvrzP --exclude={.git,.hg,.svn,.venv,.DS_Store}'
alias httpserver='python -m SimpleHTTPServer'
alias httpserver3='python -m http.server'
alias grep='grep -I --color=auto --exclude-dir={.git,.hg,.svn,.venv}'
alias psgrep='ps ax|grep -v grep|grep'
alias tree='tree -C --dirsfirst'
alias less='less -N'
alias aria='aria2c -c -x 16 --file-allocation=none'
alias axel='axel -n 30'
alias ping='ping -i 0.5 -c 10'
alias vnccnt='netstat -nat|grep -w 5900|grep -c ESTABLISHED '

# macOS alias
if [ `uname` = "Darwin" ]; then
    export HOMEBREW_NO_AUTO_UPDATE=true  # disable homebrew auto update
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"
    alias tailf='tail -F'
    alias rmds='find . -type f -name .DS_Store -delete'
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    alias power="echo Power: $(pmset -g batt|awk 'NR==2{print $3}'|sed 's/;//g')"
    alias clsattr="xattr -lr ."
    alias tree='tree -N'
fi

# Python alias
alias py='python'
alias py2='python2'
alias py3='python3'
alias ipy='ipython'
alias ipy2='ipython2'
alias ipy3='ipython3'
alias venv='python -m venv'
alias virtualenv='python -m venv'
alias jpy='jupyter notebook'
alias pep='pycodestyle --ignore=E501'
alias rmpyc='find . | grep -wE "py[co]|__pycache__" | xargs rm -rvf'
alias pygrep='grep --include="*.py"'
if [[ $plugins =~ 'pip' ]]; then
    unalias pip
fi

# Git alias
alias gst='git status -sb'
alias gstt='git status'
alias gdf='git difftool'
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gco='git checkout'
alias gmg='git merge --no-commit --squash' # merge不产生新commit,并且可以多个commit合并为一个

# brew
if [[ `uname` = "Darwin" ]]; then
    if which brew > /dev/null; then
        # BREWHOME=`brew --prefix`
        BREWHOME="/usr/local"
        export LDFLAGS="-L$BREWHOME/lib"
        export CPPFLAGS="-I$BREWHOME/include"
        export PKG_CONFIG_PATH="$BREWHOME/lib/pkgconfig"
    fi
fi


# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if which pyenv > /dev/null; then
    eval "$(pyenv init -)";
    # eval "$(pyenv virtualenv-init -)"
    # pyenv alias
    alias pyv='pyenv versions'
    alias chpy='pyenv global'
    alias chlpy='pyenv local'
    alias chgpy='pyenv global'
fi

# ssh proxifier
alias ac160='ssh -ND 1081 biomind@192.168.2.160'
alias ac59='ssh -ND 1082 biomind@192.168.10.59'

# golang
if [[ `uname` = "Linux" ]]; then
    export PATH=$PATH:/usr/local/go/bin
fi
