;; Setup backup files into a separate directory
(setq inhibit-splash-screen t)
(tooltip-mode -1)
(when window-system
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
)

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

(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs-backup"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
 )

;; Package setup
(defvar package-archives)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
       ))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
)
(eval-when-compile
  (require 'use-package)
  (setq use-package-always-ensure t)
)

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
  (if (>= emacs-major-version 23)
      (add-hook 'after-change-major-mode-hook 'whitespace-mode)
    (add-hook 'after-change-major-mode-hook 'whitespace-global-mode)
    )
  )

;;(defvar mybgcolor "#181a26") ;; deeper-blue theme background
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


(use-package display-line-numbers
  :ensure nil
  :config
  (setq display-line-numbers-grow-only t
        display-line-numbers-width-start t))

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
