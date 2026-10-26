;;; ide-lock.el --- pinned packages for the language IDEs  -*- lexical-binding: t -*-
;;; Commentary:
;; Installed by `make ide-elisp' (languages/ide/install.el) with package-vc.
;; Tree-sitter grammars are listed by name only: Emacs 31.1 pins their commits
;; in php-ts-mode, mhtml-ts-mode and go-ts-mode, and the Emacs version itself
;; is pinned in versions.env.
;;; Code:

(defconst ide-packages
  '((corfu :url "https://github.com/minad/corfu"
           :rev "b468efac023dda39332acc943edc9895c80b5a6f")) ; 2.16
  "Packages as (NAME :url URL :rev COMMIT).")

(defconst ide-languages
  '((php :feature php-ts-mode
         :grammars (php phpdoc html css javascript jsdoc)
         :executables ("phpantom_lsp"))
    (go :feature go-ts-mode
        :grammars (go gomod gowork)
        :executables ("go" "gopls")))
  "Per-language tree-sitter grammars and external programs.
:feature is loaded first so its grammar recipes are registered.")

(provide 'ide-lock)
;;; ide-lock.el ends here
