(require 'whitespace)

(custom-set-variables
 '(delete-selection-mode t)
 '(line-number-mode t)
 '(column-number-mode t)
 '(show-paren-mode t)
 '(indicate-empty-lines t)
 '(size-indication-mode t)
 )

;; Tabs and spaces
(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;; Whitespace
;; Make whitespace-mode use just basic coloring
(setq whitespace-style (quote (spaces tabs newline space-mark tab-mark newline-mark)))
(setq whitespace-display-mappings
      ;; all numbers are Unicode codepoint in decimal. try (insert-char 182) to see it
      '(
        (space-mark 32 [183] [46]) ;; 32 SPACE, 183 MIDDLE DOT, 46 FULL STOP
        (newline-mark 10 [182 10]) ;; 10 LINE FEED
        ;;(tab-mark 9 [9655 9] [92 9]) ;; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE
        (tab-mark 9 [8677 9] [92 9]) ;; 9 TAB, 8677 RIGHTWARDS ARROW TO BAR
        )
      )

;; Setup backup files into a separate directory
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs-backup"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t
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
