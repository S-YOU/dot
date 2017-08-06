# マシン固有の設定は
# ~/.bashrc.local
# に書くこと

# 対話的シェルか判定するには：
#     $PS1がセットされているか　または $- に i が含まれているか
# ログインシェルか判定するには：
#     shopt | grep login_shell  または shopt -q login_shellの戻り値を調べる
# 
# [A] 通常の対話ログインシェルの場合
# (1) /etc/profile
# (2) ~/.bash_profile, ~/.bash_login, ~/.profileの順で見つかったもの１つだけ
#    ~/.bash_profileの中で~/.bashrcをインクルード。
# 
#                             ~/.bash_profile  ~/.bashrc
# 仮想コンソールからログイン         o             o
# sshでログイン                      o             o
# ssh ホスト名 ls                    x             o      ただしPS1はセットされない
# screenで新しいウィンドウ           x             o
# bash -i                            x             o
# bash --login                       o             o
# bash --norc                        x             x
# vimの中で:!ls                      x             x
#  set shellcmdflag=--login\ -c      x             o
# シェルスクリプト（#!/bin/bash）    x             x
# cronジョブ                         x             x
#
# ~/.bashrc等の先頭に
#    echo "~/.bashrc loaded"
#    echo 'PS1=' $PS1
#    echo '$-=' $-
#    shopt | grep login_shell
# を仕込んでおくとよい


# バックグラウンドジョブの終了報告を即座に表示する
set -b
# ファイル新規作成時パーミッション
umask 022 

# readline の設定。
if [[ $- == *i* ]]; then
	bind 'set show-all-if-ambiguous on'
	bind 'set completion-ignore-case on'
	bind 'Control-d:delete-char-or-list'
	bind 'Control-u:kill-whole-line'
	bind 'Control-g:insert-completions'
	# カーソル前の単語を複製する。cp や diff でほとんど同じファイル名を2個入力するときに便利。
	bind 'Control-k: "\C-w\C-y \C-y"'
	bind 'Control-l: complete'
	bind 'TAB: menu-complete'
	#bind 'Control-^: "\M--\C-@"'
	# dump 系は M-1 を前に付けると readline コマンド形式で表示する。
	bind '"\C-x\C-f": dump-functions'
	bind '"\C-x\C-v": dump-variables'
	bind '"\C-x\C-m": dump-macros'
	# 現在行を `` でくくる。
	bind '"\C-x`":"\C-a `\C-e`\C-a"'
fi

# コマンドライン履歴保存数
HISTSIZE=100000 
# 履歴に入れないもの
HISTIGNORE="&:ls:ll:fg:bg"

PS1="[\w:\j]$ "

CDPATH=.:$HOME:$HOME/bm

complete -d cd rmdir
complete -A stopped -P '%' bg
complete -j -P '%' fg jobs disown
complete -c command type which man whereis
complete -f -X '!*.c' gcc
complete -f -X '!*.java' javac jikes
complete -v unset
complete -A helptopic help

source ~/.alias

function cd() {
	if [ "x$1" == "x" ]; then
		pushd ~ > /dev/null
	else
		if [ -f "$1" ]; then
			echo "Not directory"
			dir=`dirname "$1"`
		else
			dir="$1"
		fi
		pushd "$dir" > /dev/null
	fi 
}



if [ -e ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi
