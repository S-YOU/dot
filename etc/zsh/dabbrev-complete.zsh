# zsh + screen で端末に表示されてる文字列を補完する
# http://secondlife.hatenablog.jp/entry/20060108/1136650653
# をベースに少し改変

# dabbrev
HARDCOPYFILE=$HOME/tmp/screen-hardcopy
touch $HARDCOPYFILE

dabbrev-complete() {
    local reply
    screen -X hardcopy $HARDCOPYFILE
    reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d'))
    compadd - "${reply[@]%[*/=@|]}"
}

zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^o' dabbrev-complete
#bindkey '^o^_' reverse-menu-complete
