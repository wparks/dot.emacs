#!/bin/sh
# tests/emacs/test-modes.sh — Verify mode activation, features, and startup time
#
# Usage: make test
#        make test EMACS=/path/to/emacs

set -e

REPO_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
EMACS_DIR="$REPO_DIR/emacs.d"
TEST_DIR="$REPO_DIR/tests/emacs"

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

echo "Running tests..."
echo "Emacs: $EMACS"
echo "Version: $EMACS_VERSION"
echo ""

# Helper: run emacs batch with user-emacs-directory set to our emacs.d/
emacs_batch() {
    "$EMACS" --batch --eval "(setq user-emacs-directory \"$EMACS_DIR/\")" -l "$EMACS_DIR/init.el" "$@"
}

# --- Mode activation tests (single Emacs process) ---
echo "Mode activation tests..."

mode_results=$(emacs_batch --eval "
(dolist (spec '((\"test.c\" c-ts-mode nil 4)
                (\"test.cpp\" c++-ts-mode nil 4)
                (\"test.py\" python-ts-mode nil 4)
                (\"test.go\" go-ts-mode t 4)
                (\"test.json\" json-ts-mode nil 4)
                (\"test.yaml\" yaml-ts-mode nil 4)
                (\"test.swift\" swift-mode nil 4)
                (\"test.zig\" zig-mode nil 4)
                (\"test.md\" markdown-mode nil 4)
                (\"test.el\" emacs-lisp-mode nil 4)))
  (let* ((file (nth 0 spec))
         (expect-mode (nth 1 spec))
         (expect-tabs (nth 2 spec))
         (expect-tw (nth 3 spec)))
    (find-file (expand-file-name (concat \"tests/emacs/sample-files/\" file) \"$REPO_DIR\"))
    (let ((mode-ok (eq major-mode expect-mode))
          (tabs-ok (eq indent-tabs-mode expect-tabs))
          (tw-ok (= tab-width expect-tw)))
      (princ (format \"%s|%s|%s|%s|%s|%s|%s\n\"
                     file
                     (if (and mode-ok tabs-ok tw-ok) \"PASS\" \"FAIL\")
                     major-mode expect-mode
                     indent-tabs-mode expect-tabs tab-width)))))" 2>/dev/null)

echo "$mode_results" | while IFS='|' read -r file status got_mode exp_mode got_tabs exp_tabs got_tw; do
    if [ "$status" = "PASS" ]; then
        printf "  PASS  %-12s  %-22s  tabs:%-5s  tw:%s\n" "$file" "$got_mode" "$got_tabs" "$got_tw"
    else
        printf "  FAIL  %-12s  mode:%s(want %s) tabs:%s(want %s) tw:%s\n" \
               "$file" "$got_mode" "$exp_mode" "$got_tabs" "$exp_tabs" "$got_tw"
    fi
done

pass_count=$(echo "$mode_results" | grep -c "PASS" || true)
fail_count=$(echo "$mode_results" | grep -c "FAIL" || true)
PASS=$((PASS + pass_count))
FAIL=$((FAIL + fail_count))

# --- Startup time ---
echo ""
echo "Startup time (batch load of init.el):"
start_ms=$(python3 -c 'import time; print(int(time.time()*1000))')
emacs_batch --eval '(kill-emacs)' 2>/dev/null
end_ms=$(python3 -c 'import time; print(int(time.time()*1000))')
elapsed=$((end_ms - start_ms))
echo "  ${elapsed}ms"
if [ "$elapsed" -gt 1500 ]; then
    printf "  FAIL  startup exceeds 1500ms hard limit\n"
    FAIL=$((FAIL + 1))
elif [ "$elapsed" -gt 1000 ]; then
    printf "  NOTE  startup exceeds 1000ms target (still under 1500ms limit)\n"
    PASS=$((PASS + 1))
else
    printf "  PASS  startup under 1000ms target\n"
    PASS=$((PASS + 1))
fi

# --- Feature activation tests (single Emacs process) ---
echo ""
echo "Feature tests..."

feature_results=$(emacs_batch --eval "
(dolist (spec '((\"vertico-mode active\" (bound-and-true-p vertico-mode))
               (\"marginalia-mode active\" (bound-and-true-p marginalia-mode))
               (\"orderless in styles\" (memq 'orderless completion-styles))
               (\"corfu-mode active\" (bound-and-true-p global-corfu-mode))
               (\"savehist-mode active\" (bound-and-true-p savehist-mode))
               (\"show-paren-mode hook\" (memq 'show-paren-mode prog-mode-hook))
               (\"global-hl-line-mode\" (bound-and-true-p global-hl-line-mode))
               (\"indent-tabs-mode off\" (not (default-value 'indent-tabs-mode)))
               (\"tab-width is 4\" (= (default-value 'tab-width) 4))
               (\"no lockfiles\" (not create-lockfiles))
               (\"backup-by-copying\" backup-by-copying)))
  (let ((name (nth 0 spec))
        (expr (nth 1 spec)))
    (princ (format \"%s|%s\n\" (if (eval expr) \"PASS\" \"FAIL\") name))))" 2>/dev/null)

echo "$feature_results" | while IFS='|' read -r status name; do
    printf "  %s  %s\n" "$status" "$name"
done

feat_pass=$(echo "$feature_results" | grep -c "PASS" || true)
feat_fail=$(echo "$feature_results" | grep -c "FAIL" || true)
PASS=$((PASS + feat_pass))
FAIL=$((FAIL + feat_fail))

echo ""
echo "Results: $PASS passed, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
    exit 1
fi
