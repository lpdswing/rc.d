# ============================================================================
# PowerShell Profile - 类似 zsh aliases 的配置
# 安装: 将此文件内容复制到 $PROFILE 或直接链接
# ============================================================================

# 启动耗时诊断（默认关闭，避免日志本身影响日常启动）：
#   $env:POWERSHELL_PROFILE_TRACE = '1'; pwsh -NoLogo
$__ProfileTraceEnabled = $env:POWERSHELL_PROFILE_TRACE -in @('1', 'true', 'yes')
if ($__ProfileTraceEnabled) {
    $__ProfileTimer = [System.Diagnostics.Stopwatch]::StartNew()
    $__ProfileLastElapsedMs = 0.0

    function Write-ProfileTrace {
        param([Parameter(Mandatory)][string]$Name)

        $elapsedMs = $script:__ProfileTimer.Elapsed.TotalMilliseconds
        $sectionMs = $elapsedMs - $script:__ProfileLastElapsedMs
        [Console]::WriteLine(
            ('[profile] {0,-22} +{1,7:N1} ms  (total {2,7:N1} ms)' -f $Name, $sectionMs, $elapsedMs)
        )
        $script:__ProfileLastElapsedMs = $script:__ProfileTimer.Elapsed.TotalMilliseconds
    }
}

# 非交互命令不需要提示符、命令行编辑和目录跳转初始化。
$__ProfileIsInteractive = -not [Console]::IsInputRedirected -and -not [Console]::IsOutputRedirected

# ============================================================================
# 环境变量
# ============================================================================

$env:LC_ALL = "zh_CN.UTF-8"

# PATH 设置：使用 .NET API 避免 Test-Path 首次调用时自动加载模块；同时避免 reload 后重复膨胀。
$__AddProfilePath = {
    param([Parameter(Mandatory)][string]$Path)

    if ([IO.Directory]::Exists($Path) -and
        $Path -notin ($env:PATH -split [IO.Path]::PathSeparator)) {
        $env:PATH = $Path + [IO.Path]::PathSeparator + $env:PATH
    }
}

& $__AddProfilePath "$env:USERPROFILE\.local\bin"
& $__AddProfilePath "$env:USERPROFILE\.local\utils"

if ($__ProfileTraceEnabled) { Write-ProfileTrace 'Environment and PATH' }

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

# grep 替代 (使用 Select-String，并保留管道输入)
function grep {
    if ($MyInvocation.ExpectingInput) { $input | Select-String @args }
    else { Select-String @args }
}

# 查找命令（保留 Get-Command 的原始对象和默认格式，便于继续通过管道查看详情）
function which {
    param(
        [Parameter(Mandatory, Position = 0, ValueFromRemainingArguments)]
        [string[]]$Name
    )

    Get-Command -Name $Name
}

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

function py { python @args }
function ipy { ipython @args }
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

if ($__ProfileTraceEnabled) { Write-ProfileTrace 'Aliases and functions' }

# ============================================================================
# 开发环境
# ============================================================================

# Rust
$cargoPath = "$env:USERPROFILE\.cargo\bin"
& $__AddProfilePath $cargoPath

# Golang：设置环境变量不依赖 go.exe，避免为判断是否安装而扫描整个 PATH。
$env:GOPATH = "$env:USERPROFILE\src\Golang"
$env:GOPROXY = "https://goproxy.cn"
& $__AddProfilePath "$env:GOPATH\bin"

if ($__ProfileTraceEnabled) { Write-ProfileTrace 'Development tools' }

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

if ($__ProfileTraceEnabled) { Write-ProfileTrace 'Utility functions' }

# ============================================================================
# 命令补全模块
# 安装: Install-Module posh-git, DockerCompletion, PSReadLine -Scope CurrentUser
# ============================================================================

# Git 状态提示已由 Starship 提供。需要 posh-git 补全时按需启用。
function Enable-PoshGit { Import-Module posh-git -Global }

# Docker 补全是低频功能，按需启用可省去每次启动时的模块扫描和导入。
function Enable-DockerCompletion { Import-Module DockerCompletion -Global }

# PSReadLine 增强
if ($__ProfileIsInteractive -and $Host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine -ErrorAction SilentlyContinue

    # 历史记录
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -MaximumHistoryCount 10000

    # 预测和补全
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView

    # 快捷键
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
    Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Key Alt+d -Function DeleteWord
    Set-PSReadLineKeyHandler -Key Ctrl+LeftArrow -Function BackwardWord
    Set-PSReadLineKeyHandler -Key Ctrl+RightArrow -Function ForwardWord
    Set-PSReadLineKeyHandler -Key Ctrl+z -Function Undo
    Set-PSReadLineKeyHandler -Key Ctrl+r -Function ReverseSearchHistory
    Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine
    Set-PSReadLineKeyHandler -Key Ctrl+k -Function ForwardDeleteLine
    Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
    Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine
}

if ($__ProfileTraceEnabled) { Write-ProfileTrace 'Completions/PSReadLine' }

# ============================================================================
# 提示符美化 - Starship
# ============================================================================

if ($__ProfileIsInteractive) {
    Invoke-Expression (&starship init powershell)
}

if ($__ProfileTraceEnabled) { Write-ProfileTrace 'Starship' }

# ============================================================================
# Zoxide - 智能目录跳转 (类似 z/autojump)
# 安装: winget install ajeetdsouza.zoxide
# 使用: z <目录关键词> 快速跳转
# ============================================================================

if ($__ProfileIsInteractive) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

if ($__ProfileTraceEnabled) { Write-ProfileTrace 'Zoxide' }

# ============================================================================
# 安装说明
# ============================================================================
# 1. 查看 profile 路径: echo $PROFILE
# 2. 创建 profile (如不存在): New-Item -Path $PROFILE -ItemType File -Force
# 3. 复制此文件内容到 profile，或者：
#    Copy-Item PowerShell_profile.ps1 $PROFILE
# 4. 重新打开 PowerShell 或执行: . $PROFILE

if ($__ProfileTraceEnabled) {
    Write-ProfileTrace 'Total'
    Remove-Item Function:\Write-ProfileTrace -ErrorAction SilentlyContinue
}
