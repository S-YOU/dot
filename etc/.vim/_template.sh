#!/bin/sh

usage() {
    echo "○○をするスクリプト"
    echo "Usage: $0 FILENAME"
    echo "Example: $0 hoge.txt"
}

# -e     コマンドの戻り値が0でなければそこで終了する。ただしif, while, &&などの中ではその限りでない。
# -u     初期化されていない変数の参照をエラーにし、即座に終了する
# -x     実行するコマンドを表示する
set -e

atexit() {
    [ -n "$tmpfile" ] && rm -rf "$tmpfile"
}

echomsg() {
    echo -ne "\x1B[1;32m"
    echo -n "$@"
    echo -e "\x1B[0m"
}

echoerr() {
    echo -ne "\x1B[1;31m"
    echo -n "$@"
    echo -e "\x1B[0m"
}

trap 'atexit'     EXIT
# BSDとGNU両対応のtmpfile
tmpfile=$(mktemp 2>/dev/null || mktemp -t tmp)

# Linux | Darwin | FreeBSD
platform=$(uname)

#=============================================================================
#   main
#=============================================================================

start_time=$(date +'%Y-%m-%d %H:%M:%S')
echo $start_time

if [ $# -lt 1 ]; then
    usage
    exit 1
fi


exit 0
