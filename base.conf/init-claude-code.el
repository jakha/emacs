;; install required inheritenv dependency:
(require 'vc-git)
(add-to-list 'vc-handled-backends 'Git)
(use-package inheritenv
  :vc (:url "https://github.com/purcell/inheritenv" :rev :newest))

;; for eat terminal backend:
;; (use-package eat :ensure t)

;; for ghostel terminal backend (libghostty):
;; (use-package ghostel
;;   :vc (
;; 	   :url "https://github.com/dakra/ghostel"
;; 			:rev
;; 			:newest))
(use-package monet
  :vc (:url "https://github.com/stevemolitor/monet" :rev :newest))

(use-package claude-code :ensure t
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :config
  ;; optional IDE integration with Monet
  (add-hook 'claude-code-process-environment-functions #'monet-start-server-function)
  (monet-mode 1)

  (claude-code-mode)
  :bind-keymap ("C-c s" . claude-code-command-map)

  ;; Optionally define a repeat map so that "M" will cycle thru Claude auto-accept/plan/confirm modes after invoking claude-code-cycle-mode / C-c M.
  :bind
  (:repeat-map my-claude-code-map ("M" . claude-code-cycle-mode)))

(setq claude-code-terminal-backend 'vterm)


;; use-package 2.4.4 (site-lisp clone) has no :vc keyword, so install by hand.
;; vc-handled-backends is nil (see base.conf/init.el), and vc-clone refuses any
;; backend missing from it, so put Git back for the duration of the checkout.
;; (unless (package-installed-p 'claude-code-ide)
;;   (require 'vc-git)
;;   (let ((vc-handled-backends '(Git)))
;;     (package-vc-install "https://github.com/manzaltu/claude-code-ide.el")))

;; (use-package claude-code-ide
;;   :bind ("C-c C-s" . claude-code-ide-menu) ; Set your favorite keybinding
;;   :config
;;   (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools
