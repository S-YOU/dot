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


# オプション。現在の設定を表示するには echo $-
# リダイレクトで既存ファイルを上書きしない
set -C 
# バックグラウンドジョブの終了報告を即座に表示する
set -b
# ファイル新規作成時パーミッション
umask 022 
# コアファイルを作らない
ulimit  -c 0 

# shopt。一覧を表示するには shopt -p

# 設定されている場合、cd 変数名 とできる
shopt -u cdable_vars
# 設定されている場合、 cd コマンドのディレクトリ要素におけるスペルのちょっとした誤りは修正されます。チェックされる誤りは、文字の入れ替わり・文字の欠け・ 1 文字余分にあることです。訂正できた場合には、訂正後のファイル名が表示され、コマンドは続けて実行されます。このオプションが使われるのは対話的シェルだけです。 
shopt -u cdspell
# 設定されている場合、 bash はハッシュ表で見つけたコマンドを実行する前に実際に存在するかどうかをチェックします。ハッシュされているコマンドが既に無くなっている場合、通常のパス検索が行われます。 
shopt -u checkhash
# 設定されている場合、bash はコマンドの実行後に毎回ウィンドウの大きさをチェックし、必要に応じて LINES と COLUMNS の値を更新します。 
shopt -u checkwinsize
# 設定されている場合、 bash は複数行に分かれているコマンドの全ての行を、同じ履歴エントリに保存しようとします。これを使うと、複数行に分かれているコマンドの再編集が容易になります。 
shopt -s cmdhist
# 設定されている場合、 bash は `.' で始まるファイル名をパス名展開の結果に含めます。 
shopt -u dotglob
# 設定されている場合、組み込みコマンド exec への引き数として指定されたファイルが実行できなくても、対話的でないシェルが終了しません。対話的シェルは exec に失敗しても終了しません。 
shopt -u execfail
# 設定されている場合、エイリアスが前述の エイリアス セクションで説明したように展開されます。このオプションは、対話的なシェルではデフォルトで有効です。 
shopt -s expand_aliases
# デバッグ用機能を有効にする。
shopt -u extdebug
# 設定されている場合、拡張されたパターンマッチング機能が有効になります。これについては、前述のパス名展開で説明しています。 
shopt -u extglob
# ???
shopt -s extquote
# パターンがファイル名にマッチしなかったとき展開エラーとする。
shopt -u failglob
# 候補がそれしかないときでも $FIGNORE で指定された拡張子のファイルは補完しない。
shopt -s force_fignore
# エラーメッセージを GNU フォーマットで表示する。
shopt -u gnu_errfmt
# 設定されている場合、シェルの終了時に履歴リストが変数 HISTFILE の値で指定しているファイルに追加されます。ファイルへの上書きは行われなくなります。 
shopt -u histappend
# この変数が設定されており、かつ readline が使われている場合、ユーザは失敗した履歴置換を再編集できます。 
shopt -u histreedit
# この変数が設定されており、かつ readline が使われている場合、履歴置換の結果は即座にはシェルのパーザに渡されません。その代わり、結果として得られた行は readline の編集バッファに読み込まれ、さらに修正できます。 
shopt -u histverify
# この変数が設定されており、かつ readline が使われている場合、bash は @ を含む単語を補完する時にホスト名補完を実行しようとします (前述の READLINE ライブラリ のセクションにおける 補完 を参照)。これはデフォルトで有効になっています。 
shopt -s hostcomplete
# 設定されている場合、bash は対話的なログインシェルを終了する時に、全てのジョブに SIGHUP を送ります。 
shopt -u huponexit
# 設定されている場合、 # で始まる単語について、その単語とその行の残りの文字を対話的シェルに無視させることができます (前述の コメント セクションを参照)。このオプションはデフォルトで有効になっています。 
shopt -s interactive_comments
# 設定されており、かつ cmdhist オプションが有効ならば、複数行に分かれているコマンドは (セミコロンで区切られるのではなく) できる限り途中に改行を埋め込むことで履歴に保存されます。 
shopt -u lithist
#  ログインシェルにおいて自動的に設定される。
shopt -u login_shell
# 設定されており、かつ bash がメールをチェックするファイルが前回のチェック以降にアクセスされている場合、メッセージ ``The mail in mailfile has been read'' が表示されます。 
shopt -u mailwarn
# 空行に対してコマンド補完をしない
shopt -s no_empty_cmd_completion
# 設定されている場合、 bash はパス名展開 (前述の パス名展開 を参照) を行う時に、ファイル名の大文字と小文字を区別せずにマッチングを行います。 
shopt -u nocaseglob
#  case や [[ で大文字・小文字を無視してパターンマッチングする
shopt -u nocasematch
# 設定されている場合、 bash はどのファイルにもマッチしないパターン (前述の パス名展開 を参照) を、その文字列自身ではなく、空文字列に展開します。 
shopt -u nullglob
# 設定されている場合、プログラム補完機能 (前述のプログラム補完を参照) が有効になります。このオプションはデフォルトで有効になっています。 
shopt -s progcomp
# 設定されている場合、プロンプト文字列に対して変数展開とパラメータ展開が行われます。この展開は前述の プロンプト セクションで説明した展開が行われた後に行われます。このオプションはデフォルトで有効になっています。 
shopt -s promptvars
# シェルが制限モードで起動された場合、このオプションが設定されます (後述の 制限付きのシェル セクションを参照)。この値を変更することはできません。これは起動ファイルが実行される時にもリセットされないので、シェルが制限付きかどうかを起動ファイル内部で知ることができます。 
shopt -u restricted_shell
# 設定されている場合、組み込みコマンド shift においてシフトの回数が位置パラメータの数を超えると、エラーメッセージが出力されます。 
shopt -u shift_verbose
# 設定されている場合、組み込みコマンド source (.) は PATH の値を使って、引き数として与えられたファイルを含むディレクトリを見つけます。このオプションはデフォルトで有効です。 
shopt -u sourcepath
# 設定されている場合、組み込みコマンド echo はデフォルトでバックスラッシュによるエスケープシーケンスを展開します。
shopt -u xpg_echo

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

e_normal=`echo -e "\033[0m"`
e_red=`   echo -e "\033[0;31m"`
e_RED=`   echo -e "\033[1;31m"`
e_green=` echo -e "\033[0;32m"`
e_GREEN=` echo -e "\033[1;32m"`
e_yellow=`echo -e "\033[0;33m"`
e_YELLOW=`echo -e "\033[1;33m"`
e_blue=`  echo -e "\033[0;34m"`
e_BLUE=`  echo -e "\033[1;34m"`
e_purple=`echo -e "\033[0;35m"`
e_PURPLE=`echo -e "\033[1;35m"`
e_cyan=`  echo -e "\033[0;36m"`
e_CYAN=`  echo -e "\033[1;36m"`

# コマンドライン履歴保存数
HISTSIZE=100000 
# 履歴に入れないもの
HISTIGNORE="&:ls:ll:fg:bg"

PS1="[\w:\j]$ "
case "$HOSTNAME" in
	ip-*)
		# AWS
		PS1="[\u@\h \W]\\$ "
		;;
esac

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

# つねに直前のコマンドの終了状態をチェックさせる。
# もし異常終了した場合は、その状態(数値)を表示する。
function showexit {
	local s=$?
	if [[ $s -eq 0 ]]; then return; fi
	echo "${e_PURPLE}exit $s${e_normal}"
}
PROMPT_COMMAND=showexit


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


gcc-predefined-macros() {
     gcc -v -E -dM - < /dev/null
}

gcc-including-files() {
	`gcc -print-prog-name=cc1` -E -H -quiet "$@" > /dev/null
}

gcc-system-include-path() {
	cpp -v < /dev/null 2>&1 >/dev/null|sed -ne '/#include <.*starts here:/,/End of search list/p' | body 1 1
}

gcc-make-depend() {
	gcc -MM "$@"
}

gcc-make-depend-system() {
	gcc -M "$@"
}

# TODO: 依存関係が最新で、なにもmakeされない場合に対応
show-compile-command() {
	prestime "$1"
	touch "$1"
	command make -n | grep -e "$1"
	restime "$1"
}

gcc-preprocess() {
	local compile_command=`show-compile-command $1`
	if [ -z "$compile_command" ]; then
		echo "Don't know how to compile: $1" 1>&2
		return 1
	else
		local preprocess_command=`echo "$compile_command"|sed -e 's@cc@cc -E -C@;s@-c@@g;s@-S@@g;s@ -o *[^ ][^ ]*@@g'`
		echo "$preprocess_command" 1>&2
		eval "$preprocess_command"
#cat<<EOF | bash
#$compile_command -E
#EOF
	fi
}

gcc-show-macros() {
	local compile_command=`show-compile-command $1`
	if [ -z "$compile_command" ]; then
		echo "Don't know how to compile: $1" 1>&2
		return 1
	else
		local preprocess_command=`echo "$compile_command"|sed -e 's@cc@cc -EC -dM@;s@-c@@g;s@-S@@g;s@ -o *[^ ][^ ]*@@g'`
		eval "$preprocess_command"
	fi
}

# タイトルをコマンド名に変える
preexec() {
  if is_screen; then
    IFS=', ' read -r -a array <<< "$1"
    local cmd=${array[0]}
    cmd=${cmd/*\//}
    #if [ $cmd = ls -o $cmd = ll -o $cmd = cd -o $cmd = .. -o $cmd = pwd ]; then
      #:;
    #else
      echo -ne "\ek${cmd}\e\\"
    #fi
  fi
}
preexec_invoke_exec() {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND
    local this_command=`HISTTIMEFORMAT= history 1 | sed -e "s/^[ ]*[0-9]*[ ]*//"`;
    preexec "$this_command"
}
trap 'preexec_invoke_exec' DEBUG
# タイトルを元に戻す
PROMPT_COMMAND='is_screen && echo -ne "\ekbash\e\\"'
