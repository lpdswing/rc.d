" 启用语法高亮
if has("syntax")
  syntax on
endif

" 重新打开文件时跳转到上次编辑位置
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" 基础设置
set showcmd         " 显示未完成的命令
set showmatch       " 高亮匹配的括号
set ignorecase      " 搜索忽略大小写
set smartcase       " 如果包含大写字母则区分大小写
set incsearch       " 增量搜索

" 加载系统全局配置（如果存在）
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" 外观主题
color desert
set t_Co=256
set background=dark
set nu                      " 显示行号
set nocompatible            " 不兼容 Vi 模式
set ruler                   " 显示光标位置
set report=0                " 显示修改次数
set nobackup                " 不创建备份文件
set fileencodings=ucs-bom,UTF-8,GBK,BIG5,latin1
set fileencoding=UTF-8
set fileformat=unix         " 使用 Unix 换行符
set wrap                    " 自动换行
set linebreak               " 在单词边界换行
set ambiwidth=double        " 中文字符宽度
set noerrorbells            " 关闭错误响铃
set visualbell              " 使用可视化铃声
set foldmarker={,}          " 折叠标记符
set foldmethod=indent       " 根据缩进折叠
set foldlevel=100           " 打开文件时不自动折叠
set foldopen-=search        " 搜索时不打开折叠
set foldopen-=undo          " 撤销时不打开折叠
set updatecount=0           " 不使用交换文件
set magic                   " 正则表达式魔术模式

" 缩进设置
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab               " 用空格代替 Tab
set smarttab
set backspace=2             " 退格键可以删除任何内容

" 当前行高亮
set cursorline
highlight CursorLine cterm=none    ctermfg=none     ctermbg=235
highlight LineNr     cterm=none    ctermfg=gray     ctermbg=none

" 搜索结果高亮
set hlsearch
highlight Search     cterm=none    ctermfg=black    ctermbg=blue

" vimdiff 高亮配色
highlight DiffAdd    cterm=reverse ctermfg=darkcyan ctermbg=black
highlight DiffDelete cterm=none    ctermfg=gray     ctermbg=239
highlight DiffChange cterm=none    ctermfg=none     ctermbg=239
highlight DiffText   cterm=bold    ctermfg=yellow   ctermbg=darkred

" 保存时自动删除行尾空白
auto BufWritePre * sil %s/\s\+$//ge

" 快捷键映射
map [r :! python3 % <CR>     " [r: 运行 Python 文件
map [o :! python3 -i % <CR>  " [o: 交互式运行 Python 文件
map <C-j> :He<CR>            " Ctrl+j: 水平分屏浏览
map <C-l> :Ve!<CR>           " Ctrl+l: 垂直分屏浏览
