;;; -*- lexical-binding: t -*-
(with-eval-after-load 'markdown-ts-mode
  (define-key markdown-ts-mode-map (kbd "C-c v") 'markdown-ide-preview)
  (define-key markdown-ts-mode-map (kbd "C-c V") 'markdown-ide-preview-browser))
