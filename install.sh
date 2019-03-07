#!/bin/sh
DOTFILES_DIR=$HOME/dotfiles

git clone https://github.com/kanedo/dotfiles.git $DOTFILES_DIR
ln -s $DOTFILES_DIR/.zsh $HOME
ln -s $DOTFILES_DIR/.zshrc $HOME
ln -s $DOTFILES_DIR/.vim $HOME
ln -s $DOTFILES_DIR/.vimrc $HOME
ln -s $DOTFILES_DIR/.gvimrc $HOME
ln -s $DOTFILES_DIR/.tmux.conf $HOME
ln -s $DOTFILES_DIR/.tmux $HOME
ln -s $DOTFILES_DIR/.global_ignore $HOME
mkdir $HOME/.vimbackup

cd $DOTFILES_DIR
git submodule init
git submodule update --recursive

git config --global core.excludesfile ~/.global_ignore
