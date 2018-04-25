ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-C' '--color=always' '--group-directories-first')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if which gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-CG')
            fi
            ;;
    esac
    if which timeout > /dev/null 2>&1; then
        cmd_timeout='timeout 1s'
    elif which gtimeout > /dev/null 2>&1; then
        cmd_timeout='gtimeout 1s'
    else
        cmd_timeout=''
    fi

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_timeout $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l)

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo "\x1b[0;32m--- More files ---\x1b[0m"
    else
        echo "$ls_result"
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd ls_abbrev
