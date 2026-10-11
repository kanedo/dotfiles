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

## Neovim

The Neovim configuration lives in `.config/nvim` and is symlinked to
`~/.config/nvim` by the installer. Plugins are managed by
[lazy.nvim](https://github.com/folke/lazy.nvim), which bootstraps itself the
first time Neovim is launched.

Neovim itself is not installed by the installer; install it separately
(`brew install neovim` on macOS, `sudo apt install neovim` on Debian/Ubuntu).
Some language servers use [Mason](https://github.com/mason-org/mason.nvim),
which needs `npm`, `unzip`, and a `python3` able to create virtual
environments; servers whose prerequisites are missing are skipped
automatically at startup.
