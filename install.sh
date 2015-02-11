cd $HOME
git clone https://github.com/kanedo/dotfiles.git
ln -s $HOME/dotfiles/.zsh $HOME
ln -s $HOME/dotfiles/.zshrc $HOME
ln -s $HOME/dotfiles/.vim $HOME
ln -s $HOME/dotfiles/.vimrc $HOME
mkdir $HOME/.vimbackup

#sudo ln -s $HOME/dotfiles/.vim /root
#sudo ln -s $HOME/dotfiles/.vimrc /root
#sudo mkdir /root/.vimbackup

cd dotfiles
git submodule init && git submodule update -—recursive
