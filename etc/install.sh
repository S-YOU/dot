#!/bin/sh

DOT_BASENAME="dot"
DOT="${DOT:-$HOME/$DOT_BASENAME}"
ETC="$DOT/etc"

mkdir -p ~/bin ~/tmp ~/.vimundo

BACKUP_DIR="$HOME/dot/$(date +%Y%m%d%H%M%S)"

link() {
    if [ -f "$HOME/$1" ]; then
        mkdir -p $BACKUP_DIR
        mv "$HOME/$1" $BACKUP_DIR
    fi
    ln -sf $ETC/$1 ~
}

#echo "source $DOT/etc/.profile" >> ~/.profile
#echo "source ~/.profile" >> ~/.bash_profile
#echo "source $DOT/etc/.bashrc" >> ~/.bashrc
#echo "source $DOT/etc/.alias" >> ~/.alias
#echo "source $DOT/etc/.zshrc" >> ~/.zshrc
#echo 'source $HOME/svn/etc/.screenrc' >> ~/.screenrc

link .alias
link .ctags
link .gdbinit
link .gdbinit.d
link .gitignore
link .sqliterc
link .vim
ln -sf $ETC/.vim/.vimrc ~/.vimrc
