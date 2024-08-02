#!/bin/bash

# 用一个参数接收安装目录，如果不指定就用一个默认值
INSTALL_DIR=${1:-/mnt/user/appdata/zsh_env}

# 安装 Zsh
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p $INSTALL_DIR
fi

OH_MY_ZSH_ROOT="$INSTALL_DIR/.oh-my-zsh"
ZSH_CUSTOM="$INSTALL_DIR/.oh-my-zsh/custom"
OH_MY_ZSH_PLUGINS="$ZSH_CUSTOM/plugins"
OH_MY_ZSH_THEMES="$ZSH_CUSTOM/themes"

if [ -d "$OH_MY_ZSH_ROOT" ]; then
        echo "$OH_MY_ZSH_ROOT already exists"
        exit 1
fi
# 安装 oh-my-zsh
ZSH=$OH_MY_ZSH_ROOT RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-autosuggestions
if [ ! -d "$OH_MY_ZSH_PLUGINS/zsh-autosuggestions" ]; then
        echo "  -> Installing zsh-autosuggestions..."
        git clone https://ghproxy.com/https://github.com/zsh-users/zsh-autosuggestions $OH_MY_ZSH_PLUGINS/zsh-autosuggestions
else
        echo "  -> zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting
if [ ! -d "$OH_MY_ZSH_PLUGINS/zsh-syntax-highlighting" ]; then
        echo "  -> Installing zsh-syntax-highlighting..."
        git clone https://ghproxy.com/https://github.com/zsh-users/zsh-syntax-highlighting.git $OH_MY_ZSH_PLUGINS/zsh-syntax-highlighting
else
        echo "  -> zsh-syntax-highlighting already installed"
fi

chmod 755 $OH_MY_ZSH_PLUGINS/zsh-autosuggestions
chmod 755 $OH_MY_ZSH_PLUGINS/zsh-syntax-highlighting

chsh -s /bin/zsh
# 创建 .zshrc 配置文件
cat << EOF > $INSTALL_DIR/.zshrc
export ZSH="$OH_MY_ZSH_ROOT"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)
source \$ZSH/oh-my-zsh.sh
EOF

# 创建到 $HOME/.zshrc 的软链接
ln -s $INSTALL_DIR/.zshrc $HOME/.zshrc


# Make sure the .zsh_history file exists
touch "$SOURCE_CONFIG/.zsh_history"

# Symlink the .zshrc file and the .zsh_history file
rm /root/.zshrc || true
cp -sf "$SOURCE_CONFIG/.zshrc" "$HOME/.zshrc" || true
rm /root/.zsh_history | true
cp -sf "$SOURCE_CONFIG/.zsh_history" "$HOME/.zsh_history"
