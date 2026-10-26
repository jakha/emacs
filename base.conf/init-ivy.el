;;; -*- lexical-binding: t -*-
(use-package ivy
  :ensure t)

(ivy-mode 1)

(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)

(use-package ivy-file-preview
  :ensure t)

(ivy-file-preview-mode)
