.PHONY: lint check clean grammars

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

# Install tree-sitter grammars (requires Emacs 29+ with tree-sitter).
# Run once after initial setup to enable tree-sitter modes.
grammars:
	@echo "Installing tree-sitter grammars..."
	@emacs --batch -l init.el --eval '(my/install-treesit-grammars)' 2>&1
	@echo "Done."
