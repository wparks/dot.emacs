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
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))
(setq
 backup-by-copying t ;; Don't delink hardlinks
 delete-old-versions t ;; Clean up the backups
 version-control t ;; Use version numbers on backups,
 kept-new-versions 5 ;; keep some new versions
 kept-old-versions 2 ;; and some old ones, too
 )

;; Basic
(setq
 column-number-mode t
 line-number-mode t
 visible-bell t ;; No noise pls
 create-lockfiles nil ;; Get rid of creating .#* files in same directory
 )
(setq-default
 indent-tab-mode nil
 tab-width 4
 )
(desktop-save-mode 1)
(global-hl-line-mode t)

;; Theme
(use-package spacemacs-theme
  :ensure t
  :no-require t
  :config
  (load-theme 'spacemacs-dark t)
  )
;(use-package monokai-theme
;  :defer t
;  :config
;  (load-theme 'monokai t)
;  )
;(use-package omtose-phellack-theme
;  :defer t
;  :config
;  (load-theme 'omtose-darker t)
;  )

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

;; TODO: Indentation
;(use-package highlight-indent-guides
;  :defer t
;  :hook (prog-mode . highlight-indent-guides)
;  :custom
;  (highlight-indent-guides-method 'bitmap)
;  )

;; TODO: IDO
;(use-package ido-completing-read+
;  :ensure t
;  :config
;  ;; This enables ido in all contexts where it could be useful, not just
;  ;; for selecting buffer and file names
;  (ido-mode t)
;  (ido-everywhere t)
;  ;; This allows partial matches, e.g. "uzh" will match "Ustad Zakir Hussain"
;  (setq ido-enable-flex-matching t)
;  (setq ido-use-filename-at-point nil)
;  ;; Includes buffer names of recently opened files, even if they're not open now.
;  (setq ido-use-virtual-buffers t)
;  :diminish nil
;)

;; TODO: Company mode
;(use-package company
;  ;; Navigate in completion minibuffer with `C-n` and `C-p`.
;  :bind (:map company-active-map
;         ("C-n" . company-select-next)
;         ("C-p" . company-select-previous))
;  :config
;  (setq company-idle-delay 0.3) ;; Provide instant autocompletion.
;  (global-company-mode t) ;; Use company mode everywhere.
;  )

;; TODO: Org mode
;(use-package org
;  )

;; TODO: Magit
;(use-package magit
;  :ensure t
;  :bind ("C-x g" . magit-status)
;  )

;; Programming modes
(use-package prog-mode
  :defer t
  :hook (prog-mode . show-paren-mode)
  )

;; LSP
(use-package lsp-mode
  :defer t
  :commands lsp
  ;:hook (prog-mode . lsp)
  :custom
  (lsp-prefer-flymake nil)
  (lsp-enable-snippet nil) ;; enable when we use yasnippet
  )

;; Flycheck
(use-package flycheck
  :ensure t
  ;:hook (prog-mode . flycheck-mode)
  )

;; Emacs Lisp mode
(use-package elisp-mode
  :defer t
  :mode ("\\.el\\'" . 'emacs-lisp-mode)
  :config
  (setq indent-tabs-mode nil)
  :hook (emacs-lisp-mode . eldoc-mode)
  )

;; Rust mode (Rustic)
(use-package rustic
  :ensure t
  :requires (flycheck lsp-mode)
  :commands (cargo-minor-mode)
  :mode ("\\.rs" . rustic-mode)
  :hook
  (rustic-mode . flycheck-mode)
  :config
  ;(setq lsp-rust-analyzer-server-command '("~/.cargo/bin/rust-analyzer"))
  :custom
  (rustic-lsp-server 'rust-analyzer)
  )

;; TODO: C/C++ mode
;; TODO: Python mode
;; TODO: Json mode
;; TODO: Yaml mode
;; TODO: Golang mode
;; TODO: Markdown mode

(provide 'init)
;;; init.el ends here
