;;; -*- lexical-binding: t -*-
(use-package projectile
  :ensure t)

(setq projectile-completion-system 'ivy)
(setq projectile-enable-caching t)
(setq projectile-indexing-method 'alien)
(setq projectile-file-exists-local-cache-expire (* 5 60))

(define-key global-map (kbd "M-f") 'projectile-find-file)
(define-key global-map (kbd "M-d") 'projectile-find-dir)
(define-key global-map (kbd "M-p") 'projectile-switch-project)
(defcustom projectile-mode-line-prefix
  "<P>"
  "Mode line lighter prefix for Projectile.
It's used by `projectile-default-mode-line'
when using dynamic mode line lighter and is the only
thing shown in the mode line otherwise."
  :group 'projectile
  :type 'string
  :package-version '(projectile . "0.12.0"))
(defvar-local projectile--mode-line projectile-mode-line-prefix)
(projectile-mode +1)


(setq projectile-git-submodule-command nil)
