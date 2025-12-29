
# Toggle proxy on/off
proxy() {
    if [[ -z "$ALL_PROXY" ]]; then
        if [[ "$1" == "-s" ]]; then
            export ALL_PROXY="socks5://127.0.0.1:7890"
        else
            export ALL_PROXY="http://127.0.0.1:7890"
        fi
        echo "Proxy on: $ALL_PROXY"
    else
        unset ALL_PROXY
        echo "Proxy off"
    fi
}

# Kill tmux sessions
tkill() {
    if [[ "$1" == "-a" ]]; then
        tmux kill-session -a
    else
        for target in "$@"; do
            tmux kill-session -t "$target"
        done
    fi
}
