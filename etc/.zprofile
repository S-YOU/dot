#export ECHO_RC_LOADED=1
[ "$ECHO_RC_LOADED" != "" ] && echo "~/.zprofile loaded"

if [ -e ~/.profile ]; then
    . ~/.profile
fi

# ~/.zprofile.localは要らないと思うので作らない
