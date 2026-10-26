;;; php-ide-lock.el --- pinned packages for the PHP IDE  -*- lexical-binding: t -*-
;;; Commentary:
;; Installed by `make php-elisp' (languages/php/install.el) with package-vc.
;; Tree-sitter grammars are not listed here: Emacs 31.1 pins their commits
;; in `php-ts-mode--language-source-alist' and mhtml-ts-mode, and the Emacs
;; version itself is pinned in versions.env.
;;; Code:

(defconst php-ide-packages
  '((corfu :url "https://github.com/minad/corfu"
           :rev "b468efac023dda39332acc943edc9895c80b5a6f")) ; 2.16
  "Packages as (NAME :url URL :rev COMMIT).")

(defconst php-ide-grammars '(php phpdoc html css javascript jsdoc)
  "Tree-sitter grammars needed by `php-ts-mode'.")

(provide 'php-ide-lock)
;;; php-ide-lock.el ends here
