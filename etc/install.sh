#!/bin/sh

ETC=~/svn/etc

mkdir -p ~/bin ~/tmp ~/.vimundo

link() {
    if [ -f "$HOME/$1" ]; then
        mkdir $HOME/dot.orig 2> /dev/null
        mv "$HOME/$1" $HOME/dot.orig
    fi
    ln -s $ETC/$1 ~

}

echo 'source ~/svn/etc/.profile' >> ~/.profile
echo 'source ~/.profile' >> ~/.bash_profile
echo 'source ~/svn/etc/.bashrc' >> ~/.bashrc
echo 'source ~/svn/etc/.alias' >> ~/.alias
echo 'source ~/svn/etc/.zshrc' >> ~/.zshrc
link .vim
ln -s $ETC/.vim/.vimrc ~/.vimrc
echo 'source $HOME/svn/etc/.screenrc' >> ~/.screenrc
link .ctags
cat >> ~/.gitconfig <<EOF
[include]
	    path = ~/svn/etc/.gitconfig
EOF
link .gitignore
link .sqliterc
ln -s ~/svn/etc/gdb-dashboard ~/.gdbinit
link .gdbinit.d
