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
  (add-to-list 'default-frame-alist '(width . 120))
  (add-to-list 'default-frame-alist '(height . 50))
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
(global-hl-line-mode t)

;; Theme
;; modus-vivendi: built-in dark theme (Emacs 28+)
(load-theme 'modus-vivendi t)
;; Alternative: spacemacs-dark (uncomment to switch)
;(use-package spacemacs-theme
;  :ensure t
;  :defer t
;  :init
;  (load-theme 'spacemacs-dark t)
;  )
;; Line numbers
(use-package display-line-numbers
  :hook (prog-mode . display-line-numbers-mode)
  :custom
  (display-line-numbers-grow-only t)
  (display-line-numbers-width-start t)
  )

;; Whitespace
(use-package whitespace
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

;; Completion
(use-package vertico
  :ensure t
  :bind (:map vertico-map
         ("TAB" . minibuffer-complete))
  :init
  (vertico-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.3)
  (corfu-auto-prefix 2)
  :init
  (global-corfu-mode))

(savehist-mode 1)

;; Programming modes
(use-package prog-mode
  :hook (prog-mode . show-paren-mode)
  )

;; Tree-sitter support (Emacs 29+)
(defvar my/treesit-p
  (and (fboundp 'treesit-available-p) (treesit-available-p))
  "Non-nil if tree-sitter is compiled into this Emacs.")

(defun my/treesit-available-p (lang)
  "Check if tree-sitter is usable for LANG."
  (and my/treesit-p
       (treesit-language-available-p lang)))

(when my/treesit-p
  ;; Grammar sources pinned to ABI 14 compatible versions (Emacs 30.x).
  ;; JSON works at latest. Others need pre-0.25 tree-sitter tags.
  (setq treesit-language-source-alist
        '((c "https://github.com/tree-sitter/tree-sitter-c" "v0.23.5")
          (cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4")
          (python "https://github.com/tree-sitter/tree-sitter-python" "v0.23.6")
          (go "https://github.com/tree-sitter/tree-sitter-go" "v0.23.4")
          (gomod "https://github.com/camdencheek/tree-sitter-go-mod" "v1.1.0")
          (json "https://github.com/tree-sitter/tree-sitter-json")
          (yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "v0.6.1")))

  (defun my/install-treesit-grammars ()
    "Install all tree-sitter grammars from treesit-language-source-alist."
    (interactive)
    (dolist (grammar treesit-language-source-alist)
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar))))))

;; Emacs Lisp mode
(use-package elisp-mode
  :hook (emacs-lisp-mode . eldoc-mode)
  )

;; C/C++
(if (my/treesit-available-p 'c)
    (progn
      (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
      (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
      (use-package c-ts-mode
        :defer t
        :config
        (setq c-ts-mode-indent-offset 4)))
  (use-package cc-mode
    :defer t
    :config
    (setq c-basic-offset 4)))

;; Python
(if (my/treesit-available-p 'python)
    (use-package python
      :defer t
      :mode ("\\.py\\'" . python-ts-mode)
      :config
      (setq python-indent-offset 4)
      :hook (python-ts-mode . (lambda () (setq tab-width 4))))
  (use-package python
    :defer t
    :mode ("\\.py\\'" . python-mode)
    :config
    (setq python-indent-offset 4)
    :hook (python-mode . (lambda () (setq tab-width 4)))))

;; Go — uses real tabs per community convention
(if (my/treesit-available-p 'go)
    (use-package go-ts-mode
      :defer t
      :mode "\\.go\\'"
      :hook (go-ts-mode . (lambda () (setq indent-tabs-mode t)))
      :config
      (setq go-ts-mode-indent-offset 4))
  (use-package go-mode
    :ensure t
    :defer t
    :mode "\\.go\\'"
    :hook (go-mode . (lambda () (setq indent-tabs-mode t)))))

;; JSON
(if (my/treesit-available-p 'json)
    (use-package json-ts-mode
      :defer t
      :mode "\\.json\\'"
      :config
      (setq json-ts-mode-indent-offset 4))
  (use-package js
    :defer t
    :mode ("\\.json\\'" . js-json-mode)
    :config
    (setq js-indent-level 4)))

;; YAML
(if (my/treesit-available-p 'yaml)
    (use-package yaml-ts-mode
      :defer t
      :mode ("\\.ya?ml\\'"))
  (use-package yaml-mode
    :ensure t
    :defer t
    :mode ("\\.ya?ml\\'")))

;; Swift
(use-package swift-mode
  :ensure t
  :defer t
  :mode "\\.swift\\'"
  :config
  (setq swift-mode:basic-offset 4))

;; Zig
(use-package zig-mode
  :ensure t
  :defer t
  :mode "\\.zig\\'"
  :config
  (setq zig-indent-offset 4))

;; Markdown
(use-package markdown-mode
  :ensure t
  :defer t
  :mode ("\\.md\\'" "\\.markdown\\'"))

(provide 'init)
;;; init.el ends here
