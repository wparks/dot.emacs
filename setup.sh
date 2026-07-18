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

# Cocoa keybindings (macOS only)
if [ "$(uname -s)" = "Darwin" ]; then
    mkdir -p "$HOME/Library/KeyBindings"

    if [ -e "$HOME/Library/KeyBindings/DefaultKeyBinding.dict" ] && [ ! -L "$HOME/Library/KeyBindings/DefaultKeyBinding.dict" ]; then
        echo "ERROR: ~/Library/KeyBindings/DefaultKeyBinding.dict exists and is not a symlink."
        echo "Back it up and remove it first: mv ~/Library/KeyBindings/DefaultKeyBinding.dict ~/Library/KeyBindings/DefaultKeyBinding.dict.bak"
        exit 1
    fi

    if [ -L "$HOME/Library/KeyBindings/DefaultKeyBinding.dict" ]; then
        echo "  ~/Library/KeyBindings/DefaultKeyBinding.dict already symlinked"
    else
        ln -sf "$DOTFILES_DIR/keybindings/DefaultKeyBinding.dict" "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
        echo "  ~/Library/KeyBindings/DefaultKeyBinding.dict -> $DOTFILES_DIR/keybindings/DefaultKeyBinding.dict"
    fi
else
    echo "  skipping Cocoa keybindings (not macOS)"
fi

# Ghostty (macOS only)
if [ "$(uname -s)" = "Darwin" ]; then
    mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"

    if [ -e "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" ] && [ ! -L "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" ]; then
        if [ -s "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" ]; then
            echo "ERROR: ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty exists and is not a symlink."
            echo "Back it up and remove it first: mv \"$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty\" \"$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty.bak\""
            exit 1
        else
            # Empty file is Ghostty's own auto-created placeholder — safe to remove.
            rm "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
        fi
    fi

    if [ -L "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty" ]; then
        echo "  ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty already symlinked"
    else
        ln -sf "$DOTFILES_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
        echo "  ~/Library/Application Support/com.mitchellh.ghostty/config.ghostty -> $DOTFILES_DIR/ghostty/config"
    fi
else
    echo "  skipping Ghostty (not macOS)"
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
