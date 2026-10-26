;;; -*- lexical-binding: t -*-
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "S-<f6>") 'eglot-rename)

  (define-key eglot-mode-map (kbd "M->") 'eglot-find-implementation)
  (define-key eglot-mode-map (kbd "M-<") 'xref-find-references)

  (define-key eglot-mode-map (kbd "C-c a") 'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c f") 'eglot-format-buffer))
