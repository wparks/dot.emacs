.PHONY: lint check clean grammars setup test

# Byte-compile init.el to catch common errors.
# Catches: missing requires, bad function calls, setq of free variables.
# Does NOT catch: setq-default of misspelled variables (valid Elisp).
lint:
	@echo "Byte-compiling init.el..."
	@emacs --batch -f package-initialize --eval '(byte-compile-file "init.el")' 2>&1
	@rm -f init.elc
	@echo "Done."

# Run lint plus additional checks
check: lint
	@echo "Running additional checks..."
	@emacs --batch --eval '(with-temp-buffer (insert-file-contents "init.el") (emacs-lisp-mode) (check-parens))' 2>&1
	@echo "All checks passed."

clean:
	rm -f init.elc
	rm -rf elpa/
	rm -rf tree-sitter/
	rm -rf tmp/
	@echo "Cleaned. Restart Emacs to reinstall packages."

# Install tree-sitter grammars (requires Emacs 29+ with tree-sitter).
# Run once after initial setup to enable tree-sitter modes.
grammars:
	@echo "Installing tree-sitter grammars..."
	@emacs --batch -l init.el --eval '(my/install-treesit-grammars)' 2>&1
	@echo "Done."

# Headless install: refresh package index, load init to trigger use-package installs.
# Note: may fail on corporate networks where batch mode can't reach MELPA through
# the proxy. In that case, launch Emacs normally to install packages.
setup:
	@echo "Refreshing package index..."
	@emacs --batch --eval '(progn (require (quote package)) (setq package-archives (quote (("melpa" . "https://melpa.org/packages/") ("gnu" . "https://elpa.gnu.org/packages/")))) (package-initialize) (package-refresh-contents))' 2>&1
	@echo "Installing packages..."
	@emacs --batch -l init.el 2>&1
	@echo "Done. All packages installed."

# Verify mode activation and indentation for all configured languages
test:
	@sh tests/test-modes.sh
