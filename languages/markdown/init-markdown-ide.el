;;; init-markdown-ide.el --- Markdown IDE: markdown-ts-mode + eglot + marksman  -*- lexical-binding: t -*-
;;; Commentary:
;; Install / update dependencies with `make markdown-ide' from the repo root.
;; marksman gives links/headings completion, go to definition, references,
;; rename of headings and broken link diagnostics. It has no formatter.
;;; Code:

(require 'init-eglot (concat user-emacs-directory "languages/ide/init-eglot.el"))

;; markdown-ts-mode ships with Emacs 31.1 but is not autoloaded
(autoload 'markdown-ts-mode "markdown-ts-mode" "Major mode for Markdown." t)
(add-to-list 'auto-mode-alist '("\\.\\(md\\|markdown\\)\\'" . markdown-ts-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((markdown-ts-mode markdown-mode) . ("marksman" "server"))))

(add-hook 'markdown-ts-mode-hook (lambda () (ide-eglot-setup "marksman")))

(provide 'init-markdown-ide)
;;; init-markdown-ide.el ends here
