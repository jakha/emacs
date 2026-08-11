;; buffer split and close
(define-key global-map (kbd "M-1") 'delete-other-windows)
(define-key global-map (kbd "M-2") 'split-window-right)
(define-key global-map (kbd "M-3") 'split-window-below)
(define-key global-map (kbd "M-0") 'delete-window)

;; save
(define-key global-map (kbd "M-s") 'save-buffer)

;; kill buffer
(define-key global-map (kbd "C-k") (lambda () (interactive) (kill-buffer (buffer-name))))
(define-key global-map (kbd "C-<right>") 'forward-word)
(define-key global-map (kbd "C-<left>") 'backward-word)

;; cut and paste to alt kbd
(define-key global-map (kbd "M-w") 'kill-ring-save)
(define-key global-map (kbd "M-e") 'kill-region)
(define-key global-map (kbd "M-q") '(lambda (&optional ARG)
				      (interactive)
				      (when (not (null (region-active-p)))
					(delete-region (region-beginning) (region-end)))
				      (yank)))
(define-key global-map (kbd "C-a") 'mark-whole-buffer)
(define-key global-map (kbd "C-z") 'undo)

;; switch buffer, file and project ido mode
(define-key global-map (kbd "M-b") 'ido-switch-buffer)

;; exceute elisp or any code in future
(define-key global-map (kbd "C-e") 'eval-last-sexp)

;; close comand line
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; rgrep
(define-key global-map (kbd "M-g r") 'rgrep)

(define-key global-map (kbd "C-S-r") 'replace-string)

;;utils
(global-set-key (kbd "C-n") #'xah-new-empty-buffer)
(global-set-key (kbd "C-S-n") #'lunaryorn-new-buffer-frame)
(global-set-key (kbd "<f5>") 'bs-show)

(global-set-key (kbd "<f3>") (lambda () (interactive) (revert-buffer t t)))

(global-set-key (kbd "C-d") 'duplicate-line)

(global-set-key (kbd "M-{") 'enlarge-window-horizontally)
(global-set-key (kbd "M-}") 'shrink-window-horizontally)
(global-set-key (kbd "M-^") 'enlarge-window)

;;(define-key global-map (kbd "C-c r") 'counsel-rg)

(define-key global-map (kbd "C->") 'mc/mark-next-like-this)

(progn (global-set-key (kbd "M-<right>") 'other-window)
	   (global-set-key (kbd "M-<left>") 'back-window)
)

(provide 'init)
;;; init.el ends here
