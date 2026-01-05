# ============================================================================
# PowerShell Profile - 类似 zsh aliases 的配置
# 安装: 将此文件内容复制到 $PROFILE 或直接链接
# ============================================================================

# ============================================================================
# 环境变量
# ============================================================================

$env:LC_ALL = "zh_CN.UTF-8"

# PATH 设置
$localBin = "$env:USERPROFILE\.local\bin"
$localUtils = "$env:USERPROFILE\.local\utils"
if (Test-Path $localBin) { $env:PATH = "$localBin;$env:PATH" }
if (Test-Path $localUtils) { $env:PATH = "$localUtils;$env:PATH" }

# ============================================================================
# 通用别名 - 文件操作
# ============================================================================

# ls 系列 (使用 Get-ChildItem)
function l { Get-ChildItem -Force @args | Format-Table Mode, Length, LastWriteTime, Name }
function ll { Get-ChildItem @args | Format-Table Mode, Length, LastWriteTime, Name }
function la { Get-ChildItem -Force @args }
function lla { Get-ChildItem -Force @args | Format-Table Mode, Length, LastWriteTime, Name }

# 文件操作
function cpv { Copy-Item -Verbose @args }
function mvv { Move-Item -Verbose @args }

# grep 替代 (使用 Select-String)
Set-Alias grep Select-String

# tree
function tree { cmd /c tree /F @args }

# 删除 .DS_Store (虽然 Windows 不常见)
function rmds { Get-ChildItem -Recurse -Force -Filter ".DS_Store" | Remove-Item -Force }

# ============================================================================
# 网络工具
# ============================================================================

function ping10 { ping -n 10 @args }
function ip4 { Get-NetIPAddress -AddressFamily IPv4 | Select-Object IPAddress, InterfaceAlias }
function ip6 { Get-NetIPAddress -AddressFamily IPv6 | Select-Object IPAddress, InterfaceAlias }

# ============================================================================
# Python
# ============================================================================

Set-Alias py python
Set-Alias ipy ipython
function httpserver { python -m http.server @args }
function rmpyc { Get-ChildItem -Recurse -Include "*.pyc","*.pyo","__pycache__" | Remove-Item -Recurse -Force }
function pygrep { Select-String -Path "*.py" -Pattern @args }

# uv 相关
function pip { uv pip @args }
function venv { uv venv @args }
function upy { uv python @args }

# ============================================================================
# Git
# ============================================================================

function gad { git add @args }
function gst { git status -sb @args }
function gdf { git difftool @args }
function glg { git log --stat --graph --max-count=10 @args }
function gpl { git pull @args }
function gci { git commit @args }
function gco { git checkout @args }
function gsw { git switch @args }
function gmg { git merge --no-commit --squash @args }

# ============================================================================
# 开发环境
# ============================================================================

# Rust
$cargoPath = "$env:USERPROFILE\.cargo\bin"
if (Test-Path $cargoPath) { $env:PATH = "$cargoPath;$env:PATH" }

# Golang
if (Get-Command go -ErrorAction SilentlyContinue) {
    $env:GOPATH = "$env:USERPROFILE\src\Golang"
    $env:PATH = "$env:GOPATH\bin;$env:PATH"
    $env:GOPROXY = "https://goproxy.cn"
}

# pnpm
$pnpmPath = "$env:USERPROFILE\.local\share\pnpm"
if (Test-Path $pnpmPath) {
    $env:PNPM_HOME = $pnpmPath
    $env:PATH = "$pnpmPath;$env:PATH"
    function npm { pnpm @args }
    function npx { pnpx @args }
}

# ============================================================================
# 实用函数
# ============================================================================

# 快速进入目录并列出内容
function cdl { Set-Location @args; l }

# 创建目录并进入
function mkcd { New-Item -ItemType Directory -Path $args[0]; Set-Location $args[0] }

# 查找文件
function ff { Get-ChildItem -Recurse -Filter @args }

# 查看进程
function pscm { Get-Process | Format-Table Id, ProcessName, CPU, WorkingSet -AutoSize }
function psgrep { Get-Process | Where-Object { $_.ProcessName -match $args[0] } }

# 快速编辑 profile
function editprofile { code $PROFILE }
function reloadprofile { . $PROFILE }

# ============================================================================
# 提示符美化 - Starship
# ============================================================================

Invoke-Expression (&starship init powershell)

# ============================================================================
# 安装说明
# ============================================================================
# 1. 查看 profile 路径: echo $PROFILE
# 2. 创建 profile (如不存在): New-Item -Path $PROFILE -ItemType File -Force
# 3. 复制此文件内容到 profile，或者：
#    Copy-Item PowerShell_profile.ps1 $PROFILE
# 4. 重新打开 PowerShell 或执行: . $PROFILE
