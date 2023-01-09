#!/bin/sh
DOTFILES_DIR=$HOME/dotfiles

git clone --recurse-submodules https://github.com/kanedo/dotfiles.git $DOTFILES_DIR
# Install starship
curl -sS https://starship.rs/install.sh | sh

# Install oh-my-zsh
rm -rf $HOME/.oh-my-zsh/
ln -fs $DOTFILES_DIR/.zshrc $HOME
ln -fs $DOTFILES_DIR/.vimrc $HOME
ln -fs $DOTFILES_DIR/.tmux.conf $HOME
ln -fs $DOTFILES_DIR/.tmux $HOME
ln -fs $DOTFILES_DIR/.global_ignore $HOME
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
rm -rf $HOME/.oh-my-zsh/custom/
ln -fs $DOTFILES_DIR/.oh-my-zsh/custom $HOME/.oh-my-zsh/custom
mkdir $HOME/.vimbackup


git config --global core.excludesfile ~/.global_ignore
