;;; -*- lexical-binding: t -*-
(global-auto-revert-mode t)
;; Автосохранение только для локальных файлов внутри git-репозитория;
;; остальные Emacs предложит сохранить при закрытии буфера / выходе.
(defvar-local my/in-git-repo 'unknown
  "Кэш: находится ли файл буфера в git-репозитории.")

(defun my/auto-save-in-git-p ()
  "Предикат для `auto-save-visited-mode': только файлы в git."
  (when (and buffer-file-name
             (not (file-remote-p buffer-file-name))) ; TRAMP не трогаем
    (when (eq my/in-git-repo 'unknown)
      (setq my/in-git-repo
            (and (locate-dominating-file buffer-file-name ".git") t)))
    my/in-git-repo))

(setq auto-save-visited-predicate #'my/auto-save-in-git-p)
(auto-save-visited-mode 1)

(desktop-save-mode 1)

(delete-selection-mode t)  ; delete seleted text when typing

;; Backspace / Delete / набор текста поверх выделения просто удаляют
;; область, не кладя её в kill-ring (вырезать — только M-q).
(setq delete-active-region t)

(defun my/delete-region-no-kill (orig-fn &rest args)
  "Если есть выделение — удалить его без записи в kill-ring."
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (apply orig-fn args)))

;; smartparens-команды удаления при выделении иначе могут вызывать kill-region
(with-eval-after-load 'smartparens
  (dolist (fn '(sp-delete-char sp-backward-delete-char))
    (advice-add fn :around #'my/delete-region-no-kill)))

(unless (display-graphic-p)
  (define-key input-decode-map "\e[1;2A" [S-up])
  (define-key input-decode-map "\e[1;2B" [S-down])
  (define-key input-decode-map "\e[1;2C" [S-right])
  (define-key input-decode-map "\e[1;2D" [S-left])
  ;; заодно C-стрелки и M-стрелки, они тоже часто отваливаются
  (define-key input-decode-map "\e[1;5C" [C-right])
  (define-key input-decode-map "\e[1;5D" [C-left])
  (define-key input-decode-map "\e[1;3C" [M-right])
  (define-key input-decode-map "\e[1;3D" [M-left]))

(setq-default tab-width 4)
;; tramp not use version co 
(setq vc-handled-backends 'nil)
(setq tramp-verbose 1                          ; default 3, logging costs time
      remote-file-name-inhibit-locks t         ; skip lock files
      tramp-use-scp-direct-remote-copying t)

;; (put 'upcase-region 'disabled nil)
;; (put 'downcase-region 'disabled nil)
;; (put 'set-goal-column 'disabled nil)


;; to not show line toggle sign 
(setf (cdr (assq 'continuation fringe-indicator-alist))
      '(nil nil) ;; no continuation indicators
      ;; '(nil right-curly-arrow) ;; right indicator only
      ;; '(left-curly-arrow nil) ;; left indicator only
      ;; '(left-curly-arrow right-curly-arrow) ;; default
      )


(add-hook 'post-command-hook
          (lambda ()
            (let ((messages (get-buffer "*Messages*")))
              (unless (eq (current-buffer) messages)
                (with-current-buffer messages
                  (goto-char (point-max)))))))

(setq read-process-output-max (* 1024 1024))

(unless (not package-archive-contents)
  (load "~/.emacs.d/base.conf/init-repository-packages.el"))


;; (setq backup-directory-alist `(("." . "~/.saves")))

;;(use-package dash-functional)

