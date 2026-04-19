#!/bin/sh
# tests/emacs/install-lsp-servers.sh — Install LSP servers for available toolchains
#
# Usage: make install-lsp
#
# Skips servers whose toolchain is not installed.
# Skips servers that are already installed.
# Continues past failures. Safe to run multiple times.

INSTALLED=0
SKIPPED=0
FAILED=0

try_install() {
    server="$1"
    lang="$2"
    check_cmd="$3"
    toolchain_cmd="$4"
    install_cmd="$5"

    # Already installed
    if command -v "$check_cmd" >/dev/null 2>&1; then
        printf "  OK      %-18s  already installed\n" "$server"
        INSTALLED=$((INSTALLED + 1))
        return
    fi

    # Toolchain not available
    if [ -n "$toolchain_cmd" ] && ! command -v "$toolchain_cmd" >/dev/null 2>&1; then
        printf "  SKIP    %-18s  %s not found\n" "$server" "$toolchain_cmd"
        SKIPPED=$((SKIPPED + 1))
        return
    fi

    printf "  INSTALL %-18s  %s\n" "$server" "$lang"
    if eval "$install_cmd"; then
        INSTALLED=$((INSTALLED + 1))
    else
        printf "  FAIL    %-18s  install command failed (network/proxy issue?)\n" "$server"
        FAILED=$((FAILED + 1))
    fi
}

echo "Installing LSP servers..."
echo ""

# clangd — comes with Xcode Command Line Tools
if command -v clangd >/dev/null 2>&1; then
    printf "  OK      %-18s  already installed\n" "clangd"
    INSTALLED=$((INSTALLED + 1))
elif command -v xcode-select >/dev/null 2>&1; then
    printf "  INSTALL %-18s  C/C++ (via Xcode CLT)\n" "clangd"
    xcode-select --install 2>/dev/null || printf "          (CLT install may already be in progress)\n"
    INSTALLED=$((INSTALLED + 1))
else
    printf "  SKIP    %-18s  not on macOS\n" "clangd"
    SKIPPED=$((SKIPPED + 1))
fi

# pyright — needs pip or brew
if command -v pyright-langserver >/dev/null 2>&1 || command -v pyright >/dev/null 2>&1; then
    printf "  OK      %-18s  already installed\n" "pyright"
    INSTALLED=$((INSTALLED + 1))
elif command -v brew >/dev/null 2>&1; then
    printf "  INSTALL %-18s  Python (via brew)\n" "pyright"
    if brew install pyright; then
        INSTALLED=$((INSTALLED + 1))
    else
        printf "  FAIL    %-18s  brew install failed\n" "pyright"
        FAILED=$((FAILED + 1))
    fi
elif command -v pip3 >/dev/null 2>&1; then
    printf "  INSTALL %-18s  Python (via pip3)\n" "pyright"
    if pip3 install --user pyright; then
        INSTALLED=$((INSTALLED + 1))
        pip_bin=$(pip3 show pyright 2>/dev/null | grep "^Location:" | sed 's|/lib/.*||')
        printf "  NOTE    pyright may need PATH update — check pip3 output above\n"
    else
        printf "  FAIL    %-18s  pip3 install failed\n" "pyright"
        FAILED=$((FAILED + 1))
    fi
else
    printf "  SKIP    %-18s  brew and pip3 not found\n" "pyright"
    SKIPPED=$((SKIPPED + 1))
fi

# gopls — needs go
try_install "gopls" "Go" "gopls" "go" \
    "go install golang.org/x/tools/gopls@latest"

# sourcekit-lsp — comes with Xcode
if command -v sourcekit-lsp >/dev/null 2>&1; then
    printf "  OK      %-18s  already installed\n" "sourcekit-lsp"
    INSTALLED=$((INSTALLED + 1))
else
    printf "  SKIP    %-18s  comes with Xcode\n" "sourcekit-lsp"
    SKIPPED=$((SKIPPED + 1))
fi

# zls — needs zig, try brew first
if command -v zls >/dev/null 2>&1; then
    printf "  OK      %-18s  already installed\n" "zls"
    INSTALLED=$((INSTALLED + 1))
elif command -v brew >/dev/null 2>&1 && command -v zig >/dev/null 2>&1; then
    printf "  INSTALL %-18s  Zig (via brew)\n" "zls"
    if brew install zls; then
        INSTALLED=$((INSTALLED + 1))
    else
        printf "  FAIL    %-18s  brew install failed\n" "zls"
        FAILED=$((FAILED + 1))
    fi
elif command -v zig >/dev/null 2>&1; then
    printf "  SKIP    %-18s  zig found but no brew; install zls manually\n" "zls"
    SKIPPED=$((SKIPPED + 1))
else
    printf "  SKIP    %-18s  zig not found\n" "zls"
    SKIPPED=$((SKIPPED + 1))
fi

echo ""
echo "Results: $INSTALLED ok, $SKIPPED skipped, $FAILED failed"

if [ "$SKIPPED" -gt 0 ] || [ "$FAILED" -gt 0 ]; then
    echo ""
    echo "Run 'make check-lsp' to see current status."
fi
