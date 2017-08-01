#echo "~/.profile loaded"

# CentOSからコピペ
# $PATHにディレクトリを1個追加するシェル関数
# 使い方：
# ↓先頭に追加する
# pathmunge "/usr/local/bin"
# ↓末尾に追加する
# pathmunge "/usr/local/bin" after
pathmunge () {
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

pathmunge "$HOME/svn/bin"
pathmunge "$HOME/bin"
pathmunge . after

unset pathmunge

export EDITOR="vim --cmd 'set noswapfile'"
export LANG=ja_JP.UTF-8
export LC_COLLATE=C
export LESS='-iFMXR -j10'
export PAGER=less
export PGUSER=postgres

umask 002

stty -ixon

echo
command df -h | command awk '/^\/dev/ {gsub(/.[890][0-9]%/, "\x1b[1;31m&\x1b[0m"); print;}'
echo
