#!/bin/sh
# tests/test-modes.sh — Verify mode activation and indentation settings
#
# Usage: make test
# Requires: Emacs with packages installed (make setup)

set -e

EMACS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0

check() {
    file="$1"
    expect_mode="$2"
    expect_tabs="$3"
    expect_tw="$4"

    result=$(emacs --batch -l "$EMACS_DIR/init.el" --eval "
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

echo "Running mode activation tests..."
echo ""

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
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
