# Design Principles

This document captures the philosophy and direction for this Emacs configuration.
It is the canonical reference for design decisions.

## Philosophy

- **Minimal and focused** — the config exists to support writing code, not to be a project itself. Every addition must earn its place.
- **Built-in first** — prefer Emacs built-in packages and modes. Only pull external packages when there is no viable built-in alternative.
- **No frameworks** — no Doom, Spacemacs, or heavy overlays. Standard Emacs with `use-package` for declarative package management.
- **Vanilla keybindings** — 25+ years of muscle memory on standard Emacs keybindings. Do not remap core bindings.
- **Single setup process** — clone the repo, point Emacs at it, launch once. Packages install automatically. No manual steps after that.
- **Fast startup** — defer everything possible. Native compilation when available.

## Visual Goals

- Dark theme (currently modus-vivendi, built-in)
- Minimal UI: no toolbar, no scrollbar, no splash screen
- Whitespace visualization: spaces, tabs, newlines rendered with Unicode marks
- Line numbers in programming modes
- Cursor line highlight
- Consistent visual presentation across all language modes

## Indentation

- 4-space soft tabs everywhere
- No real tab characters (`indent-tabs-mode nil`). Exception: Go uses real tabs per community convention.
- Must hold consistently at all indentation depths and in all modes

## Language Support

Active languages, in rough order of use: C/C++, Python, Swift, Go, Zig, JSON, YAML, Markdown.

Support is added in three phases:
1. **Syntax and style** — highlighting, formatting, coloring. Consistent across modes.
2. **Navigation** — jump to definition, references, documentation lookup.
3. **Debugging** — integrated debugging support per language.

Tree-sitter modes (`*-ts-mode`) are preferred where available (Emacs 29+). They provide better highlighting and indentation than regex-based modes with no external packages for C, Python, JSON, Go.

## Text Editing

Emacs is used for all text, not just code. Plain text and Markdown should have good visualization and editing support. Config formats (JSON, YAML) get the same treatment as programming languages.

## Portability

- Must work on macOS, Linux, and Windows
- All dependencies declared in `init.el` via `use-package` with `:ensure t`
- No hardcoded paths
- README documents how to get the right Emacs build on each platform
- Future: migrate to a dotfiles repo structure with setup scripts for symlinking

## Package Management

- `use-package` as the single declarative interface
- Packages auto-install from MELPA and GNU ELPA on first launch
- Custom settings isolated in `custom.el` (not mixed into `init.el`)
- Unused packages should be removed, not commented out

## Lint and Verification

- `make lint` byte-compiles `init.el` to catch common errors
- `make test` verifies mode activation and indentation settings for all configured languages
- `make setup` installs packages headlessly (may fail behind corporate proxy)
- `make clean` removes all generated state for a fresh start
- Byte-compilation does not catch all issues (notably `setq-default` with misspelled variables) — know the limits
