export ZSH=~/.zsh

# Load all of the config files in ~/oh-my-zsh that end in .zsh
for config_file ($ZSH/lib/*.zsh) source $config_file

# Load and run compinit
# add .zsh/completion to fpath for autocompletion
export FPATH=~/.zsh/completion:$FPATH
autoload -U compinit
compinit -i
