#!/bin/sh
DOTFILES_DIR=$HOME/dotfiles

# check if dependencies are installed
dependencies_met=1

if ! command fzf 2>&1 /dev/null;
then
	echo "fzf not found. please install: https://github.com/junegunn/fzf#installation"
	dependencies_met=0
fi
if ! command fd 2>&1 /dev/null;
then
	echo "fd not found. please install: https://github.com/sharkdp/fd#on-ubuntu"
	dependencies_met=0
fi
if ! command ag 2>&1 /dev/null;
then
	echo "ag not found. please install: https://github.com/ggreer/the_silver_searcher#installing"
	dependencies_met=0
fi

if [[ "$dependencies_met" != "0" ]];
then
	exit 1;
fi

rm -rf $DOTFILES_DIR

if ! git clone --recurse-submodules git@github.com:kanedo/dotfiles.git $DOTFILES_DIR;
then
	git clone --recurse-submodules https://github.com/kanedo/dotfiles.git $DOTFILES_DIR
fi 

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
mkdir $HOME/.vimbackup

# install tpm
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

git config --global core.excludesfile ~/.global_ignore
