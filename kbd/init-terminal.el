(use-package multi-vterm
  :ensure t)
(use-package vterm
  :ensure t)

(require 'multi-vterm)

(define-key projectile-mode-map (kbd "M-<f12>") 'ide-make-terminal)



(define-key vterm-mode-map (kbd "M-<right>") 'other-window)
(define-key vterm-mode-map (kbd "M-<left>") 'back-window)
(define-key vterm-mode-map (kbd "M-<left>") 'back-window)
(define-key vterm-mode-map  (kbd "M-b") 'ido-switch-buffer)
(define-key  vterm-mode-map  (kbd "M-e") 'vterm-yank)
