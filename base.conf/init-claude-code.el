;; install required inheritenv dependency:
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
(require 'vc-git)
(add-to-list 'vc-handled-backends 'Git)
;; install claude-code.el
(use-package monet
  :vc (:url "https://github.com/stevemolitor/monet" :rev :newest))

(use-package claude-code :ensure t
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :config
  ;; optional IDE integration with Monet
  (add-hook 'claude-code-process-environment-functions #'monet-start-server-function)
  (monet-mode 1)

  (claude-code-mode)
  :bind-keymap ("C-c C" . claude-code-command-map)

  ;; Optionally define a repeat map so that "M" will cycle thru Claude auto-accept/plan/confirm modes after invoking claude-code-cycle-mode / C-c M.
  :bind
  (:repeat-map my-claude-code-map ("M" . claude-code-cycle-mode)))

(setq claude-code-terminal-backend 'vterm)
