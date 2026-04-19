# dot.emacs

Personal Emacs configuration. Minimal, portable, built-in-first.

See [docs/PRINCIPLES.md](docs/PRINCIPLES.md) for design philosophy.

## Prerequisites

Emacs 29+ with tree-sitter support. Native compilation recommended for performance.

## Installing Emacs

### macOS

```sh
brew install --cask emacs-app
```

This provides Emacs 30.x with tree-sitter support. For native compilation, try `emacs-plus`:

```sh
brew tap d12frosted/emacs-plus
brew install emacs-plus@30
```

**Note:** emacs-plus may fail to build on the latest macOS (Tahoe). If it does, `emacs-app` works fine — native-comp is a performance optimization, not required.

**Alternatives:**
| Option                                    | Native-comp | Tree-sitter | Notes                                                        |
| ----------------------------------------- | ----------- | ----------- | ------------------------------------------------------------ |
| `brew install --cask emacs-app`           | No          | Yes         | Reliable, pre-built binary                                   |
| `brew install emacs-plus@30`              | Yes         | Yes         | Best option when it builds; may fail on new macOS            |
| `brew install emacs-mac` (railwaycat tap) | Varies      | Yes         | Mitsuharu Yamamoto's macOS-native port; good Mac integration |
| emacsformacosx.com                        | No          | No          | Simple binary download; lacks modern features                |

### Windows

**Option A: Official GNU builds** (simplest)

Download from https://ftp.gnu.org/gnu/emacs/windows/ — Emacs 29+ builds include native compilation.

Extract, add `bin/` to PATH, set `HOME` environment variable to your user directory.

**Option B: MSYS2** (if you already use MSYS2)

```sh
pacman -S mingw-w64-x86_64-emacs
```

Includes native-comp and tree-sitter.

**Notes:**
- Set the `HOME` environment variable so Emacs finds `~/.emacs.d` at the expected location
- Windows symlinks require Developer Mode enabled (Settings > For Developers > Developer Mode)

### Linux

Check your distro's package version first:

```sh
emacs --version
```

If it reports 29+ you're likely fine. Verify native-comp and tree-sitter:

```sh
emacs --batch --eval '(message "native-comp: %s tree-sitter: %s" (native-comp-available-p) (treesit-available-p))'
```

If your distro packages an older version, build from source:

```sh
git clone https://git.savannah.gnu.org/git/emacs.git
cd emacs
./autogen.sh
./configure --with-native-compilation --with-tree-sitter
make -j$(nproc)
sudo make install
```

## Setup

### Quick start (current machine)

If this repo is already checked out as `~/.emacs.d/`:

```sh
emacs  # packages install automatically on first launch
```

### From scratch

```sh
git clone <repo-url> ~/.emacs.d
emacs
```

First launch will download and compile packages — subsequent launches are fast.

### Tree-sitter grammars (optional, recommended)

Tree-sitter provides better syntax highlighting and indentation. Install grammars after first setup:

```sh
make grammars
```

Without grammars, all language modes fall back to traditional regex-based highlighting automatically.

### Dotfiles setup (portable across machines)

This repo can live inside a dotfiles directory and be symlinked:

**macOS / Linux:**
```sh
ln -sf ~/dotfiles/emacs.d ~/.emacs.d
```

**Windows (requires Developer Mode):**
```cmd
mklink /D %USERPROFILE%\.emacs.d %USERPROFILE%\dotfiles\emacs.d
```

For more complex dotfiles management, [chezmoi](https://www.chezmoi.io/) is a cross-platform alternative that works natively on all three platforms.

## Verification

After setup, confirm your Emacs has the features you want:

```sh
make check     # byte-compile lint
make grammars  # install tree-sitter grammars
emacs --batch --eval '(message "native-comp: %s tree-sitter: %s" (native-comp-available-p) (treesit-available-p))'
```

## Structure

| File / Dir           | Purpose                                          |
| -------------------- | ------------------------------------------------ |
| `init.el`            | Main configuration                               |
| `custom.el`          | Emacs-generated customization (do not hand-edit) |
| `docs/PRINCIPLES.md` | Design philosophy and direction                  |
| `Makefile`           | Lint and verification targets                    |
| `elpa/`              | Installed packages (gitignored)                  |
| `tmp/`               | Backups and auto-saves (gitignored)              |

## Current Language Support

Configured with tree-sitter (when grammars installed) and traditional fallbacks:
C/C++, Python, Go, JSON, YAML, Swift, Zig, Markdown, Emacs Lisp

## License

MIT (see LICENSE.md)
