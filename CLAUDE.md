# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Overview

Personal dotfiles repo (`~/dotfiles/`). Minimal, portable, built-in-first.
`~/.emacs.d` is a symlink to `emacs.d/` in this repo.

See [docs/PRINCIPLES.md](docs/PRINCIPLES.md) for design philosophy.
See [TODO.md](TODO.md) for planned work.

## Architecture

| Path                   | Purpose                                                                                          |
| ---------------------- | ------------------------------------------------------------------------------------------------ |
| `emacs.d/init.el`      | Main Emacs configuration                                                                         |
| `emacs.d/custom.el`    | Emacs-generated customization (do not hand-edit)                                                 |
| `docs/PRINCIPLES.md`   | Design philosophy, language roadmap, portability goals                                           |
| `TODO.md`              | Tracked work and future plans                                                                    |
| `Makefile`             | lint, check, test, verify, discover, setup, grammars, check-lsp, install-lsp, install-mac, clean |
| `tests/emacs/`         | Emacs test scripts, discovery, sample files                                                      |
| `setup.sh`             | Symlink setup (macOS / Linux)                                                                    |
| `setup.ps1`            | Symlink setup (Windows)                                                                          |
| `emacs.d/elpa/`        | Installed packages (gitignored)                                                                  |
| `emacs.d/tree-sitter/` | Compiled grammars (gitignored)                                                                   |
| `emacs.d/tmp/`         | Backups and auto-saves (gitignored)                                                              |

## init.el Structure

1. Package system setup (MELPA/GNU ELPA, use-package bootstrap)
2. Custom file loading
3. Window system config (GUI: no toolbar, no scrollbar, no splash, 120x50 default)
4. Backup/autosave system (tmp/ directory)
5. Basic editor settings (4-space soft tabs, no real tabs, visible bell)
6. Theme (modus-vivendi, built-in)
7. Whitespace visualization
8. Completion (vertico, orderless, marginalia, corfu, savehist)
9. Tree-sitter support (helper, grammar sources, install command)
10. Language modes with tree-sitter / traditional fallback

## Active Languages

All configured with tree-sitter mode (when grammar installed) and traditional fallback:
C/C++, Python, Go, JSON, YAML, Swift, Zig, Markdown, Emacs Lisp.

## Key Design Constraints

- **Built-in first**: prefer Emacs built-in modes. External packages only when no viable alternative.
- **No frameworks**: no Doom/Spacemacs overlays. Standard Emacs + use-package.
- **Vanilla keybindings**: never remap core Emacs bindings.
- **4-space soft tabs**: `indent-tabs-mode nil`, `tab-width 4` everywhere. Exception: Go uses real tabs.
- **Consistent cross-language**: all programming modes should have the same visual treatment.
- **Tree-sitter preferred** (`*-ts-mode`) where available — Emacs 29+. Falls back gracefully.
- **Portable**: macOS, Linux, Windows. No hardcoded paths.

## Verification

```sh
make lint        # byte-compile init.el
make check       # lint + paren check
make test        # verify mode activation and indentation for all languages
make verify      # check + test in one shot
make discover    # find all Emacs installations and report capabilities
make setup       # headless package install (may fail behind corporate proxy)
make grammars    # install tree-sitter grammars
make check-lsp   # check which LSP servers are installed
make install-lsp # install LSP servers for available toolchains
make install-mac # install Emacs via brew (emacs-app cask)
make clean       # remove elpa/, tree-sitter/, tmp/ for fresh start
```

## Emacs Usage

- Reload config: `M-x eval-buffer` in init.el or restart Emacs
- Customize settings: `M-x customize` (saves to custom.el)
- Install packages: add `use-package` declaration with `:ensure t` to init.el
- Install grammars: `M-x my/install-treesit-grammars` or `make grammars`
