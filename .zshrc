export ZSH=~/.zsh

# print hostname in terminal title
echo -e "\033]2;$(hostname)\007"
#Load all of the config files in ~/oh-my-zsh that end in .zsh
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
for config_file ($ZSH/lib/*.zsh) source $config_file

# Load and run compinit
# add .zsh/completion to fpath for autocompletion
export FPATH=~/.zsh/completion:$FPATH
autoload -U compinit
compinit -i

if [[ -f ~/.zshrc_local ]] then
	source ~/.zshrc_local
fi
