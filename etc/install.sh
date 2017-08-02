#!/bin/sh

DOT_BASENAME="dot"
DOT="${DOT:-$HOME/$DOT_BASENAME}"
ETC="$DOT/etc"

mkdir -p ~/bin ~/tmp ~/.vimundo

link() {
    if [ -f "$HOME/$1" ]; then
        mkdir $HOME/dot.orig 2> /dev/null
        mv "$HOME/$1" $HOME/dot.orig
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
ln -sf "$ETC/gdb-dashboard" ~/.gdbinit
link .gdbinit.d
link .gitignore
link .sqliterc
link .vim
ln -sf $ETC/.vim/.vimrc ~/.vimrc
