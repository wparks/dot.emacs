;;;; init.el -*- lexical-binding: t; -*-

;; Package setup
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives
      '(
        ("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        )
      )
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  )
(require 'use-package)

;; Customize system
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Window system
(when (display-graphic-p)
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)
  (tooltip-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  )

;; Editor backups and autosaves
(let ((backup-dir (expand-file-name "tmp/backups" user-emacs-directory))
      (auto-saves-dir (expand-file-name "tmp/auto-saves" user-emacs-directory)))
  (make-directory backup-dir t)
  (make-directory auto-saves-dir t)
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))
;; Basic settings and backups
(setq
 backup-by-copying t ;; Don't delink hardlinks
 delete-old-versions t ;; Clean up the backups
 version-control t ;; Use version numbers on backups,
 kept-new-versions 5 ;; keep some new versions
 kept-old-versions 2 ;; and some old ones, too
 column-number-mode t
 line-number-mode t
 visible-bell t ;; No noise pls
 create-lockfiles nil ;; Get rid of creating .#* files in same directory
 )
(setq-default
 indent-tabs-mode nil
 tab-width 4
 )
(desktop-save-mode 1)
(global-hl-line-mode t)

;; Theme
(use-package spacemacs-theme
  :ensure t
  :defer t
  :init
  (load-theme 'spacemacs-dark t)
  )
;; Line numbers
(use-package display-line-numbers
  :defer t
  :hook (prog-mode . display-line-numbers-mode)
  :custom
  (display-line-numbers-grow-only t)
  (display-line-numbers-width-start t)
  )

;; Whitespace
(use-package whitespace
  :defer t
  :hook
  (prog-mode . whitespace-mode)
  (text-mode . whitespace-mode)
  :custom
  (whitespace-style
   '(
     face
     trailing
     tabs
     spaces
     newline
     empty
     space-mark
     tab-mark
     newline-mark
     ))
  (whitespace-display-mappings
   ;; all numbers are Unicode codepoint in decimal. try (insert-char 182) to see it
   '(
     (space-mark 32 [183] [46]) ;; 32 SPACE, 183 MIDDLE DOT, 46 FULL STOP
     (newline-mark 10 [182 10]) ;; 10 LINE FEED
     (tab-mark 9 [8677 9] [92 9]) ;;9 TAB, 8677 RIGHTWARDS ARROW TO BAR
     ))
  )

;; Programming modes
(use-package prog-mode
  :defer t
  :hook (prog-mode . show-paren-mode)
  )

;; Tree-sitter support (Emacs 29+)
(defun my/treesit-available-p (lang)
  "Check if tree-sitter is usable for LANG."
  (and (fboundp 'treesit-available-p)
       (treesit-available-p)
       (treesit-language-available-p lang)))

(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  (setq treesit-language-source-alist
        '((c "https://github.com/tree-sitter/tree-sitter-c")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (python "https://github.com/tree-sitter/tree-sitter-python")
          (go "https://github.com/tree-sitter/tree-sitter-go")
          (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml")))

  (defun my/install-treesit-grammars ()
    "Install all tree-sitter grammars from treesit-language-source-alist."
    (interactive)
    (dolist (grammar treesit-language-source-alist)
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar))))))

;; Emacs Lisp mode
(use-package elisp-mode
  :defer t
  :mode ("\\.el\\'" . emacs-lisp-mode)
  :hook (emacs-lisp-mode . eldoc-mode)
  :config
  (setq indent-tabs-mode nil)
  )

;; TODO: Org mode
;; TODO: Magit

;; TODO: Language modes — C/C++, Python, Swift, Go, Zig, JSON, YAML, Markdown

(provide 'init)
;;; init.el ends here
