;;; -*- lexical-binding: t -*-
(use-package vterm
  :ensure t)

(use-package multi-vterm
  :ensure t)

(defun make-terminal ()
  "."
  (multi-vterm-project))

(defun ide-make-terminal ()
  "."
  (interactive)
  (setf default-directory (projectile-project-root))
  (make-terminal))

(define-key projectile-mode-map (kbd "M-<f12>") 'ide-make-terminal)
(define-key vterm-mode-map (kbd "M-<right>") 'other-window)
(define-key vterm-mode-map (kbd "M-<left>") 'back-window)
(define-key vterm-mode-map (kbd "M-<left>") 'back-window)
(define-key vterm-mode-map  (kbd "M-b") 'ido-switch-buffer)
(define-key  vterm-mode-map  (kbd "M-e") 'vterm-yank)

(setq vterm-tramp-shells '(("ssh" "/bin/bash")
                             ("scp" "/bin/bash")
                             ("rsync" "/bin/bash")))
