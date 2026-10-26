;;; -*- lexical-binding: t -*-
(use-package magit-delta
   :ensure t)

(use-package magit
  :ensure t
  :hook (magit-mode . magit-delta-mode))
