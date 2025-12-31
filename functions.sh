# ============================================================================
# Shell 函数集合
# ============================================================================

# ----------------------------------------------------------------------------
# highlight - 终端彩色输出
# 用法: highlight "消息" 颜色 [样式...]
# 示例: highlight "成功" green bold
# ----------------------------------------------------------------------------
function highlight() {
    local message="$1"
    shift
    local codes=""

    for style in "$@"; do
        style=$(echo "$style" | tr '[:upper:]' '[:lower:]')
        case $style in
            # 样式
            reset)            codes+='\033[0m' ;;
            bold)             codes+='\033[1m' ;;
            dim)              codes+='\033[2m' ;;
            italic)           codes+='\033[3m' ;;
            underline)        codes+='\033[4m' ;;
            blink)            codes+='\033[5m' ;;
            reverse)          codes+='\033[7m' ;;
            # 前景色
            black)            codes+='\033[30m' ;;
            red)              codes+='\033[31m' ;;
            green)            codes+='\033[32m' ;;
            yellow)           codes+='\033[33m' ;;
            blue)             codes+='\033[34m' ;;
            magenta)          codes+='\033[35m' ;;
            cyan)             codes+='\033[36m' ;;
            white)            codes+='\033[37m' ;;
            gray)             codes+='\033[90m' ;;
            light_red)        codes+='\033[91m' ;;
            light_green)      codes+='\033[92m' ;;
            light_yellow)     codes+='\033[93m' ;;
            light_blue)       codes+='\033[94m' ;;
            light_magenta)    codes+='\033[95m' ;;
            light_cyan)       codes+='\033[96m' ;;
            light_white)      codes+='\033[97m' ;;
            # 背景色
            bg_black)         codes+='\033[40m' ;;
            bg_red)           codes+='\033[41m' ;;
            bg_green)         codes+='\033[42m' ;;
            bg_yellow)        codes+='\033[43m' ;;
            bg_blue)          codes+='\033[44m' ;;
            bg_magenta)       codes+='\033[45m' ;;
            bg_cyan)          codes+='\033[46m' ;;
            bg_white)         codes+='\033[47m' ;;
            bg_light_black)   codes+='\033[100m' ;;
            bg_light_red)     codes+='\033[101m' ;;
            bg_light_green)   codes+='\033[102m' ;;
            bg_light_yellow)  codes+='\033[103m' ;;
            bg_light_blue)    codes+='\033[104m' ;;
            bg_light_magenta) codes+='\033[105m' ;;
            bg_light_cyan)    codes+='\033[106m' ;;
            bg_light_white)   codes+='\033[107m' ;;
            *) echo "Invalid style: $style"; return 1 ;;
        esac
    done

    printf "${codes}${message}\033[0m"
}

# ----------------------------------------------------------------------------
# rmds - 递归删除 .DS_Store 文件
# 用法: rmds [目录]  (默认当前目录)
# ----------------------------------------------------------------------------
function rmds() {
    find "${@:-.}" -type f -name .DS_Store -delete
}

# ----------------------------------------------------------------------------
# preview - macOS 快速预览文件 (Quick Look)
# 用法: preview file1 file2 ...
# ----------------------------------------------------------------------------
function preview() {
    (( $# > 0 )) && qlmanage -p "$@" &>/dev/null &
}

# ----------------------------------------------------------------------------
# pscm - 显示进程的 CPU 和内存占用
# 用法: pscm | grep python
# ----------------------------------------------------------------------------
function pscm() {
    ps -eo pid,pcpu,rss,args | \
    awk 'NR>1 {printf "%-6s %-5s %7.1f MB  %s\n", $1, $2" %", $3/1024, substr($0, index($0,$4))}'
}

# ----------------------------------------------------------------------------
# pyv - 显示当前 Python 版本和路径
# 用法: pyv
# ----------------------------------------------------------------------------
function pyv() {
    highlight "$(python --version)" yellow bold
    highlight " ($(which python))\n" gray
}

# ----------------------------------------------------------------------------
# relpath - 获取相对于当前目录的相对路径
# 用法: relpath /some/absolute/path
# ----------------------------------------------------------------------------
function relpath() {
    realpath --relative-to='.' "$1"
}

# ----------------------------------------------------------------------------
# wk - 激活 Python 虚拟环境
# 用法: wk [目录]  (默认当前目录，最深搜索 4 层)
# ----------------------------------------------------------------------------
function wk() {
    if [[ $# == 0 ]]; then
        dest="."
    elif [[ -d "$1" ]]; then
        dest="$1"
    else
        highlight "Venv: $1 is not a directory.\n" red
        return 1
    fi

    for actv in $(find "$dest" -maxdepth 4 -type f -name activate); do
        if source "$actv"; then
            printf "Work on "
            highlight "$(dirname $(dirname $actv))\n" magenta bold
            return
        fi
    done

    highlight "Venv: Cannot find the activate file.\n" red
}

# ----------------------------------------------------------------------------
# proxy - 切换代理开关
# 用法: proxy [端口]  (默认 7890，再次执行关闭)
# ----------------------------------------------------------------------------
function proxy() {
    local port="${1:-7890}"

    if [[ -z "$all_proxy" ]]; then
        export http_proxy="http://127.0.0.1:$port"
        export https_proxy="http://127.0.0.1:$port"
        export all_proxy="socks5://127.0.0.1:$port"
        highlight "Proxy on: $all_proxy\n" green
    else
        unset http_proxy https_proxy all_proxy
        highlight "Proxy off\n" yellow
    fi
}

# ----------------------------------------------------------------------------
# tkill - 关闭 tmux 会话
# 用法: tkill session1 session2 ...
#       tkill -a  (关闭除当前外的所有会话)
# ----------------------------------------------------------------------------
function tkill() {
    if [[ "$1" == "-a" ]]; then
        tmux kill-session -a
    else
        for target in "$@"; do
            if tmux kill-session -t "$target"; then
                highlight "Tmux session $target has been killed\n" yellow
            fi
        done
    fi
}

