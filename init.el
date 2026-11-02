;;; -*- lexical-binding: t -*-
;;; package --- emacs
;;; Commentary:
;;; Code:

(require 'package)

;; Custom / package.el write their state here, not into this tracked file
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file t)

;; third-party packages' native-comp warnings go to *Native-compile-Log* only
(setq native-comp-async-report-warnings-errors 'silent)

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

(put 'scroll-left 'disabled nil)
