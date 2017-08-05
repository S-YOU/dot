# マシン固有の設定は
# ~/.zshrc.local
# に書くこと

# 初期化ファイルの読み込み順
# 1. /etc/zshenv
# 2. ~/.zshenv
# 3. [login mode]
#      i. /etc/zprofile
#     ii. ~/.zprofile
# 4. [interactive]
#      i. /etc/zshrc
#     ii. ~/.zshrc
# 5. [login mode]
#      i. /etc/zlogin
#     ii. ~/.zlogin

# Emacs(bash)と同じキーバインド
bindkey -e
bindkey "^I" menu-expand-or-complete
# 2015-05-26 C-zでfg。実験的に導入
#bindkey -s "^Z" "^Ufg^M"
# 何文字か入力してからC-pを押すと、その文字列で始まるコマンドを検索
#bindkey "^P" up-line-or-search

pathmunge() {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}

setopt auto_cd				# ディレクトリ名だけで cd
setopt auto_pushd			# cd で pushd
setopt complete_aliases     # alias v=vim としたとき、vに対してvについての補完をする（vimではなく）
#setopt noclobber			# リダイレクトで既存ファイルを上書きしない
setopt extended_history		# 履歴ファイルに時刻を記録
#setopt share_history		# 複数シェル間で履歴を共有
setopt append_history		# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt inc_append_history	# コマンドが入力されるとすぐに追加
setopt interactive_comments	# 対話モードでもコメントを使えるように
setopt extendedglob			# ~ ^ ** () などを使えるようにする
setopt notify				# rm * を実行する前に確認する
setopt hist_ignore_space	# スペースで始まるコマンドを履歴に残さない
setopt glob_complete		# *<Tab>の挙動を bash 風に
setopt sh_word_split		# クォートされていない変数の値の中の空白の扱い
setopt hist_ignore_dups		# 連続した同じコマンドを履歴ファイルに入れない
setopt hist_find_no_dups	# Ctrl-rで同じコマンドを2回以上表示させない
setopt prompt_subst			# プロンプトでコマンド置換等を展開するようにする

autoload -Uz colors
colors

autoload -U compinit && compinit
#compctl -M 'm:{a-z}={A-Z}'	# 大文字小文字を区別しない
# 大文字小文字を区別しない。
# ハイフンとアンダースコアで相互にマッチするようにする
case "$OSTYPE" in
	"darwin*")
		zstyle ':completion:*' matcher-list 'm:{-_}={_-}'
		;;
	*)
		zstyle ':completion:*' matcher-list 'm:{a-z-_}={A-Z_-}'
		;;
esac

# カレントに候補がないときだけCDPATHを候補にする
zstyle ':completion*:path-directories' ignored-patterns '*'

compdef _files gm
compdef _files a
compdef _files r
compdef '_files -g "*.hs"' runghc

CDPATH=$HOME:$HOME/bm
HISTFILE=$HOME/.zhistory
HISTSIZE=100000
SAVEHIST=100000 
PROMPT='
[%{${fg[yellow]}%}%}%n@%m%{${reset_color}%}] $(get_vcs_info_msg)
[%~:%j]# '

source ~/dot/etc/mollifier-git-zsh-prompt

# bashと共通のalias
source ~/.alias
# zsh固有のalias

cd() {
	if [ -f "$1" ]; then
		builtin cd -P $(dirname "$1")
	else
		builtin cd -P "$@"
	fi
}

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


# C-l: locateで補完
#bindkey '^L' loc
#zle -C loc menu-expand-or-complete _loc
#_loc() {
#	local wd=$words[-1]
#	if [ "$wd" = "" ]; then
#		return 0
#	fi
#	#files=($(locate $wd | grep ".*${wd}[^/]*$"))
#	local ifs_old="$IFS"
#	IFS=$'\n'
#	files=("${(@f)$(locate -b $wd)}")
#	compadd -M 'l:||.=**' -- $files
#	IFS="$ifs_old"
#}

# pecoの設定
function peco-set-cursor() {
    CURSOR=$#BUFFER             # カーソルを文末に移動
    zle -R -c                   # refresh
}
function peco-select-file() {
    BUFFER="$LBUFFER$(command ls -A | fzf --prompt "$LBUFFER> ")"
    peco-set-cursor
}
function peco-select-file-recursive() {
    BUFFER="$LBUFFER$(command find . -type f | fzf --prompt "$LBUFFER> ")"
    peco-set-cursor
}
zle -N peco-select-file
zle -N peco-select-file-recursive
bindkey '^L'   peco-select-file
bindkey '^X^L' peco-select-file-recursive

#-----------------------------------------------------------------------------
#	precmd & preexec
#-----------------------------------------------------------------------------

# プロンプト表示直前に呼び出される
precmd() {
	vcs_info
	# コマンドの実行にかかった時間を記憶しておく
	ELAPSED_SECONDS=$(( $SECONDS - ${START_SECONDS:-0} ))
	if is_screen; then
		if [ "$fixtitle" = "" ]; then
			# タイトルを元に戻す
			echo -ne "\ekzsh\e\\"
		fi
	fi
}

# コマンド実行直前に呼び出される
preexec() {
	START_SECONDS=$SECONDS
	## 2017-07-24 手動で設定したタイトルも上書きされてしまうのでやめた
	if is_screen; then
		if [ "$fixtitle" = "" ]; then
			# タイトルを変える
			local a
			local args
			a="$1"
			args=("${(@s/ /)a}")
			cmd=${args[1]}
			exclude_commands=(ls ll cd rm .. pwd fixtitle)
			if [ "$cmd" = fg ]; then
				cmd="$last_cmd"
				echo -ne "\ek${cmd}\e\\"
			elif  [[ ${exclude_commands[(r)$cmd]} == "$cmd" ]]; then
				:;
			else
				echo -ne "\ek${cmd}\e\\"
				last_cmd="$cmd"
			fi
		fi
	fi
}

# screenのタイトルを手動で設定したとき、固定する
fixtitle() {
	fixtitle=true
}

unalias run-help > /dev/null 2>&1
autoload run-help
alias help=run-help

type() {
    local ret
    ret=$(builtin type "$@")
    if [[ "$ret" == *"is a shell function from"* ]]; then
        whence -v "$@"
        whence -f "$@"
    else
        echo "$ret"
    fi
}

# URLをペーストしたとき、自動的に?や&をエスケープする
#autoload -U url-quote-magic
#zle -N self-insert url-quote-magic



if [ -e ~/.zprofile.local ]; then
    . ~/.zprofile.local
fi
