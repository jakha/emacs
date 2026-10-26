;;; -*- lexical-binding: t -*-
(use-package sublimity
  :ensure t)


(sublimity-mode 1)
(require 'sublimity-scroll)
(setq sublimity-scroll-weight 10
      sublimity-scroll-drift-length 5)

(setq scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000)
