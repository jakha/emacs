;;; init-go-ide.el --- Go IDE: go-ts-mode + eglot + gopls  -*- lexical-binding: t -*-
;;; Commentary:
;; Install / update dependencies with `make go-ide' from the repo root.
;;; Code:

(require 'init-eglot (concat user-emacs-directory "languages/ide/init-eglot.el"))

(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("/go\\.mod\\'" . go-mod-ts-mode))
(add-to-list 'auto-mode-alist '("/go\\.work\\'" . go-work-ts-mode))

;; one tab per level with the global tab-width of 4
(setq go-ts-indent-offset 4)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((go-ts-mode go-mod-ts-mode go-work-ts-mode) . ("gopls")))
  (setq-default eglot-workspace-configuration
                (plist-put (default-value 'eglot-workspace-configuration)
                           :gopls '(:staticcheck t :gofumpt :json-false))))

(defun go-ide-organize-imports ()
  "Apply gopls organize imports, if it has anything to do."
  (ignore-errors
    (eglot-code-actions nil nil "source.organizeImports" t)))

(dolist (hook '(go-ts-mode-hook go-mod-ts-mode-hook go-work-ts-mode-hook))
  (add-hook hook (lambda () (ide-eglot-setup "gopls"))))
(ide-format-on-save '(go-ts-mode) #'go-ide-organize-imports)

(provide 'init-go-ide)
;;; init-go-ide.el ends here
