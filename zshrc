# ============================================================================
# Zsh 配置 - Sheldon 插件管理
# ============================================================================

# ============================================================================
# 早期 PATH 设置（确保 sheldon 等工具可用）
# ============================================================================

[[ ! ":${PATH}:" =~ "/usr/local/sbin" ]] && export PATH="/usr/local/sbin:$PATH"
[[ ! ":${PATH}:" =~ "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ ! ":${PATH}:" =~ "$HOME/.local/utils" ]] && export PATH="$HOME/.local/utils:$PATH"
[[ ! ":${PATH}:" =~ "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"

# ============================================================================
# 补全系统初始化（带缓存，每天只重建一次）
# ============================================================================

autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# ============================================================================
# Sheldon 插件管理
# ============================================================================

if command -v sheldon &>/dev/null; then
    eval "$(sheldon source)"
else
    print -P "%F{yellow}→ sheldon 未安装，请运行: cargo install sheldon 或 brew install sheldon%f"
fi

# ============================================================================
# command-not-found（系统级）
# ============================================================================

[[ -f /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found

# ============================================================================
# 历史记录配置
# ============================================================================

HISTSIZE=50000
SAVEHIST=50000
HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
setopt hist_ignore_all_dups   # 删除旧的重复命令
setopt hist_find_no_dups      # 搜索时不显示重复
setopt hist_reduce_blanks     # 删除多余空格
setopt hist_verify            # 展开历史命令后先确认
setopt share_history          # 多终端共享历史

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
    eval "$(fzf --zsh)"

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
# zoxide - 快速目录跳转
# ============================================================================

eval "$(zoxide init zsh)"

# ============================================================================
# nvm - Node.js 版本管理
# ============================================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # 加载 nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # 加载 nvm 补全

# ============================================================================
# 加载自定义配置
# ============================================================================

[[ -f "$HOME/.rc.d/aliases.sh" ]] && source "$HOME/.rc.d/aliases.sh"
[[ -f "$HOME/.rc.d/functions.sh" ]] && source "$HOME/.rc.d/functions.sh"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ============================================================================
# UV - Python 包管理器
# ============================================================================

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# OpenClaw Completion
source "/home/lpdswing/.openclaw/completions/openclaw.zsh"
