;;; install.el --- batch installer for the language IDEs  -*- lexical-binding: t -*-
;;; Commentary:
;; emacs --batch -l languages/ide/install.el -f ide-install [php go ...]
;; emacs --batch -l languages/ide/install.el -f ide-verify  [php go ...]
;; Without language arguments every language in `ide-languages' is used.
;;; Code:

(require 'package)
(require 'package-vc)
(require 'treesit)

(load (expand-file-name "ide-lock.el" (file-name-directory load-file-name)) nil t)

(package-initialize)

(defun ide--selected-languages ()
  "Languages named on the command line, or all of `ide-languages'."
  (let ((names (mapcar #'intern command-line-args-left)))
    (setq command-line-args-left nil)
    (if names
        (mapcar (lambda (name)
                  (or (assq name ide-languages)
                      (error "Unknown language %s" name)))
                names)
      ide-languages)))

(defun ide--package-rev (name)
  "Return HEAD commit of package-vc checkout NAME, or nil."
  (let ((dir (expand-file-name (symbol-name name) package-user-dir)))
    (when (file-directory-p (expand-file-name ".git" dir))
      (let ((default-directory dir))
        (string-trim (shell-command-to-string "git rev-parse HEAD"))))))

(defun ide-install-packages ()
  "Install `ide-packages' at their pinned revisions."
  (dolist (spec ide-packages)
    (let* ((name (car spec))
           (url (plist-get (cdr spec) :url))
           (rev (plist-get (cdr spec) :rev))
           (current (ide--package-rev name)))
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
  (dolist (spec ide-packages)
    (unless (equal (ide--package-rev (car spec)) (plist-get (cdr spec) :rev))
      (error "%s is not at the pinned revision" (car spec)))))

(defun ide-install-grammars (languages)
  "Build tree-sitter grammars of LANGUAGES from the recipes pinned by Emacs."
  (dolist (language languages)
    (require (plist-get (cdr language) :feature))
    (dolist (grammar (plist-get (cdr language) :grammars))
      (if (treesit-language-available-p grammar)
          (message "ok: grammar %s" grammar)
        (message "install: grammar %s" grammar)
        (treesit-install-language-grammar grammar)))))

(defun ide-install ()
  "Install everything the selected IDEs need inside Emacs."
  (ide-install-grammars (ide--selected-languages))
  (ide-install-packages))

(defun ide-verify ()
  "Exit non-zero when something the selected IDEs need is missing."
  (let ((errors nil)
        (path (expand-file-name "~/.local/bin")))
    (add-to-list 'exec-path path)
    (dolist (language (ide--selected-languages))
      (dolist (grammar (plist-get (cdr language) :grammars))
        (unless (treesit-language-available-p grammar)
          (push (format "grammar %s missing" grammar) errors)))
      (dolist (program (plist-get (cdr language) :executables))
        (unless (executable-find program)
          (push (format "%s not on PATH" program) errors))))
    (dolist (spec ide-packages)
      (unless (equal (ide--package-rev (car spec)) (plist-get (cdr spec) :rev))
        (push (format "package %s not at %s" (car spec) (plist-get (cdr spec) :rev)) errors)))
    (if errors
        (progn (mapc (lambda (e) (message "FAIL: %s" e)) (nreverse errors))
               (kill-emacs 1))
      (message "ide: all good"))))

;;; install.el ends here
