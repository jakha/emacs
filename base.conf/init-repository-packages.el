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

;; use-package 2.4.4 (site-lisp clone) has no :vc keyword, so install by hand.
;; vc-handled-backends is nil (see base.conf/init.el), and vc-clone refuses any
;; backend missing from it, so put Git back for the duration of the checkout.
(unless (package-installed-p 'claude-code-ide)
  (require 'vc-git)
  (let ((vc-handled-backends '(Git)))
    (package-vc-install "https://github.com/manzaltu/claude-code-ide.el")))

(use-package claude-code-ide
  :bind ("C-c C-s'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools
