#!/bin/sh
DOTFILES_DIR=$HOME/dotfiles

git clone https://github.com/kanedo/dotfiles.git $DOTFILES_DIR
ln -s $DOTFILES_DIR/.zsh $HOME
ln -s $DOTFILES_DIR/.zshrc $HOME
ln -s $DOTFILES_DIR/.vim $HOME
ln -s $DOTFILES_DIR/.vimrc $HOME
ln -s $DOTFILES_DIR/.gvimrc $HOME
ln -s $DOTFILES_DIR/.tmux.conf $HOME
mkdir $HOME/.vimbackup

#sudo ln -s $HOME/dotfiles/.vim /root
#sudo ln -s $HOME/dotfiles/.vimrc /root
#sudo mkdir /root/.vimbackup

cd $DOTFILES_DIR
git submodule init
git submodule update --recursive

