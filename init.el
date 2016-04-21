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
;; lines lines-tail newline trailing space-before-tab space-afte-tab empty
;; indentation-space indentation indentation-tab tabs spaces
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
(whitespace-mode t)
(defvar mybgcolor "#181a26") ;; deeper-blue theme background
(custom-set-faces
 '(whitespace-trailing ((t (:underline t :foreground "DeepPink"))))
 '(whitespace-tab ((t (:underline t :foreground "LightSkyBlue"))))
 '(whitespace-space ((t (:bold t :foreground "#181a26" :background "#181a26"))))
 '(whitespace-newline ((t (:bold t :foreground "#181a26" :background "#181a26"))))
 '(whitespace-empty ((t (:background "#181a26"))))
 '(whitespace-indentation ((t (:foreground "firebrick" :background "beige"))))
 )
;; (set-face-attribute 'whitespace-trailing nil
;;                     :background mybgcolor
;;                     :foreground "DeepPink"
;;                     :underline t
;;                     )
;; (set-face-attribute 'whitespace-tab nil
;;                     :background mybgcolor
;;                     :foreground "LightSkyBlue"
;;                     :underline t
;;                     )
;; (set-face-attribute 'whitespace-space nil
;;                     :background mybgcolor
;;                     :foreground mybgcolor ;;"GreenYellow"
;;                     :weight 'bold
;;                     )
;; (set-face-attribute 'whitespace-newline nil
;;                     :background mybgcolor
;;                     :foreground mybgcolor ;;"GreenYellow"
;;                     :weight 'bold
;;                     )
;; (set-face-attribute 'whitespace-empty nil
;;                     :background mybgcolor
;;                     )

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
