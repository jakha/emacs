;;; package --- emacs
;;; Commentary:
;;; Code:

(require 'package)

(load (concat user-emacs-directory "utils.el"))

(load (concat user-emacs-directory "kbd/init.el"))

;; add melpa package archive
(if (not (is-repo-added-to-package-archives "melpa"))
    (load (concat user-emacs-directory "add-melpa.el")))

;; install use package
(when (not (require 'use-package nil 'NOERROR))
  (load (concat user-emacs-directory "add-use-package.el")))

(load (concat user-emacs-directory "themes/appearence.el"))

;; load independent from packages configs
(load (concat user-emacs-directory "base.conf/init.el"))

;; (use-package origami
;;   :ensure t)

;; (origami-mode)

;; (put 'upcase-region 'disabled nil)
;; (put 'downcase-region 'disabled nil)

;; (put 'set-goal-column 'disabled nil)

;; auto generated code
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("9af2b1c0728d278281d87dc91ead7f5d9f2287b1ed66ec8941e97ab7a6ab73c0" "83447ed09cba2ec725225cb3789b38ba94bd4ec4e0253e8d85f278076bc5b6cf" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "87fa3605a6501f9b90d337ed4d832213155e3a2e36a512984f83e847102a42f4" default))
 '(package-selected-packages
   '(smartparens quelpa-use-package quelpa doom-modeline rg magit-delta magit sublimity projectile ivy-file-preview docker dashboard counsel all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
