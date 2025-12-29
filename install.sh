#!/bin/bash

RC_DIR="$HOME/.rc.d"
RC_URL='https://github.com/lpdswing/rc.d.git'

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

function print_info() {
    echo -e "${YELLOW}→${NC} $1"
}

function ensure_rc() {
    if [ ! -d "$RC_DIR" ]; then
        print_info "克隆配置仓库到 $RC_DIR ..."
        git clone "$RC_URL" "$RC_DIR"
        print_success "仓库克隆完成"
    fi
}

# 安装 Homebrew (仅 macOS)
function install_brew() {
    print_info "安装 Homebrew..."

    if [[ $(uname) != 'Darwin' ]]; then
        echo "仅支持 macOS"
        return 1
    fi

    if command -v brew &>/dev/null; then
        print_success "Homebrew 已安装"
        return 0
    fi

    print_info "安装 Xcode Command Line Tools..."
    xcode-select --install

    print_info "安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    print_success "Homebrew 安装完成"
}

# 安装 Starship
function install_starship() {
    print_info "安装 Starship 提示符..."

    if command -v starship &>/dev/null; then
        print_success "Starship 已安装"
        return 0
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        brew install starship
    elif command -v curl &>/dev/null; then
        curl -sS https://starship.rs/install.sh | sh
    else
        echo "请手动安装 Starship: https://starship.rs"
        return 1
    fi

    print_success "Starship 安装完成"
}

# 配置环境（链接配置文件）
function setup_env() {
    print_info "配置环境..."

    ensure_rc

    cd "$HOME" || exit

    # 链接配置文件
    ln -sfv .rc.d/gitconfig .gitconfig
    ln -sfv .rc.d/vimrc .vimrc
    ln -sfv .rc.d/zshrc .zshrc
    ln -sfv .rc.d/bashrc .bashrc
    ln -sfv .rc.d/tmux.conf .tmux.conf

    # 创建本地配置文件
    touch "$HOME/.zshrc.local"

    print_success "环境配置完成"
}

# 配置 pip 镜像源
function pip_config() {
    print_info "配置 pip 镜像源..."

    if ! command -v pip &>/dev/null && ! command -v pip3 &>/dev/null; then
        echo "未找到 pip"
        return 1
    fi

    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

    print_success "pip 镜像源配置完成"
}

# 一键安装
function install_all() {
    print_info "开始一键安装..."

    if [[ $(uname) == 'Darwin' ]]; then
        install_brew
    fi

    install_starship
    setup_env

    print_success "安装完成！"
    echo ""
    echo "请执行以下命令重新加载配置："
    echo "  source ~/.zshrc"
    echo ""
    echo "提示：Zinit 将在首次启动 Zsh 时自动安装"
}

# 显示菜单
function show_menu() {
    cat << EOF

RC.D 配置安装脚本
================================
【 1 】 一键安装（推荐）
【 2 】 安装 Homebrew (macOS)
【 3 】 安装 Starship
【 4 】 配置环境（链接配置文件）
【 5 】 配置 pip 镜像源
【 0 】 退出
================================
EOF
}

# 主程序
if [[ -n $1 ]]; then
    choice=$1
else
    show_menu
    read -p "请选择: " choice
fi

case $choice in
    1) install_all;;
    2) install_brew;;
    3) install_starship;;
    4) setup_env;;
    5) pip_config;;
    0|*) echo "退出" && exit;;
esac
