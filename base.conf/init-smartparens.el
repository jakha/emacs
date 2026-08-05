(use-package smartparens
  :ensure smartparens
  :commands (smartparens turn-on-smartparens-strict-mode)
  :bind (("C-d" . sp-delete-char)
         ("C-M-f" . sp-forward-sexp)
         ("C-M-b" . sp-backward-sexp)
         ("C-M-k" . sp-kill-sexp)
         ("C-M-e" . sp-up-sexp)
         ("C-M-n" . sp-next-sexp)
         ("C-M-p" . sp-previous-sexp)
         ("C-M-s" . sp-unwrap-sexp)
         ("C-M-t" . sp-transpose-sexp)
         ("C-M-<backspace>" . sp-backward-unwrap-sexp)
         ("C-M-w" . sp-copy-sexp)
         ("C-M-<left>" . sp-backward-slurp-sexp)
         ("C-M-<right>" . sp-backward-barf-sexp)
         ("M-F" . sp-forward-symbol)
         ("M-B" . sp-backward-symbol)))

(smartparens-global-mode 1)

(add-hook 'show-paren-mode-hook (lambda ()
				  (set-face-attribute 'show-paren-match nil :background nil :foreground "green")))
(show-paren-mode)


(provide 'init-smartparens)
;;; init-smartparens.el ends here


