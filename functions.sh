# virtual activate
###
 # @Author: your name
 # @Date: 2020-11-06 15:40:19
 # @LastEditTime: 2021-02-20 15:38:42
 # @LastEditors: Please set LastEditors
 # @Description: In User Settings Edit
 # @FilePath: /.rc.d/functions.sh
### 
wk() {
    if [[ -f "$1/.venv/bin/activate" ]]; then
        source $1/.venv/bin/activate
    elif [[ -f "$1/bin/activate" ]]; then
        source $1/bin/activate
    elif [[ -f "$1/activate" ]]; then
        source $1/activate
    elif [[ -f "$1" ]]; then
        source $1
    elif [[ -f ".venv/bin/activate" ]]; then
        source .venv/bin/activate
    else
        echo 'Venv: Cannot find the activate file.'
    fi
}


# kill tmux's session
tkill() {
    if [[ "$1" == "-a" ]]; then
        tmux kill-session -a
    else
        for target in $@
        do
            tmux kill-session -t $target
        done
    fi
}
