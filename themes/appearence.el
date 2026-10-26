;;; -*- lexical-binding: t -*-
;; remove menu from head
(menu-bar-mode -1)
;; remove toolbar from head
(tool-bar-mode -1)
;; remove scroll bar
(scroll-bar-mode -1)
;; to actualize buffer if file change on buffer

;; change cursor type to | 
(setq-default cursor-type 'bar)

;;off sound bell
(setq ring-bell-function
      (lambda ()
        (let ((orig-fg (face-foreground 'mode-line)))
          (set-face-foreground 'mode-line "#F2804F")
          (run-with-idle-timer 0.1 nil
                               (lambda (fg) (set-face-foreground 'mode-line fg))
                               orig-fg))))
(setq visible-bell 1)
