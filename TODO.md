# TODO

Tracked work for this Emacs configuration.

## Active

- [ ] emacs-plus build failure on macOS Tahoe — pdumper aborts during `Waiting for git...` step. Tested: JIT vs AOT native-comp doesn't help, disabling system-appearance patch doesn't help. Root cause is likely Tahoe sandbox restricting subprocess spawning during pdump. Upstream Emacs issue. Using `emacs-app` cask as workaround.

## Language Support — Phase 2: Navigation

Eglot LSP is configured in init.el and auto-attaches to C/C++, Python, Go, Swift, Zig.
`make install-lsp` installs servers, `make check-lsp` shows status.

- [ ] Verify jump-to-definition works end-to-end per language
- [ ] Evaluate whether JSON/YAML LSP is worth adding (vscode-json-languageserver, yaml-language-server)

## Language Support — Phase 3: Debugging

- [ ] Evaluate dap-mode or built-in GUD for debugging integration
- [ ] Debug config for C/C++ (lldb/gdb)
- [ ] Debug config for Python (debugpy)
- [ ] Debug config for Go (delve)

## Packages to Evaluate

- [ ] magit — git integration
- [ ] highlight-indent-guides — indentation visualization
- [ ] bash-ts-mode — tree-sitter shell highlighting

## Infrastructure

- [ ] CI for `make verify` (GitHub Actions or similar)
