(global-auto-revert-mode t)
;; to save 
(auto-save-visited-mode)

(desktop-save-mode 1)

(delete-selection-mode t)  ; delete seleted text when typing

(setq-default tab-width 4)

;; to not show line toggle sign 
(setf (cdr (assq 'continuation fringe-indicator-alist))
      '(nil nil) ;; no continuation indicators
      ;; '(nil right-curly-arrow) ;; right indicator only
      ;; '(left-curly-arrow nil) ;; left indicator only
      ;; '(left-curly-arrow right-curly-arrow) ;; default
      )


(add-hook 'post-command-hook
          (lambda ()
            (let ((messages (get-buffer "*Messages*")))
              (unless (eq (current-buffer) messages)
                (with-current-buffer messages
                  (goto-char (point-max)))))))

(setq read-process-output-max (* 1024 1024))

(unless (not package-archive-contents)
  (load "~/.emacs.d/base.conf/init-repository-packages.el"))


;; (setq backup-directory-alist `(("." . "~/.saves")))

;;(use-package dash-functional)

