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

;; Emacs launched from the desktop does not source ~/.bashrc, so nvm's bin
;; directory is missing from exec-path and `claude' is not found. Add the
;; newest installed node version's bin dir to both exec-path and PATH.
(let* ((nvm-bins (file-expand-wildcards
                  (expand-file-name "~/.nvm/versions/node/*/bin")))
       (bin (car (last (sort nvm-bins #'string<)))))
  (when (and bin (file-directory-p bin))
    (add-to-list 'exec-path bin)
    (setenv "PATH" (concat bin path-separator (getenv "PATH")))))

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

;;;; Switching between several Claude config directories.
;; CLAUDE_CONFIG_DIR tells the CLI which directory to read settings and
;; credentials from.  It is read once at process start, so switching only
;; affects sessions started afterwards; already running buffers keep theirs.

;; (defvar my/claude-configs
;;   '((default . nil)
;;     (debex   . "~/claude-debex"))
;;   "Alist of NAME -> Claude config directory, nil meaning the CLI default.")

;; (defvar my/claude-config 'default
;;   "Key in `my/claude-configs' used for newly started Claude sessions.")

;; (defun my/claude-config-env (_buffer-name _directory)
;;   "Return CLAUDE_CONFIG_DIR for the currently selected config, if any.

;; Return nil for a config whose directory is nil, so the variable stays
;; unset.  CLAUDE_CONFIG_DIR=~/.claude is *not* equivalent to leaving it
;; unset: unset, the CLI keeps its account/onboarding state in ~/.claude.json
;; and only the rest under ~/.claude; set, it looks for that state inside the
;; directory (~/.claude/.claude.json), finds nothing and asks to log in again."
;;   (let ((dir (alist-get my/claude-config my/claude-configs)))
;;     (when dir
;;       (list (format "CLAUDE_CONFIG_DIR=%s" (expand-file-name dir))))))

;; (add-hook 'claude-code-process-environment-functions #'my/claude-config-env)

;; (defun my/claude-switch-config (name)
;;   "Select NAME from `my/claude-configs' for the next Claude session."
;;   (interactive
;;    (list (intern (completing-read "Claude config: "
;;                                   (mapcar #'car my/claude-configs) nil t))))
;;   (setq my/claude-config name)
;;   (message "Claude config -> %s"
;;            (or (alist-get name my/claude-configs) "default (~/.claude.json)")))

;; (with-eval-after-load 'claude-code
;;   (define-key claude-code-command-map (kbd "a") #'my/claude-switch-config))


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
