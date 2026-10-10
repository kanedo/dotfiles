dotfiles
========

Collection of various config files.

## Installation

```sh
curl -fsSL https://raw.githubusercontent.com/kanedo/dotfiles/main/install.sh | sh
```

The installer:

- checks the dependencies below (and aborts if any are missing)
- clones or updates the repository into `~/dotfiles`
- links the config files into your home directory
- installs [starship](https://starship.rs) and [oh-my-zsh](https://ohmyzsh.sh)
- installs the tmux plugin manager (tpm) and the plugins declared in `.tmux.conf`
- configures git's global ignore file

It works on Linux and macOS. If the tmux plugins fail to install during setup,
run `~/.tmux/plugins/tpm/bin/install_plugins`, or press `prefix + I` inside tmux.

## Dependencies

### macOS (Homebrew)

```sh
brew install git zsh tmux curl fzf fd the_silver_searcher
```

### Debian/Ubuntu

```sh
sudo apt install git zsh tmux curl fzf fd-find silversearcher-ag
```

On Debian/Ubuntu `fd` is installed as `fdfind`; the shell config detects it
automatically.

## Vim

Vim plugins are managed by
[vim-plug](https://github.com/junegunn/vim-plug) and are installed
automatically the first time Vim is launched. Submodules are fetched by the
installer.
