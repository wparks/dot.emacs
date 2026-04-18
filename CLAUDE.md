# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Overview

Personal Emacs configuration (~/.emacs.d/). Minimal, portable, built-in-first.
See [docs/PRINCIPLES.md](docs/PRINCIPLES.md) for design philosophy and direction.

## Architecture

| File / Dir           | Purpose                                                  |
| -------------------- | -------------------------------------------------------- |
| `init.el`            | Main configuration: packages, UI, editor settings, modes |
| `custom.el`          | Emacs-generated customization (do not hand-edit)         |
| `docs/PRINCIPLES.md` | Design philosophy, language roadmap, portability goals   |
| `Makefile`           | `make lint` byte-compiles, `make check` runs all checks  |
| `elpa/`              | Installed packages (gitignored)                          |
| `tmp/`               | Backups and auto-saves (gitignored)                      |

## init.el Structure

1. Package system setup (MELPA/GNU ELPA, use-package bootstrap)
2. Custom file loading
3. Window system config (GUI: no toolbar, no scrollbar, no splash)
4. Backup/autosave system (tmp/ directory)
5. Basic editor settings (4-space soft tabs, no real tabs, visible bell)
6. Theme (spacemacs-dark)
7. Mode configs via use-package

## Active Languages

Emacs Lisp (configured). Planned: C/C++, Python, Swift, Go, Zig, JSON, YAML, Markdown.

Rust was removed — not in active use.

## Key Design Constraints

- **Built-in first**: prefer Emacs built-in modes. External packages only when no viable alternative.
- **No frameworks**: no Doom/Spacemacs overlays. Standard Emacs + use-package.
- **Vanilla keybindings**: never remap core Emacs bindings.
- **4-space soft tabs**: `indent-tabs-mode nil`, `tab-width 4` everywhere, all modes.
- **Consistent cross-language**: all programming modes should have the same visual treatment.
- **Tree-sitter modes preferred** (`*-ts-mode`) where available — Emacs 29+.
- **Portable**: macOS, Linux, Windows. No hardcoded paths.

## Verification

```sh
make lint    # byte-compile init.el
make check   # lint + paren check
emacs --batch -l init.el   # test clean load
```

## Emacs Usage

- Reload config: `M-x eval-buffer` in init.el or restart Emacs
- Customize settings: `M-x customize` (saves to custom.el)
- Install packages: add `use-package` declaration with `:ensure t` to init.el
