;;; -*- lexical-binding: t -*-

;; Построчный скролл: когда курсор выходит за край окна,
;; окно сдвигается ровно на одну строку, без перецентровки.
(setq scroll-step 1
      scroll-margin 1
      scroll-conservatively 101          ; > 100 => никогда не recenter
      scroll-preserve-screen-position t
      auto-window-vscroll nil            ; не "прыгать" на высоких строках
      redisplay-skip-fontification-on-input t
      fast-but-imprecise-scrolling t)

;; Горизонтальный скролл тоже по одному столбцу
(setq hscroll-step 1
      hscroll-margin 1)

;; Плавный (пиксельный) скролл колесом/тачпадом и C-v / M-v — встроенный в Emacs
(when (fboundp 'pixel-scroll-precision-mode)
  (setq pixel-scroll-precision-interpolate-page t
        pixel-scroll-precision-use-momentum t
        pixel-scroll-precision-large-scroll-height 40.0)
  (pixel-scroll-precision-mode 1)
  ;; C-v / M-v листают страницу плавно
  (global-set-key [remap scroll-up-command] #'pixel-scroll-interpolate-down)
  (global-set-key [remap scroll-down-command] #'pixel-scroll-interpolate-up))
