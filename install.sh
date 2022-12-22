#!/bin/sh
DOTFILES_DIR=$HOME/dotfiles

git clone https://github.com/kanedo/dotfiles.git $DOTFILES_DIR
git checkout main
ln -s $DOTFILES_DIR/.zshrc $HOME
ln -s $DOTFILES_DIR/.vimrc $HOME
ln -s $DOTFILES_DIR/.tmux.conf $HOME
ln -s $DOTFILES_DIR/.tmux $HOME
ln -s $DOTFILES_DIR/.global_ignore $HOME
mkdir $HOME/.vimbackup

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git config --global core.excludesfile ~/.global_ignore
