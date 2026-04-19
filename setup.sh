#!/bin/sh
# setup.sh — Set up dotfiles symlinks and hooks (macOS / Linux)
#
# Usage: ./setup.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Setting up dotfiles from $DOTFILES_DIR"

# Emacs
if [ -e "$HOME/.emacs.d" ] && [ ! -L "$HOME/.emacs.d" ]; then
    echo "ERROR: ~/.emacs.d exists and is not a symlink."
    echo "Back it up and remove it first: mv ~/.emacs.d ~/.emacs.d.bak"
    exit 1
fi

if [ -L "$HOME/.emacs.d" ]; then
    echo "  ~/.emacs.d already symlinked"
else
    ln -sf "$DOTFILES_DIR/emacs.d" "$HOME/.emacs.d"
    echo "  ~/.emacs.d -> $DOTFILES_DIR/emacs.d"
fi

# Pre-commit hook
if [ -d "$DOTFILES_DIR/.git/hooks" ]; then
    cp "$DOTFILES_DIR/tests/emacs/pre-commit" "$DOTFILES_DIR/.git/hooks/pre-commit"
    echo "  pre-commit hook installed"
fi

echo ""
echo "Done. Launch Emacs to install packages, then run:"
echo "  make grammars   # optional: install tree-sitter grammars"
echo "  make test       # verify everything works"
