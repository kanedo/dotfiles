#!/bin/sh
#
# install.sh - bootstrap these dotfiles on Linux and macOS.
#
# Written in POSIX sh so it works both when piped to dash (`curl ... | sh`)
# and with the (bash-based) sh on macOS.

DOTFILES_DIR="$HOME/dotfiles"
REPO_SSH="git@github.com:kanedo/dotfiles.git"
REPO_HTTPS="https://github.com/kanedo/dotfiles.git"

info() { printf '%s\n' "$*"; }
warn() { printf '%s\n' "$*" >&2; }

# ---------------------------------------------------------------------------
# Dependencies
# ---------------------------------------------------------------------------
dependencies_met=1

require() {
	# require <command> <hint>
	if ! command -v "$1" >/dev/null 2>&1; then
		warn "$1 not found. $2"
		dependencies_met=0
	fi
}

require git  "please install git"
require curl "please install curl"
require zsh  "please install zsh"
require tmux "please install tmux"
require fzf  "please install: https://github.com/junegunn/fzf#installation"
require ag   "please install: https://github.com/ggreer/the_silver_searcher#installing"

# fd is shipped as "fdfind" on Debian/Ubuntu; accept either name.
if ! command -v fd >/dev/null 2>&1 && ! command -v fdfind >/dev/null 2>&1; then
	warn "fd not found. please install: https://github.com/sharkdp/fd#installation"
	dependencies_met=0
fi

if [ "$dependencies_met" -ne 1 ]; then
	warn "Missing dependencies; aborting."
	exit 1
fi

# ---------------------------------------------------------------------------
# Clone or update the repository
# ---------------------------------------------------------------------------
if [ -d "$DOTFILES_DIR/.git" ]; then
	info "Updating existing dotfiles in $DOTFILES_DIR"
	git -C "$DOTFILES_DIR" pull --ff-only ||
		warn "Could not fast-forward; using existing checkout."
	git -C "$DOTFILES_DIR" submodule update --init --recursive
else
	# Refuse to recursively delete anything unexpected.
	case "$DOTFILES_DIR" in
		"$HOME/dotfiles") : ;;
		*)
			warn "Refusing to manage unexpected path: $DOTFILES_DIR"
			exit 1
			;;
	esac

	rm -rf "$DOTFILES_DIR"
	info "Cloning dotfiles into $DOTFILES_DIR"
	if ! git clone --recurse-submodules "$REPO_SSH" "$DOTFILES_DIR" 2>/dev/null; then
		rm -rf "$DOTFILES_DIR"
		git clone --recurse-submodules "$REPO_HTTPS" "$DOTFILES_DIR"
	fi
fi

# ---------------------------------------------------------------------------
# starship (installed into ~/.local/bin, which .zshrc puts on PATH)
# ---------------------------------------------------------------------------
if ! command -v starship >/dev/null 2>&1; then
	info "Installing starship"
	mkdir -p "$HOME/.local/bin"
	curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi

# ---------------------------------------------------------------------------
# Symlink configuration files
# ---------------------------------------------------------------------------
mkdir -p "$HOME/.config"

rm -rf "$HOME/.zshrc" \
	"$HOME/.vimrc" \
	"$HOME/.tmux.conf" \
	"$HOME/.tmux" \
	"$HOME/.global_ignore" \
	"$HOME/.vimbackup" \
	"$HOME/.config/kitty"

ln -fs "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -fs "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
ln -fs "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -fs "$DOTFILES_DIR/.tmux" "$HOME/.tmux"
ln -fs "$DOTFILES_DIR/.global_ignore" "$HOME/.global_ignore"
ln -fs "$DOTFILES_DIR/.config/kitty" "$HOME/.config/kitty"
ln -fs "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# ---------------------------------------------------------------------------
# oh-my-zsh (custom plugins/themes come from the dotfiles checkout via ZSH_CUSTOM)
# ---------------------------------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	info "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# ---------------------------------------------------------------------------
# tmux plugin manager + plugins (runs headless; the @plugin list lives in .tmux.conf)
# ---------------------------------------------------------------------------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	info "Installing tmux plugin manager"
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

info "Installing tmux plugins"
"$HOME/.tmux/plugins/tpm/bin/install_plugins" ||
	warn "tmux plugin installation failed; press prefix + I inside tmux to retry."

# ---------------------------------------------------------------------------
# git global ignore
# ---------------------------------------------------------------------------
git config --global core.excludesfile "$HOME/.global_ignore"

info "Done."
