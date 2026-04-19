# dotfiles

Personal dotfiles. Minimal, portable, built-in-first.

## Quick Start

Clone the repo:

```sh
git clone git@github.com:wparks/dotfiles.git ~/dotfiles
```

Set up symlinks:

```sh
cd ~/dotfiles
./setup.sh
```

Launch Emacs to install packages on first run:

```sh
emacs
```

Then optionally, install tree-sitter grammars:

```sh
make grammars
```

Verify everything works:

```sh
make test
```

**Windows:**

Clone the repo:

```powershell
git clone git@github.com:wparks/dotfiles.git $env:USERPROFILE\dotfiles
```

Change to the repo directory:

```powershell
cd $env:USERPROFILE\dotfiles
```

Set up symlinks (requires Developer Mode):

```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1
```

## What's Inside

| Directory  | Config for                 |
| ---------- | -------------------------- |
| `emacs.d/` | Emacs (init.el, custom.el) |

More configs (git, zsh, etc.) can be added alongside `emacs.d/`.

## Emacs

See [docs/PRINCIPLES.md](docs/PRINCIPLES.md) for design philosophy.

### Installing Emacs

#### macOS

Recommended install:

```sh
make install-mac
```

Installs Emacs 30.x via `emacs-app` (pre-built, tree-sitter included). For native compilation, try `emacs-plus`:

```sh
brew tap d12frosted/emacs-plus
```

```sh
brew install emacs-plus@30
```

**Note:** emacs-plus may fail to build on the latest macOS (Tahoe). `emacs-app` works fine without native-comp.

**Alternatives:**
| Option                                    | Native-comp | Tree-sitter | Notes                                                        |
| ----------------------------------------- | ----------- | ----------- | ------------------------------------------------------------ |
| `brew install --cask emacs-app`           | No          | Yes         | Reliable, pre-built binary                                   |
| `brew install emacs-plus@30`              | Yes         | Yes         | Best option when it builds; may fail on new macOS            |
| `brew install emacs-mac` (railwaycat tap) | Varies      | Yes         | Mitsuharu Yamamoto's macOS-native port; good Mac integration |

#### Windows

Download from https://ftp.gnu.org/gnu/emacs/windows/ — Emacs 29+ builds include native compilation. Set `HOME` environment variable to your user directory. Requires Developer Mode for symlinks.

#### Linux

Check your version (need 29+):

```sh
emacs --version
```

If older, build from source with `--with-native-compilation --with-tree-sitter`.

### Language Support

Configured with tree-sitter (when grammars installed) and traditional fallbacks:
C/C++, Python, Go, JSON, YAML, Swift, Zig, Markdown, Emacs Lisp

## Verification

Run lint and mode/indentation tests in one shot:

```sh
make verify
```

Individual targets:

Find all Emacs installations and their capabilities:

```sh
make discover
```

Byte-compile lint + paren check:

```sh
make check
```

Verify mode activation and indentation:

```sh
make test
```

Install tree-sitter grammars:

```sh
make grammars
```

Remove packages, grammars, caches for fresh start:

```sh
make clean
```

Test against a specific Emacs binary:

```sh
make test EMACS=/path/to/emacs
```

## Structure

| Path                   | Purpose                                                                  |
| ---------------------- | ------------------------------------------------------------------------ |
| `emacs.d/init.el`      | Main Emacs configuration                                                 |
| `emacs.d/custom.el`    | Emacs-generated customization (do not hand-edit)                         |
| `docs/PRINCIPLES.md`   | Design philosophy and direction                                          |
| `tests/emacs/`         | Emacs test scripts and sample files                                      |
| `setup.sh`             | Symlink setup (macOS / Linux)                                            |
| `setup.ps1`            | Symlink setup (Windows)                                                  |
| `Makefile`             | lint, check, test, verify, discover, setup, grammars, install-mac, clean |
| `TODO.md`              | Tracked work and future plans                                            |
| `emacs.d/elpa/`        | Installed packages (gitignored)                                          |
| `emacs.d/tree-sitter/` | Compiled grammars (gitignored)                                           |

## License

MIT (see LICENSE.md)
