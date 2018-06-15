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

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# # Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line


if [[ -f ~/.zshrc_local ]] then
	source ~/.zshrc_local
fi
