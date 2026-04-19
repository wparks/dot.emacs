# TODO

Tracked work for this Emacs configuration. Check items off as completed.

## Active

- [x] Install tree-sitter grammars (`make grammars`) and update test expectations
- [ ] Investigate emacs-plus build failure on macOS Tahoe (Abort trap: 6 during pdmp — upstream issue, try `--HEAD` or check back periodically)
- [ ] Dotfiles repo restructure — move to `dotfiles/emacs.d/` with `setup.sh` + `setup.ps1`
- [x] Remove stale `rust-mode` and `jinx` from elpa if they reappear after clean install

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

- [x] vertico + orderless + marginalia — modern completion (replaces old IDO stub)
- [ ] corfu — in-buffer completion (replaces old Company stub)
- [ ] magit — git integration
- [ ] org-mode — basic org config
- [ ] which-key — keybinding discovery
- [ ] highlight-indent-guides — indentation visualization

## Infrastructure

- [x] Pre-commit hook running `make test`
- [ ] Test for tree-sitter mode activation (once grammars installed)
- [ ] Audit README Emacs install instructions periodically
