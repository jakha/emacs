;;; init-php.el --- PHP IDE: php-ts-mode + eglot + phpantom_lsp  -*- lexical-binding: t -*-
;;; Commentary:
;; Install / update dependencies with `make php-ide' from the repo root.
;;; Code:

(require 'init-eglot (concat user-emacs-directory "languages/ide/init-eglot.el"))

(add-to-list 'auto-mode-alist '("\\.php\\'" . php-ts-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((php-ts-mode php-mode) . ("phpantom_lsp"))))

(add-hook 'php-ts-mode-hook (lambda () (ide-eglot-setup "phpantom_lsp")))
(ide-format-on-save '(php-ts-mode))

(load (concat user-emacs-directory "kbd/php.el"))

(provide 'init-php)
;;; init-php.el ends here
