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
autoload edit-command-line; zle -N edit-command-line
autoload -U zed     # zed -f 関数名　でシェル関数を編集できるようになる

# Emacs(bash)と同じキーバインド
bindkey -e
bindkey "^I" menu-expand-or-complete
bindkey "^O" accept-and-hold
bindkey "^X^E" edit-command-line 

bindkey "^[w" copy-prev-shell-word
bindkey "^[^[" vi-cmd-mode
bindkey -M vicmd "b" backward-word
bindkey -M vicmd "w" forward-word
# 2015-05-26 C-zでfg。実験的に導入
#bindkey -s "^Z" "^Ufg^M"

autoload -Uz colors && colors

#-----------------------------------------------------------------------------
#   オプション
#-----------------------------------------------------------------------------
setopt auto_cd              # ディレクトリ名だけで cd
setopt auto_pushd           # cd で pushd
setopt pushd_ignore_dups    # pushdで重複したディレクトリを入れないようにする
setopt complete_aliases     # alias v=vim としたとき、vに対してvについての補完をする（vimではなく）
#setopt noclobber           # リダイレクトで既存ファイルを上書きしない
setopt extended_history     # 履歴ファイルに時刻を記録
#setopt share_history       # 複数シェル間で履歴を共有
setopt append_history       # 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt inc_append_history   # コマンドが入力されるとすぐに追加
setopt interactive_comments # 対話モードでもコメントを使えるように
setopt extendedglob         # ~ ^ ** () などを使えるようにする
setopt notify               # rm * を実行する前に確認する
setopt hist_ignore_space    # スペースで始まるコマンドを履歴に残さない
setopt glob_complete        # *<Tab>の挙動を bash 風に
setopt sh_word_split        # クォートされていない変数の値の中の空白の扱い
setopt hist_ignore_dups     # 連続した同じコマンドを履歴ファイルに入れない
setopt hist_find_no_dups    # Ctrl-rで同じコマンドを2回以上表示させない
setopt hist_ignore_all_dups # 新しいエントリが重複なら古いエントリを削除する
setopt nobanghist           # ! によるヒストリ展開を無効化する
setopt prompt_subst         # プロンプトでコマンド置換等を展開するようにする
setopt complete_in_word     # 語の途中でもカーソル位置で補完
is-at-least 5.2 && setopt glob_star_short  # **.c で **/*.c と同じ展開をする

CDPATH=$HOME/bm:$HOME/git:$HOME
HISTFILE=$HOME/.zhistory
HISTSIZE=100000
SAVEHIST=100000 
WORDCHARS='_-.'             # デフォルトは *?_-.[]~=/&;!#$%^(){}<>

#-----------------------------------------------------------------------------
#   補完
#-----------------------------------------------------------------------------
autoload -Uz compinit && compinit -u
zstyle ':completion:*' use-cache yes

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

#compctl -M 'm:{a-z}={A-Z}' # 大文字小文字を区別しない
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
#   ウィジェット
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

repeat_last_command() {
    zle _up-line-or-history-ignoring
    zle accept-line
}
zle -N repeat_last_command
bindkey "^[k" repeat_last_command

if [ "$SELECTOR" != "" ]; then
    _dirstack_widget() {
        LBUFFER="${LBUFFER}$(dirs -p | sed -e '1d' -e 's@$@/@' | $SELECTOR --height 40% --reverse)"
        local ret=$?
        zle redisplay
        typeset -f zle-line-init >/dev/null && zle zle-line-init
        return $ret
    }
    zle     -N   _dirstack_widget
    bindkey '^[g' _dirstack_widget
else
    # dirs -vの結果をコマンドプロンプトの下に表示する
    _showdirstack() {
        _values $(dirs -v | while read -r num dirname; do echo "${dirname}[${num}]"; done)
    }
    compdef _showdirstack showdirstack
    _list_dirstack() {
        local buffer_save="$BUFFER"
        local cursor_save="$CURSOR"
        BUFFER="showdirstack "
        CURSOR=$#BUFFER
        zle list-choices
        BUFFER="$buffer_save"
        CURSOR="$cursor_save"
    }
    zle -N _list_dirstack
    bindkey "^[g" _list_dirstack
fi

# 単語展開に対応したタブ補完
_complete-or-expand() {
    case "$BUFFER" in
        b)
            BUFFER="bundle exec "
            CURSOR=$#BUFFER
            ;;
        rs)
            BUFFER="bin/rspec "
            CURSOR=$#BUFFER
            ;;
        ff)
            BUFFER="bin/rspec --fail-fast "
            CURSOR=$#BUFFER
            ;;
        nf)
            BUFFER="bin/rspec --next-failure "
            CURSOR=$#BUFFER
            ;;
        of)
            BUFFER="bin/rspec --only-failures "
            CURSOR=$#BUFFER
            ;;
        *)
            zle menu-expand-or-complete
            ;;
    esac
}
ff="--fail-fast"
nf="--next-failure"
of="--only-failures"
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

if [[ "$SELECTOR" = fzf* ]]; then
    source $DOT/etc/zsh/key-bindings.zsh
fi
source $DOT/etc/zsh/dabbrev-complete.zsh
source $DOT/etc/zsh/format-line.zsh

find_file_in_project() {
    tt
    zle fzf-file-widget
}
zle -N find_file_in_project
bindkey '^S' find_file_in_project

#-----------------------------------------------------------------------------
#   プロンプト
#-----------------------------------------------------------------------------
PROMPT_COLOR=$fg[red]
PROMPT='%{$PROMPT_COLOR%}$(get_prompt_hostname)%{${reset_color}%}$(exit_status_text)       $(get_vcs_info_msg)
[%~:%j]# '
RPROMPT=''

get_prompt_hostname() {
    if [ "$PROMPT_HOSTNAME" = "" ]; then
        echo '@%m'
    else
        echo "@$PROMPT_HOSTNAME"
    fi
}

exit_status_text() {
    echo "%(?.. <%?>)"
}

get_prompt_gip() {
    if [ "$PROMPT_NO_GIP" = "" ]; then
        if [ "$GIP" = "" ]; then
            GIP=$(curl -s ipinfo.io | sed -ne '/"ip":/ {s/.*: "//; s/".*//; p;}')
        fi
        echo "$GIP"
    fi
}

source $DOT/etc/zsh/mollifier-git-zsh-prompt
source $DOT/etc/zsh/safe-paste.plugin.zsh
source $DOT/etc/zsh/auto-ls.zsh
source $DOT/etc/zsh/zsh-vi-search.zsh


#-----------------------------------------------------------------------------
#   precmd & preexec
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
                cmd=$(jobs | awk '$2 == "+" {if ($4 == "(signal)") print $5; else print $4;}')
                if [ "$cmd" = "" ]; then
                    cmd="fg"
                fi
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
#   エイリアス
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

# ディレクトリ履歴から選択してcdする
# cd +<Tab> でも同様のことができる
if [ "$SELECTOR" != "" ]; then
    select_recent_dirs_and_cd() {
        local d=$(dirs -p | sed -e 1d | uniq | $SELECTOR --height 6 --reverse)
        eval "cd $d"
    }
    alias ,='select_recent_dirs_and_cd'
fi

# screenのタイトルを手動で設定したとき、固定する
fixtitle() {
    if [ "$1" != "" ]; then
        echo -ne "\ek${1}\e\\"
    fi
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

_cheat() {
    _values $(cheat :list)
}
compdef _cheat cheat

# bashライクなhelp
unalias run-help > /dev/null 2>&1
autoload run-help
alias help=run-help

if [ -e ~/.zshrc.local ]; then
    . ~/.zshrc.local
fi
