#!/bin/sh

DOT_BASENAME="dot"
DOT="${DOT:-$HOME/$DOT_BASENAME}"
ETC="$DOT/etc"

mkdir -p ~/bin ~/tmp ~/.vimundo

BACKUP_DIR="$HOME/dot_backup"
TIME=$(date +%Y%m%d_%H%M%S)

link() {
    if [ -f "$HOME/$1" ]; then
        mkdir -p $BACKUP_DIR
        mv -v "$HOME/$1" "$BACKUP_DIR/$1.$TIME"
    fi
    ln -sfv $ETC/$1 ~
}

link .alias
link .ctags
link .gdbinit
link .gdbinit.d
link .ghci
link .gitignore
link .inputrc
link .irbrc
link .sqliterc
link .pryrc
link .vim
ln -sf $ETC/.vim/.vimrc ~/.vimrc
