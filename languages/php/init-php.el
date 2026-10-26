;;; init-php.el --- PHP IDE: php-ts-mode + eglot + phpantom_lsp  -*- lexical-binding: t -*-
;;; Commentary:
;; Install / update dependencies with `make php-ide' from the repo root.
;; No network access and no installs happen here.
;;; Code:

;; pinned tools from scripts/install-php-deps.sh
(let ((bin (expand-file-name "~/.local/bin")))
  (unless (member bin exec-path)
    (add-to-list 'exec-path bin)
    (setenv "PATH" (concat bin path-separator (getenv "PATH")))))

(add-to-list 'auto-mode-alist '("\\.php\\'" . php-ts-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((php-ts-mode php-mode) . ("phpantom_lsp"))))

(setq eglot-events-buffer-config '(:size 0 :format full) ; no JSON-RPC logging
      eglot-autoshutdown t
      eglot-sync-connect nil
      eglot-extend-to-xref t)

(defun php-ide-format-on-save ()
  "Format buffer with phpantom before saving."
  (add-hook 'before-save-hook #'eglot-format-buffer nil t))

(defun php-ide-setup ()
  "Enable IDE features in a PHP buffer."
  (unless (executable-find "phpantom_lsp")
    (message "phpantom_lsp not found, run `make php-ide' in %s" user-emacs-directory))
  (eglot-ensure)
  (if (require 'corfu nil t)
      (corfu-mode 1)
    (message "corfu not installed, run `make php-elisp' in %s" user-emacs-directory)))

(add-hook 'php-ts-mode-hook #'php-ide-setup)
(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (when (and (derived-mode-p 'php-ts-mode)
                       (eglot-server-capable :documentFormattingProvider))
              (php-ide-format-on-save))))

(with-eval-after-load 'corfu
  ;; package-vc ignores ELPA's extensions/ rename, so corfu-auto etc. need this
  (add-to-list 'load-path (expand-file-name "extensions"
                                            (file-name-directory (locate-library "corfu"))))
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 1
        corfu-cycle t))

(load (concat user-emacs-directory "kbd/php.el"))
(load (concat user-emacs-directory "kbd/php-eglot.el"))

(provide 'init-php)
;;; init-php.el ends here
