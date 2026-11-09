;;; -*- lexical-binding: t -*-
;; Сочетания с модификаторами (C-, M-, s-) работают одинаково
;; в любой раскладке: C-н == C-y, M-ч == M-x, C-x C-ы == C-x C-s.
;; Обычный ввод текста не затрагивается.
(use-package reverse-im
  :ensure t
  :demand t
  :custom
  (reverse-im-input-methods '("russian-computer")) ; ЙЦУКЕН
  (reverse-im-char-fold t)                         ; поиск игнорирует раскладку
  (reverse-im-read-char-advice-function #'reverse-im-read-char-include)
  (reverse-im-read-char-include-commands
   '(avy-goto-char avy-goto-char-2 avy-goto-word-1 ace-window))
  :config
  (reverse-im-mode 1))
