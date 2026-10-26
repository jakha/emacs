;;; -*- lexical-binding: t -*-
(with-eval-after-load 'php-ts-mode
  (define-key php-ts-mode-map (kbd "M-.") (lambda () (interactive) (insert "->")))
  (define-key php-ts-mode-map (kbd "M-]") 'xref-find-definitions)
  (define-key php-ts-mode-map (kbd "M-[") 'xref-go-back))
