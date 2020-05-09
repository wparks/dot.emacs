;; Early init

;; Save out GC values
(defvar aorst--gc-cons-threshold gc-cons-threshold)
(defvar aorst--gc-cons-percentage gc-cons-percentage)
(defvar aorst--file-name-handler-alist file-name-handler-alist)

;; Setup GC for faster init
(setq-default gc-cons-threshold 402653184
              gc-cons-percentage 0.6
              inhibit-compacting-font-caches t
              message-log-max 16384
              file-name-handler-alist nil)

;; Hooks to restore GC values
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold aorst--gc-cons-threshold
                  gc-cons-percentage aorst--gc-cons-percentage
                  file-name-handler-alist aorst--file-name-handler-alist)))

;; Hide UI while booting
(setq default-frame-alist '(
                            ;;(width . 190)
                            ;;(height . 68)
                            (height . 60)
                            (tool-bar-lines . 0)
                            ;;(menu-bar-lines . 0)
                            (vertical-scroll-bars)))

;; Disable package on startup
(defvar package--init-file-ensured)
(setq package-enable-at-startup nil
      package--init-file-ensured t)

(setq frame-inhibit-implied-resize t)

(provide 'early-init)
;; End Early init
