;;; init-yaml-ide.el --- YAML IDE: yaml-ts-mode + eglot + yaml-language-server  -*- lexical-binding: t -*-
;;; Commentary:
;; Install / update dependencies with `make yaml-ide' from the repo root.
;; Schemas are picked from SchemaStore by file name (GitHub workflows,
;; docker-compose, ...). A file can name its own schema with a first line
;;   # yaml-language-server: $schema=<url>
;; No format on save: it would reflow Helm templates; use `C-c f' by hand.
;;; Code:

(require 'init-eglot (concat user-emacs-directory "languages/ide/init-eglot.el"))

(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((yaml-ts-mode yaml-mode) . ("yaml-language-server" "--stdio")))
  (setq-default eglot-workspace-configuration
                (plist-put (default-value 'eglot-workspace-configuration)
                           :yaml '(:schemaStore (:enable t)
                                   :validate t
                                   :hover t
                                   :completion t
                                   :format (:enable t)))))

(add-hook 'yaml-ts-mode-hook (lambda () (ide-eglot-setup "yaml-language-server")))

(provide 'init-yaml-ide)
;;; init-yaml-ide.el ends here
