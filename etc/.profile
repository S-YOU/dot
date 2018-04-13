# bashとzsh共通の.profile
# マシン固有の設定は
# ~/.profile.local
# に書くこと

[ "$ECHO_RC_LOADED" != "" ] && echo "~/.profile loaded"

export DOT=${DOT:-$HOME/dot}

. "$DOT/bin/pathmunge"

pathmunge "$DOT/bin"
pathmunge "$HOME/bin"
pathmunge "$HOME/go/bin"
pathmunge . after

export EDITOR='vim'
export IGNORED_DIRS='.git:.svn:CVS:bundle:node_modules'
export LANG=ja_JP.UTF-8
export LC_COLLATE=C
export LESS='-iFMXR -j10'
export LESS_TERMCAP_so=$'\E[48;5;151m'  # lessで反転表示部分をカラー表示
export LESS_TERMCAP_se=$'\E[0m'  # http://misc.flogisoft.com/bash/tip_colors_and_formatting#background1
export LS_COLORS='or=40;31;01'  # リンク先の無いシンボリックリンクの色を変える
export PAGER=less
export PYTHONDONTWRITEBYTECODE=true
export FZF_TMUX_HEIGHT="95%"

umask 002

stty -ixon

# ディスク使用量を表示
echo
command df -h | command awk '/^\/dev/ {gsub(/.[890][0-9]%/, "\x1b[1;31m&\x1b[0m"); print;}'
echo

which screen > /dev/null 2>&1 && screen -ls

if [ -e ~/.profile.local ]; then
    . ~/.profile.local
fi
