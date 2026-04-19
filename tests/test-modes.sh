#!/bin/sh
# tests/test-modes.sh — Verify mode activation and indentation settings
#
# Usage: make test
#        make test EMACS=/path/to/emacs
#
# Tests against the same Emacs that Emacs.app uses by default.
# Override with EMACS env var to test against a different binary.

set -e

EMACS_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# Default to Emacs.app binary if it exists, then PATH emacs
if [ -z "$EMACS" ]; then
    if [ -x "/Applications/Emacs.app/Contents/MacOS/Emacs" ]; then
        EMACS="/Applications/Emacs.app/Contents/MacOS/Emacs"
    else
        EMACS="emacs"
    fi
fi

EMACS_VERSION=$("$EMACS" --version 2>&1 | head -1)
PASS=0
FAIL=0

echo "Running mode activation tests..."
echo "Emacs: $EMACS"
echo "Version: $EMACS_VERSION"
echo ""

check() {
    file="$1"
    expect_mode="$2"
    expect_tabs="$3"
    expect_tw="$4"

    result=$("$EMACS" --batch -l "$EMACS_DIR/init.el" --eval "
(progn
  (find-file \"$EMACS_DIR/tests/sample-files/$file\")
  (princ (format \"%s|%s|%d\" major-mode indent-tabs-mode tab-width)))" 2>/dev/null)

    got_mode=$(echo "$result" | cut -d'|' -f1)
    got_tabs=$(echo "$result" | cut -d'|' -f2)
    got_tw=$(echo "$result" | cut -d'|' -f3)

    ok=true
    errors=""

    if [ "$got_mode" != "$expect_mode" ]; then
        ok=false
        errors="mode: got $got_mode, expected $expect_mode"
    fi
    if [ "$got_tabs" != "$expect_tabs" ]; then
        ok=false
        errors="$errors tabs: got $got_tabs, expected $expect_tabs"
    fi
    if [ "$got_tw" != "$expect_tw" ]; then
        ok=false
        errors="$errors tab-width: got $got_tw, expected $expect_tw"
    fi

    if [ "$ok" = true ]; then
        printf "  PASS  %-12s  %-22s  tabs:%-5s  tw:%s\n" "$file" "$got_mode" "$got_tabs" "$got_tw"
        PASS=$((PASS + 1))
    else
        printf "  FAIL  %-12s  %s\n" "$file" "$errors"
        FAIL=$((FAIL + 1))
    fi
}

# file              expected-mode         tabs    tab-width
check "test.c"      "c-mode"              "nil"   "4"
check "test.cpp"    "c++-mode"            "nil"   "4"
check "test.py"     "python-mode"         "nil"   "4"
check "test.go"     "go-mode"             "t"     "4"
check "test.json"   "js-json-mode"        "nil"   "4"
check "test.yaml"   "yaml-mode"           "nil"   "4"
check "test.swift"  "swift-mode"          "nil"   "4"
check "test.zig"    "zig-mode"            "nil"   "4"
check "test.md"     "markdown-mode"       "nil"   "4"
check "test.el"     "emacs-lisp-mode"     "nil"   "4"

echo ""

# Startup time measurement
echo "Startup time (batch load of init.el):"
start_ms=$(python3 -c 'import time; print(int(time.time()*1000))')
"$EMACS" --batch -l "$EMACS_DIR/init.el" --eval '(kill-emacs)' 2>/dev/null
end_ms=$(python3 -c 'import time; print(int(time.time()*1000))')
elapsed=$((end_ms - start_ms))
echo "  ${elapsed}ms"
if [ "$elapsed" -gt 2000 ]; then
    echo "  WARNING: startup exceeds 2s"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
