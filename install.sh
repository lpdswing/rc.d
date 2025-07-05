#!/bin/bash

CURRENT_DIR=$PWD

RC_DIR="$HOME/.rc.d"
LOCAL_BIN="$HOME/.local/bin"

BREW_URL='https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
OH_MY_ZSH_URL='https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'
RC_URL='https://github.com/lpdswing/rc.d.git'



function exist() {
    which $1 > /dev/null
    return $?
}


function ensure_rc() {
    if [ ! -d $RC_DIR ]; then
        git clone $RC_URL $RC_DIR
    fi
}


function install_brew() {
    echo "exec: install_brew"

    if [[ `uname` == 'Darwin' ]] && ! `exist brew`
    then
        xcode-select --install
        ruby -e "$(curl -fsSL $BREW_URL)"
    fi

    echo 'done!'
}



function install_sys_packages() {
    echo "exec: install_sys_packages"

    ensure_rc

    if [[ `uname` == 'Darwin' ]]; then
        echo "installing brew packages ..."
        brew -v update
        brew install `cat $RC_DIR/packages/brew-pkg`

    elif `exist apt-get`; then
        echo "installing deb packages ..."
        sudo apt update -y
        sudo apt upgrade -y
        sudo apt install -y `cat $RC_DIR/packages/apt-pkg`

    else
        echo 'not found any package installer'
    fi

    echo 'done!'
}



function install_ohmyzsh() {
    echo "exec: install_ohmyzsh"

    if [ ! -d $HOME/.oh-my-zsh ]; then
        bash -c "$(curl -fsSL $OH_MY_ZSH_URL)"
    else
        echo "oh-my-zsh is already installed"
    fi
    echo 'done!'
}



function pip_config() {
    echo "exec: pip config"
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    echo 'done!'
}


function setup_env() {
    echo "exec: setup_env"

    ensure_rc

    # link rc files
    cd $HOME
    ln -sfv .rc.d/gitconfig .gitconfig
    ln -sfv .rc.d/vimrc .vimrc
    ln -sfv .rc.d/zshrc .zshrc
    ln -sfv .rc.d/bashrc .bashrc
    ln -sfv .rc.d/tmux.conf .tmux.conf

    touch $HOME/.zshrc.local

    echo 'done!'
}


function setup_zsh_plugin() {
    echo "exec: setup_zsh_plugin"

    ensure_rc

    if [ -d "$HOME/.oh-my-zsh/custom/" ]; then
        git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    else
        echo "Please install ohmyzsh first."
        exit 1
    fi

    echo 'done!'
}




cat << EOF
select a function code:
===============================
【 1 】 Install brew
【 2 】 Install oh-my-zsh
【 3 】 Setup env
【 4 】 Setup zsh plugin
【 5 】 pip config
【 * 】 Exit
===============================
EOF


if [[ -n $1 ]]; then
    choice=$1
    echo "exec: $1"
else
    read -p "select: " choice
fi

case $choice in
    1) install_brew;;
    2) install_ohmyzsh;;
    3) setup_env;;
    4) setup_zsh_plugin;;
    5) pip_config;;
    *) echo 'Bye' && exit;;
esac


cd $CURRENT_DIR
