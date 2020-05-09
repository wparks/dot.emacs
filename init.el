;; Package setup
(defvar package-archives)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package)
  (setq use-package-always-ensure t)
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(delete-selection-mode t)
 '(indicate-empty-lines t)
 '(line-number-mode t)
 '(package-selected-packages (quote (lsp-mode rustic rust-mode use-package)))
 '(show-paren-mode t)
 '(size-indication-mode t))

(setq initial-major-mode 'fundamental-mode
      initial-scratch-message "")

;; Tabs and spaces
;;(setq-default indent-tabs-mode nil)
;;(setq tab-width 4)
;;(defvaralias 'c-basic-offset 'tab-width)
;;(defvaralias 'cperl-indent-level 'tab-width)

;; Whitespace
;; lines lines-tail newline trailing space-before-tab space-afte-tab empty
;; indentation-space indentation indentation-tab tabs spaces
(use-package whitespace
  :config
  (setq whitespace-style
        '(
          face
          trailing
          spaces
          tabs
          empty
          newline
          space-mark
          tab-mark
          newline-mark
          ))
  (setq whitespace-display-mappings
        ;; all numbers are Unicode codepoint in decimal. try (insert-char 182) to see it
        '(
          (space-mark 32 [183] [46]) ;; 32 SPACE, 183 MIDDLE DOT, 46 FULL STOP
          (newline-mark 10 [182 10]) ;; 10 LINE FEED
          ;;(tab-mark 9 [9655 9] [92 9]) ;; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE
          (tab-mark 9 [8677 9] [92 9]) ;; 9 TAB, 8677 RIGHTWARDS ARROW TO BAR
          ))
  )
(if (>= emacs-major-version 23)
    (add-hook 'after-change-major-mode-hook 'whitespace-mode)
  (add-hook 'after-change-major-mode-hook 'whitespace-global-mode)
  )

(defvar mybgcolor "#181a26") ;; deeper-blue theme background
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-empty ((t (:background "#181a26"))))
 '(whitespace-indentation ((t (:foreground "firebrick" :background "beige"))))
 '(whitespace-newline ((t (:bold t :foreground "#181a26" :background "#181a26"))))
 '(whitespace-space ((t (:bold t :foreground "#181a26" :background "#181a26"))))
 '(whitespace-tab ((t (:underline t :foreground "LightSkyBlue"))))
 '(whitespace-trailing ((t (:underline t :foreground "DeepPink")))))

(use-package flycheck
  :defer
  )

(use-package lsp-mode
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil)
  )

;; Programming Language support

;; TODO: look at clang format vs google style (https://github.com/motine/cppstylelineup) (https://github.com/isocpp/CppCoreGuidelines)
(use-package cc-mode
;;  :bind (:map c-mode-base-map
;;              ("C-c c" . compile))
  :config
  (use-package google-c-style
    :ensure t
    :init
    :hook (c-mode-common . (lambda ()
                (google-set-c-style)
                (google-make-newline-indent)))
;;    :config
;;    (c-set-offset 'statement-case-open 0)
    )
  )

;;(use-package clang-format
;;  :after cc-mode
;;  :bind (:map c-mode-base-map
;;              ("C-c C-f" . clang-format-buffer)
;;              ("C-c C-S-f" . clang-format-region)))

;; TODO: add Racer, RLS, rust-analyzer
(when (>= emacs-major-version 26)
  (use-package rustic
    :init
    (setq rustic-lsp-server 'rust-analyzer)
    (setq rustic-flycheck-setup-mode-line-p nil)
    (setq auto-mode-alist (delete '("\\.rs\\'" . rust-mode) auto-mode-alist))
    :hook ((rustic-mode . (lambda ()
                            (lsp-ui-doc-mode)
                            (lsp-ui-sideline-mode)
                            (lsp-ui-sideline-toggle-symbols-info)
                            (smart-dash-mode)
                            (company-mode)))
           )
    :config
    (setq rust-indent-method-chain t)
    (setq rustic-format-on-save t)
    )
  )

(when (< emacs-major-version 26)
  (use-package racer
    :defer)
  (use-package rust-mode
    :mode "\\.rs\\'"
    :config
    (when (executable-find "cargo")
      (use-package cargo
        :diminish cargo-minor-mode
        :hook ((rust-mode toml-mode) . cargo-minor-mode)
        )
    )
    :init
    (setq rust-format-on-save t)
    :hook ((rust-mode . company-mode)
           (rust-mode . cargo-minor-mode)
           (rust-mode . racer-mode)
           (rust-mode . eldoc-mode))
    )
  )

(use-package csharp-mode
  :defer
  :mode "\\.cs\\'"
  )

(use-package python
  :defer
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  )

(use-package racket-mode
  :defer
  :mode "\\.rkt\\'"
  )

(use-package toml-mode
  :mode "\\.toml\\'"
  )

(use-package json-mode
  :mode "\\.json\\'"
  )

(use-package yaml-mode
  :mode "\\.ya?ml\\'"
  )

(use-package markdown-mode
;;  :hook ((markdown-mode . auto-fill-mode))
  :mode "\\.md\\'"
  )

(use-package editorconfig
  :commands editorconfig-mode
  :config (editorconfig-mode 1))

;; TODO: Flymake vs Flycheck? (https://www.flycheck.org/en/latest/user/flycheck-versus-flymake.html)

;; TODO: Add Company for completion

;; TODO: Double check undo features
;;(use-package undo-tree
;;  :commands global-undo-tree-mode
;;  :init (global-undo-tree-mode 1))

;; TODO: Look into Magit for git integration

;; TODO: Look into Ediff for file diffing

;; TODO: Look into multiple-cursors or Kakoune for multi selection?

;; TODO: Eglot for LSP client? Although there is an issue with project finding root of project file??

;; Setup backup files into a separate directory
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs-backup"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
 )

(setq inhibit-splash-screen t)

(tooltip-mode -1)
; (menu-bar-mode -1)
;;(fset 'menu-bar-open nil)

(when window-system
  (scroll-bar-mode -1)
  (tool-bar-mode -1))

;; TODO: Find a good modeline, like Moody (https://github.com/tarsius/moody)

(when window-system
  (use-package frame
    :ensure nil
    :config
    (setq window-divider-default-right-width 1)
    (window-divider-mode 1)
    (set-face-attribute
     'window-divider nil
     :foreground (face-attribute
                  'mode-line-inactive :background))))

;; Put filename in title
;;(setq-default frame-title-format '("%b — Emacs"))

;; TODO: look into treemacs for file explorer

;; TODO: With Emacs 27, look at tab support

(use-package display-line-numbers
  :ensure nil
  :config
  (setq display-line-numbers-grow-only t
        display-line-numbers-width-start t))

;; TODO: Look into Org Mode for various things

;; Dealing with difference of terminal vs GUI display
(if (display-graphic-p)
    ;; When in graphic display
    (progn
      (tool-bar-mode -1)
      ;; set size parameters of default frame
      (add-to-list 'default-frame-alist '(left . 80))
      (add-to-list 'default-frame-alist '(top . 2))
      (add-to-list 'default-frame-alist '(height . 60))
      ;;(add-to-list 'default-frame-alist '(width . 80))
      ;; Sets fringe to l and r pixel large for each side
      ;;(set-fringe-mode '(1 . 1))
      (set-fringe-mode '(1 . 2))
      )
  ;; When in terminal
  )

;; TODO: Look into server startup, need a .desktop file?
;;(use-package server
;;  :ensure nil
;;  :config
;;  (unless (server-running-p)
;;    (server-start)))

;; Load default theme
(if (>= emacs-major-version 23)
    (add-hook 'after-init-hook
              (lambda()
                ;;(load-theme 'dark-mint)
                ;;(load-theme 'kooten t)
                ;;(load-theme 'zenbun t)
                ;;(load-theme 'solarized-dark)
                ;;(load-theme 'monokai t)
                ;;(load-theme 'cyberpunk t)
                ;;(load-theme 'ample t)
                (load-theme 'deeper-blue)
                ;;(load-theme 'tango-dark)
                )
              )
  )

(provide 'init)
;;; init.el ends here
