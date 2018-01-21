# マシン固有の設定は
# ~/.zshrc.local
# に書くこと

[ "$ECHO_RC_LOADED" != "" ] && echo "~/.zshrc loaded"

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

autoload -Uz is-at-least

# Emacs(bash)と同じキーバインド
bindkey -e
bindkey "^I" menu-expand-or-complete
bindkey "^O" accept-and-hold
bindkey '^]'   vi-find-next-char
bindkey '^[^]' vi-find-prev-char
# 2015-05-26 C-zでfg。実験的に導入
#bindkey -s "^Z" "^Ufg^M"

autoload -Uz colors && colors


#-----------------------------------------------------------------------------
#	オプション
#-----------------------------------------------------------------------------
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
setopt hist_ignore_all_dups # 新しいエントリが重複なら古いエントリを削除する
setopt prompt_subst			# プロンプトでコマンド置換等を展開するようにする
setopt complete_in_word     # 語の途中でもカーソル位置で補完
is-at-least 5.2 && setopt glob_star_short  # **.c で **/*.c と同じ展開をする

CDPATH=$HOME/bm:$HOME/git:$HOME
HISTFILE=$HOME/.zhistory
HISTSIZE=100000
SAVEHIST=100000 


#-----------------------------------------------------------------------------
#	補完
#-----------------------------------------------------------------------------
autoload -Uz compinit && compinit -u

# 補完候補をメニューで選択
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line
bindkey -M menuselect '^D' accept
bindkey -M menuselect '^O' accept-and-infer-next-history
bindkey -M menuselect '^F' forward-char
bindkey -M menuselect '^B' backward-char
bindkey -M menuselect '^P' up-line-or-history
bindkey -M menuselect '^N' down-line-or-history
bindkey -M menuselect '^J' up-line-or-history
bindkey -M menuselect '^K' down-line-or-history

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
#zstyle ':completion*:path-directories' ignored-patterns '*'
# 候補をグループ分けする
zstyle ':completion:*' group-name ''

compdef _files r
compdef '_files -g "*.hs"' runghc
compdef _bm bm
compdef gti='git'

_bm() {
    _files -W ~/bm && return 0
    return 1
}


#-----------------------------------------------------------------------------
#	ウィジェット
#-----------------------------------------------------------------------------

if type fzf > /dev/null 2>&1; then
    SELECTOR="fzf --no-sort --exact"
fi

# fgとbgを完全に無視したCtrl-P
_up-line-or-history-ignoring() {
    zle up-line-or-history
    case "$BUFFER" in
        fg|bg)
            zle up-line-or-history
            ;;
    esac
}
zle -N _up-line-or-history-ignoring
bindkey '^P' _up-line-or-history-ignoring

# 空白で区切りられた単語をシングルクォートで囲む
quote-word() {
    zle set-mark-command
    zle vi-backward-blank-word
    zle quote-region
}
zle -N quote-word
bindkey "^[q" quote-word

# 単語展開に対応したタブ補完
_complete-or-expand() {
    case "$BUFFER" in
        b)
            BUFFER="bundle exec "
            CURSOR=$#BUFFER
            ;;
        rs)
            BUFFER="bundle exec rspec "
            CURSOR=$#BUFFER
            ;;
        ff)
            BUFFER="bundle exec rspec --fail-fast "
            CURSOR=$#BUFFER
            ;;
        nf)
            BUFFER="bundle exec rspec --next-failure "
            CURSOR=$#BUFFER
            ;;
        *)
            zle menu-expand-or-complete
            ;;
    esac
}
zle -N _complete-or-expand
bindkey '^I' _complete-or-expand

# ディレクトリ移動履歴をfzfしてcd
if is-at-least 4.3.11; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-default yes
  zstyle ':completion:*' recent-dirs-insert both
fi

source $DOT/etc/zsh/key-bindings.zsh
bindkey '^S' fzf-file-widget


#-----------------------------------------------------------------------------
#	プロンプト
#-----------------------------------------------------------------------------
PROMPT_COLOR=$fg[red]
PROMPT='$(exit_status_text)%{$PROMPT_COLOR%}$(get_prompt_hostname)$(get_prompt_gip)%{${reset_color}%}
[%~:%j]# '
RPROMPT='$(get_vcs_info_msg)'

get_prompt_hostname() {
	if [ "$PROMPT_HOSTNAME" = "" ]; then
		echo '@%m'
	else
		echo "@$PROMPT_HOSTNAME"
	fi
}

exit_status_text() {
	echo "%(?..<%?> )"
}

get_prompt_gip() {
    if [ "$PROMPT_NO_GIP" = "" ]; then
        echo " $(gip)"
    fi
}

source $DOT/etc/zsh/mollifier-git-zsh-prompt
source $DOT/etc/zsh/safe-paste.plugin.zsh


#-----------------------------------------------------------------------------
#	precmd & preexec
#-----------------------------------------------------------------------------

# プロンプト表示直前に呼び出される
precmd() {
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
			local cmd=${args[1]}
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

# cd: skipping directories that contain only a single sub-directory
# https://www.reddit.com/r/zsh/comments/6omtk9/cd_skipping_directories_that_contain_only_a/
#function chpwd() {
#    files=$(ls -A | wc -l)
#    if [[ $files = "1" ]]; then
#        zmodload zsh/parameter
#        if [[ "cd .." != $history[$HISTCMD] ]]; then
#            f=$(ls -A)
#            if [[ -d "$f" ]]; then
#                cd "$f"
#            fi
#        fi
#    fi
#}

#-----------------------------------------------------------------------------
#	エイリアス
#-----------------------------------------------------------------------------

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

# screenのタイトルを手動で設定したとき、固定する
fixtitle() {
	fixtitle=true
}

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

# bashライクなhelp
unalias run-help > /dev/null 2>&1
autoload run-help
alias help=run-help

if [ -e ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
