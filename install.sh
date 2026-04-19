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

# 安装 fnm (Fast Node Manager)
function install_fnm() {
    print_info "安装 fnm..."

    if command -v fnm &>/dev/null; then
        print_success "fnm 已安装"
        return 0
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        brew install fnm
    elif command -v cargo &>/dev/null; then
        cargo install fnm
    elif command -v curl &>/dev/null; then
        curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
    else
        echo "请手动安装 fnm: https://github.com/Schniz/fnm"
        return 1
    fi

    print_success "fnm 安装完成"
}

# 安装 sheldon (Zsh 插件管理器)
function install_sheldon() {
    print_info "安装 sheldon..."

    if command -v sheldon &>/dev/null; then
        print_success "sheldon 已安装"
        return 0
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        brew install sheldon
    elif command -v cargo &>/dev/null; then
        cargo install sheldon
    elif command -v curl &>/dev/null; then
        curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
            | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
    else
        echo "请手动安装 sheldon: https://github.com/rossmacarthur/sheldon"
        return 1
    fi

    print_success "sheldon 安装完成"
}

# 安装 uv (Python 包管理器)
function install_uv() {
    print_info "安装 uv..."

    if command -v uv &>/dev/null; then
        print_success "uv 已安装"
        return 0
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        brew install uv
    else
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi

    print_success "uv 安装完成"
}

# 安装 zoxide (快速目录跳转)
function install_zoxide() {
    print_info "安装 zoxide..."

    if command -v zoxide &>/dev/null; then
        print_success "zoxide 已安装"
        return 0
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        brew install zoxide
    elif command -v curl &>/dev/null; then
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    else
        echo "请手动安装 zoxide: https://github.com/ajeetdsouza/zoxide"
        return 1
    fi

    print_success "zoxide 安装完成"
}

# 安装 zellij (终端多路复用器)
function install_zellij() {
    print_info "安装 zellij..."

    if command -v zellij &>/dev/null; then
        print_success "zellij 已安装"
        return 0
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        brew install zellij
    elif command -v cargo &>/dev/null; then
        cargo install --locked zellij
    elif command -v curl &>/dev/null; then
        local arch
        arch=$(uname -m)
        case "$arch" in
            x86_64) arch="x86_64-unknown-linux-musl" ;;
            aarch64|arm64) arch="aarch64-unknown-linux-musl" ;;
            *) echo "不支持的架构: $arch"; return 1 ;;
        esac
        local tmp
        tmp=$(mktemp -d)
        curl -fsSL "https://github.com/zellij-org/zellij/releases/latest/download/zellij-${arch}.tar.gz" \
            | tar -xz -C "$tmp"
        mkdir -p "$HOME/.local/bin"
        mv "$tmp/zellij" "$HOME/.local/bin/"
        rm -rf "$tmp"
    else
        echo "请手动安装 zellij: https://zellij.dev/documentation/installation"
        return 1
    fi

    print_success "zellij 安装完成"
}

# 安装 jd (JSON diff 工具)
function install_jd() {
    print_info "安装 jd..."

    if command -v jd &>/dev/null; then
        print_success "jd 已安装"
        return 0
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        brew install jd
    elif command -v go &>/dev/null; then
        go install github.com/josephburnett/jd/v2@latest
    elif command -v curl &>/dev/null; then
        local arch os
        os=$(uname -s | tr '[:upper:]' '[:lower:]')
        arch=$(uname -m)
        case "$arch" in
            x86_64) arch="amd64" ;;
            aarch64|arm64) arch="arm64" ;;
            *) echo "不支持的架构: $arch"; return 1 ;;
        esac
        mkdir -p "$HOME/.local/bin"
        curl -fsSL -o "$HOME/.local/bin/jd" \
            "https://github.com/josephburnett/jd/releases/latest/download/jd-${os}-${arch}"
        chmod +x "$HOME/.local/bin/jd"
    else
        echo "请手动安装 jd: https://github.com/josephburnett/jd"
        return 1
    fi

    print_success "jd 安装完成"
}

# 从 txt 文件批量安装包
function install_packages() {
    print_info "安装常用软件包..."

    local pkg_file
    if [[ $(uname) == 'Darwin' ]]; then
        pkg_file="$RC_DIR/packages-brew.txt"
    else
        pkg_file="$RC_DIR/packages-apt.txt"
    fi

    if [[ ! -f "$pkg_file" ]]; then
        echo "未找到包列表: $pkg_file"
        return 1
    fi

    # 读取包列表（跳过注释和空行）
    local packages=()
    while IFS= read -r line; do
        line="${line%%#*}"          # 去掉行内注释
        line="$(echo "$line" | xargs)"  # 去掉首尾空格
        [[ -n "$line" ]] && packages+=("$line")
    done < "$pkg_file"

    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "包列表为空"
        return 0
    fi

    if [[ $(uname) == 'Darwin' ]]; then
        print_info "使用 Homebrew 安装: ${packages[*]}"
        brew install "${packages[@]}"
    else
        print_info "使用 apt 安装: ${packages[*]}"
        sudo apt-get update && sudo apt-get install -y "${packages[@]}"
    fi

    print_success "软件包安装完成"
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

    # ~/.config 下的配置
    ln -sfnv "$RC_DIR/config/sheldon" "$HOME/.config/sheldon"
    mkdir -p "$HOME/.config/kitty"
    ln -sfv "$RC_DIR/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
    ln -sf "$RC_DIR/config/starship.toml" "$HOME/.config/starship.toml"

    # Ghostty 配置（按平台链接）
    mkdir -p "$HOME/.config/ghostty"
    if [[ $(uname) == 'Darwin' ]]; then
        ln -sfv "$RC_DIR/config/ghostty/config-macos.ghostty" "$HOME/.config/ghostty/config"
    else
        ln -sfv "$RC_DIR/config/ghostty/config-linux.ghostty" "$HOME/.config/ghostty/config"
    fi

    # 创建本地配置文件
    touch "$HOME/.zshrc.local"

    print_success "环境配置完成"
}

# 配置 pip / uv 镜像源
function mirror_config() {
    print_info "配置 pip / uv 镜像源..."

    local mirror="https://pypi.tuna.tsinghua.edu.cn/simple"

    # pip
    if command -v pip &>/dev/null || command -v pip3 &>/dev/null; then
        pip config set global.index-url "$mirror"
        print_success "pip 镜像源配置完成"
    fi

    # uv
    local uv_dir="$HOME/.config/uv"
    local uv_conf="$uv_dir/uv.toml"
    mkdir -p "$uv_dir"
    cat > "$uv_conf" <<EOF
[[index]]
url = "$mirror"
default = true
EOF
    print_success "uv 镜像源已写入 $uv_conf"
}

# 一键安装
function install_all() {
    print_info "开始一键安装..."

    if [[ $(uname) == 'Darwin' ]]; then
        install_brew
    fi

    install_packages
    install_starship
    install_sheldon
    install_fnm
    install_uv
    install_zoxide
    install_zellij
    install_jd
    setup_env

    print_success "安装完成！"
    echo ""
    echo "请执行以下命令重新加载配置："
    echo "  source ~/.zshrc"
    echo ""
    echo "提示：Sheldon 将在首次启动 Zsh 时自动下载插件"
}

# 显示菜单
function show_menu() {
    cat << EOF

RC.D 配置安装脚本
================================
【 1 】 一键安装（推荐）
【 2 】 安装 Homebrew (macOS)
【 3 】 安装常用软件包
【 4 】 安装 Starship
【 5 】 安装 sheldon
【 6 】 安装 fnm
【 7 】 安装 uv
【 8 】 配置环境（链接配置文件）
【 9 】 配置 pip / uv 镜像源
【 a 】 安装 zoxide
【 b 】 安装 zellij
【 c 】 安装 jd
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
    3) install_packages;;
    4) install_starship;;
    5) install_sheldon;;
    6) install_fnm;;
    7) install_uv;;
    8) setup_env;;
    9) mirror_config;;
    a|A) install_zoxide;;
    b|B) install_zellij;;
    c|C) install_jd;;
    0|*) echo "退出" && exit;;
esac
