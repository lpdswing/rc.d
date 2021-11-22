#!/bin/bash

CURRENT_DIR=$PWD

RC_DIR="$HOME/.rc.d"
LOCAL_BIN="$HOME/.local/bin"

PYTHON_VERSION='3.10.0'
BREW_URL='https://raw.githubusercontent.com/Homebrew/install/master/install'
OH_MY_ZSH_URL='https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh'
PYENV_URL='https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer'
RC_URL='https://github.com/lpdswing/rc.d.git'
FiraCode_Nerd_URL='https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf'
Monaco_Nerd_URL='https://github.com/lpdswing/monaco-nerd-fonts/raw/master/fonts/Monaco%20Nerd%20Font%20Complete.otf'
fonts_dir="${HOME}/.local/share/fonts"
NVM_URL='https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh'

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


function install_softwares_for_macos() {
    echo "exec: install_softwares_for_macos"

    ensure_rc

    for pkg in `cat $RC_DIR/packages/cask-pkg`
    do
        read -p "Do you want to install '$pkg'? (y/n) " confirm
        if [[ $confirm == "y" ]]
        then
            brew install --cask $pkg
        fi
    done

    echo "done!"
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

    elif `exist yum`; then
        echo "installing rpm packages ..."
        sudo yum update
        sudo yum install -y `cat $RC_DIR/packages/yum-pkg`

    else
        echo 'not found any package installer'
    fi

    echo 'done!'
}


function install_fonts() {
    echo "exec: install_fonts"

    if [[ `uname` == 'Darwin' ]]; then
        cd ~/Library/Fonts && curl -fLo "Fira Code Regular Nerd Font Complete.ttf" $FiraCode_Nerd_URL && curl -fLo "Monaco Nerd Font Complete.otf" $Monaco_Nerd_URL
    else
        if [ ! -d "${fonts_dir}" ]; then
            echo "mkdir -p $fonts_dir"
            mkdir -p "${fonts_dir}"
        else
            echo "Found fonts dir $fonts_dir"
        fi
        cd $fonts_dir && curl -fLo "Fira Code Regular Nerd Font Complete.ttf" $FiraCode_Nerd_URL && curl -fLo "Monaco Nerd Font Complete.otf" $Monaco_Nerd_URL
        echo "fc-cache -f"
        fc-cache -f
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


function install_nvm() {
    echo "exec: install_ohmyzsh"

    if [ ! -d $HOME/.nvm ]; then
        curl -o- $NVM_URL | bash
    else
        echo "nvm is already installed"
    fi
    echo 'done!'
}


function install_pyenv() {
    echo "exec: install_pyenv"

    if [ ! -d $HOME/.pyenv ]; then
        curl -L $PYENV_URL | bash
        export PATH="$HOME/.pyenv/bin:$PATH"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
        pyenv update
    else
        echo "pyenv is already installed"
    fi

    echo 'done!'
}


function install_python() {
    echo "exec: install_python"

    if ! pyenv versions | grep $PYTHON_VERSION > /dev/null; then
        pyenv install -kv $PYTHON_VERSION
    else
        echo "Python v$PYTHON_VERSION is already installed"
    fi

    pyenv global $PYTHON_VERSION

    echo 'done!'
}


function install_python_pkg() {
    echo "exec: install_python_pkg"

    ensure_rc

    pyenv global $PYTHON_VERSION
    pip install -r $RC_DIR/packages/python-pkg

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
    ln -sfv .rc.d/myclirc .myclirc

    # link aria2
    mkdir -p $HOME/.aria2
    cd $HOME/.aria2
    ln -sfv $RC_DIR/aria2.conf aria2.conf

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

function install_v2ray() {
    echo "exec: install_v2ray"

    bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

    echo 'done!'
}


function install_all() {
    ensure_rc
    install_brew
    install_sys_packages
    install_fonts
    install_ohmyzsh
    install_pyenv
    install_python
    install_python_pkg
    setup_env
    setup_zsh_plugin
    install_v2ray
}


cat << EOF
select a function code:
===============================
【 1 】 Install brew
【 2 】 Install sys packages
【 3 】 Install fonts
【 4 】 Install oh-my-zsh
【 5 】 Install pyenv
【 6 】 Install python
【 7 】 Install python pkg
【 8 】 Install nvm
【 9 】 Setup env
【 0 】 Setup zsh theme
【 v2 】 install_v2ray
【 a 】 Install all
【 x 】 Install softwares for macos
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
    2) install_sys_packages;;
    3) install_fonts;;
    4) install_ohmyzsh;;
    5) install_pyenv;;
    6) install_python;;
    7) install_python_pkg;;
    8) install_nvm;;
    9) setup_env;;
    0) setup_zsh_plugin;;
    v2) install_v2ray;;
    a) install_all;;
    x) install_softwares_for_macos;;
    *) echo 'Bye' && exit;;
esac


cd $CURRENT_DIR
