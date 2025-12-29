# Zinit 插件管理器（自动安装）
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{yellow}→ 安装 Zinit...%f"
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# 核心插件
zinit light zsh-users/zsh-autosuggestions      # 命令自动建议
zinit light zsh-users/zsh-syntax-highlighting  # 语法高亮
zinit light zsh-users/zsh-completions          # 补全增强
zinit light agkozak/zsh-z                      # 快速目录跳转

# 历史记录配置
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory       # 追加而不是覆盖历史文件
setopt sharehistory        # 多个会话共享历史
setopt hist_ignore_dups    # 忽略重复命令
setopt hist_ignore_space   # 忽略以空格开头的命令

# 补全系统
autoload -Uz compinit && compinit
zinit cdreplay -q

# Starship 提示符
eval "$(starship init zsh)"

# 加载自定义配置
[[ -f "$HOME/.rc.d/aliases.sh" ]] && source "$HOME/.rc.d/aliases.sh"
[[ -f "$HOME/.rc.d/functions.sh" ]] && source "$HOME/.rc.d/functions.sh"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
