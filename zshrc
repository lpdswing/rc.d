# ============================================================================
# Fish-like Zsh 配置 - Oh My Zsh 版本
# ============================================================================

# Oh My Zsh 安装路径
export ZSH="${HOME}/.oh-my-zsh"

# 自动安装 Oh My Zsh（不覆盖 zshrc）
if [[ ! -d "$ZSH" ]]; then
    print -P "%F{yellow}→ 安装 Oh My Zsh...%f"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# ============================================================================
# 主题 - 禁用 OMZ 主题，使用 Starship
# ============================================================================

ZSH_THEME=""

# ============================================================================
# 插件
# ============================================================================

# 自动安装第三方插件
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# zsh-history-substring-search
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
fi

# zsh-autopair
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autopair" ]]; then
    git clone https://github.com/hlissner/zsh-autopair "$ZSH_CUSTOM/plugins/zsh-autopair"
fi

# fzf-tab
if [[ ! -d "$ZSH_CUSTOM/plugins/fzf-tab" ]]; then
    git clone https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
fi

plugins=(
    z                           # 快速目录跳转
    colored-man-pages           # 彩色 man 手册
    command-not-found           # 命令未找到时建议安装
    fzf                         # fzf 集成
    zsh-autosuggestions         # 命令自动建议
    zsh-syntax-highlighting     # 语法高亮（必须放最后）
    zsh-history-substring-search
    zsh-autopair
    fzf-tab
)

# 加载 Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# ============================================================================
# 历史记录配置
# ============================================================================

HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_all_dups   # 删除旧的重复命令
setopt hist_find_no_dups      # 搜索时不显示重复
setopt hist_reduce_blanks     # 删除多余空格
setopt hist_verify            # 展开历史命令后先确认

# ============================================================================
# 补全样式 - Fish 风格
# ============================================================================

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- 无匹配 --%f'

# fzf-tab 样式
zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse --border
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath 2>/dev/null || ls $realpath'

# ============================================================================
# 按键绑定
# ============================================================================

# 历史子串搜索
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# 自动建议接受
bindkey '^ ' autosuggest-accept
bindkey '^f' autosuggest-accept

# ============================================================================
# fzf 配置（跨平台）
# ============================================================================

if command -v fzf &>/dev/null; then
    export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --info=inline'

    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi

    if command -v bat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :100 {}'"
    fi
fi

# ============================================================================
# 自动建议配置
# ============================================================================

ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# ============================================================================
# Zsh 选项
# ============================================================================

setopt auto_cd
setopt correct
setopt no_beep
setopt glob_dots

# ============================================================================
# Starship 提示符
# ============================================================================


eval "$(starship init zsh)"


# ============================================================================
# 加载自定义配置
# ============================================================================

[[ -f "$HOME/.rc.d/aliases.sh" ]] && source "$HOME/.rc.d/aliases.sh"
[[ -f "$HOME/.rc.d/functions.sh" ]] && source "$HOME/.rc.d/functions.sh"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
