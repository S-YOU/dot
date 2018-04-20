# zsh + screen で端末に表示されてる文字列を補完する
# http://secondlife.hatenablog.jp/entry/20060108/1136650653
# をベースに少し改変

# dabbrev
HARDCOPYFILE=$HOME/tmp/screen-hardcopy
touch $HARDCOPYFILE

dabbrev-complete() {
    local reply
    screen -X hardcopy $HARDCOPYFILE
    local lang_save="$LANG"
    LANG=C reply=($(sed -E -e '/^$/d' -e 's/[^0-9A-Za-z.,~!_-]+/ /g' $HARDCOPYFILE | sed '$ d' 2> /dev/null))
    LANG="$lang_save"
    compadd -- "${reply[@]%[*/=@|]}"
}

# zle -C <ウィジェット名> <挙動> <関数名>
zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^o' dabbrev-complete
#bindkey '^o^_' reverse-menu-complete
