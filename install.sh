#!/bin/sh
DOTFILES_DIR=$HOME/dotfiles

rm -rf $DOTFILES_DIR

git clone --recurse-submodules https://github.com/kanedo/dotfiles.git $DOTFILES_DIR

if ! command -v starship &> /dev/null
then
	# Install starship
	curl -sS https://starship.rs/install.sh | sh
fi


# Install oh-my-zsh
rm -rf $HOME/.oh-my-zsh/ $HOME/.zshrc $HOME/.vimrc $HOME/.tmux.conf $HOME/.tmux $HOME/.global_ignore $HOME/.vimbackup
ln -fs $DOTFILES_DIR/.zshrc $HOME
ln -fs $DOTFILES_DIR/.vimrc $HOME
ln -fs $DOTFILES_DIR/.tmux.conf $HOME
ln -fs $DOTFILES_DIR/.tmux $HOME
ln -fs $DOTFILES_DIR/.global_ignore $HOME
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
rm -rf $HOME/.oh-my-zsh/custom/
ln -fs $DOTFILES_DIR/.oh-my-zsh/custom $HOME/.oh-my-zsh/custom
mkdir $HOME/.vimbackup

# install tpm
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

git config --global core.excludesfile ~/.global_ignore
