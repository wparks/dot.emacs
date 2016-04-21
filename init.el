(custom-set-variables
 '(delete-selection-mode t)
 '(line-number-mode t)
 '(column-number-mode t)
 '(show-paren-mode t)
 '(indicate-empty-lines t)
 '(size-indication-mode t)
)

;; Setup backup files into a separate directory
(setq
 backup-by-copying t
 backup-directory-alist '(("." . "~/.emacs-backup"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

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
