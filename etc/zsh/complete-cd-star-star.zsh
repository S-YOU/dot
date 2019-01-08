# cd hoge**<Tab>
# でfzfを使ったディレクトリ補完をする。

_fzf_compgen_cd() {
    command find -L "$1" \
        -maxdepth 1 \
        -name .git -prune -o -name .svn -prune -o -type d \
        -a -not -path "$1" -print 2> /dev/null | sed 's@^\./@@'
}

_fzf_complete_cd() {
  __fzf_generic_path_completion "$prefix" "$1" _fzf_compgen_cd \
    "" "/" ""
}
