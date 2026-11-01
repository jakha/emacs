;;; init-eglot.el --- shared eglot + corfu setup for the language IDEs  -*- lexical-binding: t -*-
;;; Commentary:
;; Loaded by the per-language modules (languages/php, languages/go).
;; Install / update dependencies with `make <lang>-ide' from the repo root.
;; No network access and no installs happen here.
;;; Code:

;; pinned tools from scripts/install-*-deps.sh
(let ((bin (expand-file-name "~/.local/bin")))
  (unless (member bin exec-path)
    (add-to-list 'exec-path bin)
    (setenv "PATH" (concat bin path-separator (getenv "PATH")))))

(setq eglot-events-buffer-config '(:size 0 :format full) ; no JSON-RPC logging
      eglot-autoshutdown t
      eglot-sync-connect nil
      eglot-extend-to-xref t)

(defun ide-eglot-setup (server)
  "Start eglot and corfu in the current buffer, SERVER is the LSP program."
  (unless (executable-find server)
    (message "%s not found, run `make ide' in %s" server user-emacs-directory))
  (eglot-ensure)
  (if (require 'corfu nil t)
      (corfu-mode 1)
    (message "corfu not installed, run `make ide-elisp' in %s" user-emacs-directory)))

(defun ide-format-on-save (modes &rest extra)
  "Format buffers of MODES with the LSP server before saving.
EXTRA are more functions to run in `before-save-hook' before formatting."
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (when (and (apply #'derived-mode-p modes)
                         (eglot-server-capable :documentFormattingProvider))
                (add-hook 'before-save-hook #'eglot-format-buffer nil t)
                (dolist (fn extra)
                  (add-hook 'before-save-hook fn -10 t))))))

(with-eval-after-load 'corfu
  ;; package-vc ignores ELPA's extensions/ rename, so corfu-auto etc. need this
  (add-to-list 'load-path (expand-file-name "extensions"
                                            (file-name-directory (locate-library "corfu"))))
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 1
        corfu-cycle t))

(load (concat user-emacs-directory "kbd/eglot.el"))

(provide 'init-eglot)
;;; init-eglot.el ends here
