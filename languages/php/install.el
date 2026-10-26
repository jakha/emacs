;;; install.el --- batch installer for the PHP IDE  -*- lexical-binding: t -*-
;;; Commentary:
;; emacs --batch -l languages/php/install.el -f php-ide-install
;; emacs --batch -l languages/php/install.el -f php-ide-verify
;;; Code:

(require 'package)
(require 'package-vc)
(require 'treesit)

(load (expand-file-name "php-ide-lock.el" (file-name-directory load-file-name)) nil t)

(package-initialize)

(defun php-ide--package-rev (name)
  "Return HEAD commit of package-vc checkout NAME, or nil."
  (let ((dir (expand-file-name (symbol-name name) package-user-dir)))
    (when (file-directory-p (expand-file-name ".git" dir))
      (let ((default-directory dir))
        (string-trim (shell-command-to-string "git rev-parse HEAD"))))))

(defun php-ide-install-packages ()
  "Install `php-ide-packages' at their pinned revisions."
  (dolist (spec php-ide-packages)
    (let* ((name (car spec))
           (url (plist-get (cdr spec) :url))
           (rev (plist-get (cdr spec) :rev))
           (current (php-ide--package-rev name)))
      (cond
       ((equal current rev)
        (message "ok: %s %s" name rev))
       (t
        (when (package-installed-p name)
          (message "reinstall: %s %s -> %s" name current rev)
          (package-delete (cadr (assq name package-alist)) t))
        (message "install: %s %s" name rev)
        (package-vc-install (list name :url url) rev)))))
  ;; package-vc-install leaves pinned checkouts on a detached HEAD, verify it
  (dolist (spec php-ide-packages)
    (unless (equal (php-ide--package-rev (car spec)) (plist-get (cdr spec) :rev))
      (error "%s is not at the pinned revision" (car spec)))))

(defun php-ide-install-grammars ()
  "Build tree-sitter grammars from the recipes pinned by Emacs."
  (require 'php-ts-mode)
  (dolist (lang php-ide-grammars)
    (if (treesit-language-available-p lang)
        (message "ok: grammar %s" lang)
      (message "install: grammar %s" lang)
      (treesit-install-language-grammar lang))))

(defun php-ide-install ()
  "Install everything the PHP IDE needs inside Emacs."
  (php-ide-install-grammars)
  (php-ide-install-packages))

(defun php-ide-verify ()
  "Exit non-zero when something the PHP IDE needs is missing."
  (let ((errors nil))
    (dolist (lang php-ide-grammars)
      (unless (treesit-language-available-p lang)
        (push (format "grammar %s missing" lang) errors)))
    (dolist (spec php-ide-packages)
      (unless (equal (php-ide--package-rev (car spec)) (plist-get (cdr spec) :rev))
        (push (format "package %s not at %s" (car spec) (plist-get (cdr spec) :rev)) errors)))
    (unless (executable-find "phpantom_lsp")
      (push "phpantom_lsp not on PATH" errors))
    (if errors
        (progn (mapc (lambda (e) (message "FAIL: %s" e)) (nreverse errors))
               (kill-emacs 1))
      (message "php-ide: all good"))))

;;; install.el ends here
