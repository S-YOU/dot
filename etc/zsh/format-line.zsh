# format current command line

format-line() {
    local words=("${(z)BUFFER}")
    local buf=""
    for (( i = 1; i <= $#words; i++ )); do
        if [ $i = 1 ]; then
            buf=$'\n'"${words[$i]}"
        else
            buf="$buf \\"$'\n'"    ${words[$i]}"
        fi
        if [[ "${words[$i]}" = -* && "${words[$((i+1))]}" != -* ]]; then
            buf="$buf ${words[$((i+1))]}"
            (( i++ ))
        fi
    done
    BUFFER="$buf"
    CURSOR=$#BUFFER
}

zle -N format-line
bindkey "^x^f" format-line
