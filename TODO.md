# TODO

Tracked work for this Emacs configuration.

## Active

- [ ] emacs-plus build failure on macOS Tahoe — pdumper aborts during `Waiting for git...` step. Tested: JIT vs AOT native-comp doesn't help, disabling system-appearance patch doesn't help. Root cause is likely Tahoe sandbox restricting subprocess spawning during pdump. Upstream Emacs issue. Using `emacs-app` cask as workaround.
- [ ] Dotfiles repo restructure — move to `dotfiles/emacs.d/` with `setup.sh` + `setup.ps1`

## Language Support — Phase 2: Navigation

- [ ] Add eglot (built-in LSP client, Emacs 29+) with per-language server config
- [ ] Jump to definition / references for C/C++ (clangd)
- [ ] Jump to definition / references for Python (pyright or pylsp)
- [ ] Jump to definition / references for Go (gopls)
- [ ] Jump to definition / references for Swift (sourcekit-lsp)
- [ ] Jump to definition / references for Zig (zls)

## Language Support — Phase 3: Debugging

- [ ] Evaluate dap-mode or built-in GUD for debugging integration
- [ ] Debug config for C/C++ (lldb/gdb)
- [ ] Debug config for Python (debugpy)
- [ ] Debug config for Go (delve)

## Packages to Evaluate

- [ ] corfu — in-buffer completion (replaces old Company stub)
- [ ] magit — git integration
- [ ] org-mode — basic org config
- [ ] which-key — keybinding discovery
- [ ] highlight-indent-guides — indentation visualization

## Infrastructure

- [ ] Audit README Emacs install instructions periodically
