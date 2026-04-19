#!/bin/sh
# tests/emacs/discover-emacs.sh — Find all Emacs installations and report capabilities
#
# Usage: make discover
#        sh tests/discover-emacs.sh

echo "Emacs Discovery"
echo "==============="
echo ""

check_emacs() {
    path="$1"
    label="$2"

    if [ ! -x "$path" ]; then
        return
    fi

    version=$("$path" --version 2>&1 | head -1)
    caps=$("$path" --batch --eval '
(let ((native (and (fboundp (quote native-comp-available-p)) (native-comp-available-p)))
      (ts (and (fboundp (quote treesit-available-p)) (treesit-available-p)))
      (up (locate-library "use-package")))
  (message "native-comp:%s tree-sitter:%s use-package-builtin:%s"
           (if native "yes" "no")
           (if ts "yes" "no")
           (if up "yes" "no")))' 2>&1 | grep "native-comp:")

    printf "  %-40s %s\n" "$label" "$version"
    printf "  %-40s %s\n" "" "$caps"

    # Check if user-emacs-directory matches expected
    ued=$("$path" --batch --eval '(princ user-emacs-directory)' 2>/dev/null)
    printf "  %-40s user-emacs-directory: %s\n" "" "$ued"
    echo ""
}

# Known locations
check_emacs "/Applications/Emacs.app/Contents/MacOS/Emacs" "Emacs.app (Spotlight)"
check_emacs "/opt/homebrew/bin/emacs"                       "Homebrew (ARM)"
check_emacs "/usr/local/bin/emacs"                          "Homebrew (Intel) or custom"
check_emacs "/usr/bin/emacs"                                "System Emacs"

# Check PATH emacs if it's different from the above
path_emacs=$(which emacs 2>/dev/null)
if [ -n "$path_emacs" ]; then
    resolved=$(readlink -f "$path_emacs" 2>/dev/null || realpath "$path_emacs" 2>/dev/null || echo "$path_emacs")
    # Only report if not already covered
    case "$resolved" in
        */Applications/Emacs.app/*|/opt/homebrew/bin/emacs|/usr/local/bin/emacs|/usr/bin/emacs)
            ;;
        *)
            check_emacs "$path_emacs" "PATH emacs ($resolved)"
            ;;
    esac
fi

echo "To run tests against a specific binary:"
echo "  make test EMACS=/path/to/emacs"
