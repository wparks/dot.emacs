;;; test.el — Verify: emacs-lisp-mode, eldoc, 4-space indent, no tabs
(require 'cl-lib)

(defvar my/test-value 42
  "A test variable.")

(defun my/greet (name &optional prefix)
  "Greet NAME with optional PREFIX."
  (let ((pre (or prefix "Hello")))
    (message "%s, %s! Value is %d"
             pre name my/test-value)))

(cl-defstruct point
  (x 0.0)
  (y 0.0))

(defun my/distance (a b)
  "Calculate distance between points A and B."
  (let ((dx (- (point-x a) (point-x b)))
        (dy (- (point-y a) (point-y b))))
    (sqrt (+ (* dx dx) (* dy dy)))))

(provide 'test)
;;; test.el ends here
