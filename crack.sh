#!/bin/bash
set -e

# mac下颜色的ansi码
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
none='\033[0m'

_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }

dylib="$HOME/Public/MyMacsAppCrack/Tools/insert_dylib"
libinject="$HOME/Public/MyMacsAppCrack/Tools/libInlineInjectPlugin.dylib"

function cracked() {
    echo "cracked: $1 $2"
    a="$1"
    b="$2"
    # 判断文件是否存在
    if [ -f "$a" ] ; then
        _green "文件存在"
    else
        _red "文件不存在"
        _green "开始复制"
        sudo cp "$b" "$a"
        _green "复制完成"
    fi
    sudo "$dylib" "$libinject" "$a" "$b"
}

function jieyou() {
    echo "cracked: 解忧"
    a="/Applications/BestZip 2.app/Contents/Frameworks/JSONModel.framework/Versions/A/JSONModel_副本"
    b="/Applications/BestZip 2.app/Contents/Frameworks/JSONModel.framework/Versions/A/JSONModel"
    cracked "$a" "$b"
}

function CleanMyMac() {
    echo "cracked: CleanMyMac"
    a="/Applications/CleanMyMac X.app/Contents/Frameworks/Announcements.framework/Versions/A/Announcements_副本"
    b="/Applications/CleanMyMac X.app/Contents/Frameworks/Announcements.framework/Versions/A/Announcements"
    cracked "$a" "$b"
}

function PhotoShop() {
    echo "cracked: PhotoShop"
    a="/Applications/Adobe Photoshop 2023/Adobe Photoshop 2023.app/Contents/Frameworks/AdobeAGM.framework/Versions/A/AdobeAGM_副本"
    b="/Applications/Adobe Photoshop 2023/Adobe Photoshop 2023.app/Contents/Frameworks/AdobeAGM.framework/Versions/A/AdobeAGM"
    cracked "$a" "$b"
}

function iShot() {
    echo "cracked: iShot"
    a="/Applications/iShot.app/Contents/Frameworks/PTHotKey.framework/Versions/A/PTHotKey_副本"
    b="/Applications/iShot.app/Contents/Frameworks/PTHotKey.framework/Versions/A/PTHotKey"
    cracked "$a" "$b"
}

function Navicat() {
    echo "cracked: Navicat"
    a="/Applications/Navicat Premium.app/Contents/Frameworks/NAVTabBarView.framework/Versions/A/NAVTabBarView_副本"
    b="/Applications/Navicat Premium.app/Contents/Frameworks/NAVTabBarView.framework/Versions/A/NAVTabBarView"
    cracked "$a" "$b"
}

function MWeb() {
    echo "cracked: MWeb"
    a="/Applications/MWeb Pro.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle_副本"
    b="/Applications/MWeb Pro.app/Contents/Frameworks/Sparkle.framework/Versions/B/Sparkle"
    cracked "$a" "$b"
}

echo
_green "...........  cracked mac software一键脚本 .........."
echo
while true
do
cat << EOF
cracked for macos:
===============================
【 1 】 解忧
【 2 】 CleanMyMac
【 3 】 PhotoShop
【 4 】 iShot
【 5 】 Navicat Premium
【 6 】 MWeb Pro
【 e 】 Exit
===============================
EOF

    if [[ -n $1 ]]; then
        choice=$1
        echo "exec: $1"
    else
        read -p "select: " choice
    fi

    case $choice in
        1) jieyou;;
        2) CleanMyMac;;
        3) PhotoShop;;
        4) iShot;;
        5) Navicat;;
        6) MWeb;;
        e) echo 'Bye' && exit;;
    esac
done