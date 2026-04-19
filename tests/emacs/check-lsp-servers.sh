#!/bin/sh
# tests/emacs/check-lsp-servers.sh — Check which LSP servers are installed
#
# Usage: make lsp

PASS=0
MISSING=0

check_server() {
    name="$1"
    lang="$2"
    install_hint="$3"
    shift 3

    found=""
    for cmd in "$@"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            path=$(command -v "$cmd")
            found="$cmd"
            break
        fi
    done

    if [ -n "$found" ]; then
        printf "  FOUND   %-18s  %-10s  %s\n" "$name" "$lang" "$path"
        PASS=$((PASS + 1))
    else
        printf "  MISSING %-18s  %-10s  %s\n" "$name" "$lang" "$install_hint"
        MISSING=$((MISSING + 1))
    fi
}

echo "LSP server check..."
echo ""

check_server "clangd"          "C/C++"   "xcode-select --install" \
    clangd

check_server "pyright"         "Python"  "pip install pyright" \
    pyright-langserver pyright pylsp basedpyright-langserver

check_server "gopls"           "Go"      "go install golang.org/x/tools/gopls@latest" \
    gopls

check_server "sourcekit-lsp"   "Swift"   "comes with Xcode" \
    sourcekit-lsp

check_server "zls"             "Zig"     "see https://github.com/zigtools/zls" \
    zls

echo ""
echo "Results: $PASS found, $MISSING missing"
