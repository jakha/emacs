;;; init-protobuf-ide.el --- Protobuf IDE: protobuf-mode + eglot + buf  -*- lexical-binding: t -*-
;;; Commentary:
;; Install / update the LSP server with `make protobuf-ide' from the repo root.
;; `buf lsp serve' gives go-to-definition (M-.), references (M-<), hover,
;; completion, lint diagnostics and formatting (C-c f, not on save).
;; Imports are resolved from the nearest buf.yaml / buf.work.yaml; without
;; one the file's directory is the module root.
;;; Code:

(require 'init-eglot (concat user-emacs-directory "languages/ide/init-eglot.el"))

(use-package protobuf-mode
  :ensure t
  :mode "\\.proto\\'"
  :hook (protobuf-mode . (lambda () (ide-eglot-setup "buf"))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(protobuf-mode . ("buf" "lsp" "serve"))))

(provide 'init-protobuf-ide)
;;; init-protobuf-ide.el ends here
