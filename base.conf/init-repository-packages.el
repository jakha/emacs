(use-package quelpa
  :ensure t)

(use-package quelpa-use-package
  :ensure t
  :init (setq quelpa-update-melpa-p nil))

;; (load (concat user-emacs-directory "base.conf/init-company-mode.el"))

(load (concat user-emacs-directory "base.conf/init-smartparens.el"))

;; (load (concat user-emacs-directory "base.conf/init-flycheck.el")) 

(load (concat user-emacs-directory "base.conf/init-scroll-settings.el"))

(load (concat user-emacs-directory "base.conf/init-docker.el"))

(load (concat user-emacs-directory "base.conf/init-ivy.el"))

(load (concat user-emacs-directory "base.conf/init-swiper.el"))

(load (concat user-emacs-directory "base.conf/init-counsel.el"))

(load (concat user-emacs-directory "base.conf/init-dashboard.el"))

(load (concat user-emacs-directory "base.conf/init-icons.el"))

;; (load (concat user-emacs-directory "base.conf/init-diminish.el"))
(load (concat user-emacs-directory "base.conf/init-projectile.el"))

;; (load (concat user-emacs-directory "base.conf/init-ligatures.el"))
(load (concat user-emacs-directory "base.conf/init-magit.el"))

;;(load (concat user-emacs-directory "base.conf/init-polymodes.el"))

;; (load (concat user-emacs-directory "base.conf/init-lsp-mode.el"))

;; (load (concat user-emacs-directory "languages/init-languages.el"))

(load (concat user-emacs-directory "kbd/init-packages-kbd.el"))

;; (load (concat user-emacs-directory "base.conf/init-treemacs.el"))

;; (load (concat user-emacs-directory "base.conf/init-ripgrep.el"))

(load (concat user-emacs-directory "base.conf/init-terminal.el"))

(load (concat user-emacs-directory "base.conf/init-rg.el"))

(load (concat user-emacs-directory "themes/doom-mode-line.el"))

(load (concat user-emacs-directory "themes/after-use-package.el"))
