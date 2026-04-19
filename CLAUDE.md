# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Overview

Personal Emacs configuration (~/.emacs.d/). Minimal, portable, built-in-first.
See [docs/PRINCIPLES.md](docs/PRINCIPLES.md) for design philosophy and direction.
See [TODO.md](TODO.md) for planned work.

## Architecture

| File / Dir           | Purpose                                                  |
| -------------------- | -------------------------------------------------------- |
| `init.el`            | Main configuration: packages, UI, editor settings, modes |
| `custom.el`          | Emacs-generated customization (do not hand-edit)         |
| `docs/PRINCIPLES.md` | Design philosophy, language roadmap, portability goals   |
| `TODO.md`            | Tracked work and future plans                            |
| `Makefile`           | lint, check, test, setup, grammars, clean                |
| `tests/`             | Test script and sample files for mode verification       |
| `elpa/`              | Installed packages (gitignored)                          |
| `tree-sitter/`       | Compiled grammars (gitignored)                           |
| `tmp/`               | Backups and auto-saves (gitignored)                      |

## init.el Structure

1. Package system setup (MELPA/GNU ELPA, use-package bootstrap)
2. Custom file loading
3. Window system config (GUI: no toolbar, no scrollbar, no splash)
4. Backup/autosave system (tmp/ directory)
5. Basic editor settings (4-space soft tabs, no real tabs, visible bell)
6. Theme (spacemacs-dark)
7. Whitespace visualization
8. Tree-sitter support (helper, grammar sources, install command)
9. Language modes with tree-sitter / traditional fallback

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
make lint      # byte-compile init.el
make check     # lint + paren check
make test      # verify mode activation and indentation for all languages
make setup     # headless package install (may fail behind corporate proxy)
make grammars  # install tree-sitter grammars
make clean     # remove elpa/, tree-sitter/, tmp/ for fresh start
```

## Emacs Usage

- Reload config: `M-x eval-buffer` in init.el or restart Emacs
- Customize settings: `M-x customize` (saves to custom.el)
- Install packages: add `use-package` declaration with `:ensure t` to init.el
- Install grammars: `M-x my/install-treesit-grammars` or `make grammars`
