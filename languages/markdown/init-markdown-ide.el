;;; init-markdown-ide.el --- Markdown IDE: markdown-ts-mode + eglot + marksman  -*- lexical-binding: t -*-
;;; Commentary:
;; Install / update dependencies with `make markdown-ide' from the repo root.
;; marksman gives links/headings completion, go to definition, references,
;; rename of headings and broken link diagnostics. It has no formatter.
;; Preview: pandoc renders the buffer (saved or not) to HTML,
;; `markdown-ide-preview' shows it in a side window, `markdown-ide-preview-browser'
;; in the web browser. Both re-render on save.
;;; Code:

(require 'init-eglot (concat user-emacs-directory "languages/ide/init-eglot.el"))

;; markdown-ts-mode ships with Emacs 31.1 but is not autoloaded
(autoload 'markdown-ts-mode "markdown-ts-mode" "Major mode for Markdown." t)
(add-to-list 'auto-mode-alist '("\\.\\(md\\|markdown\\)\\'" . markdown-ts-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((markdown-ts-mode markdown-mode) . ("marksman" "server"))))

(add-hook 'markdown-ts-mode-hook (lambda () (ide-eglot-setup "marksman")))

(defconst markdown-ide-preview-css
  (concat user-emacs-directory "languages/markdown/preview.css"))

(defvar markdown-ide-browser-directory
  (let ((snap (expand-file-name "~/snap/firefox/common")))
    ;; snap Firefox has a private /tmp and can't read hidden dirs in $HOME
    (if (file-directory-p snap)
        (expand-file-name "md-preview" snap)
      temporary-file-directory))
  "Where HTML for the browser preview is written; the browser must read it.")

(defvar-local markdown-ide--browser-preview nil
  "Non-nil when the browser preview of this buffer is re-rendered on save.")

(defun markdown-ide--html-file (dir)
  "HTML file in DIR the preview of the current buffer is rendered to."
  (make-directory dir t)
  (expand-file-name
   (format "md-preview-%s.html"
           (md5 (or buffer-file-name (buffer-name))))
   dir))

(defun markdown-ide--render (&optional browser)
  "Render the current buffer with pandoc, return the HTML file name.
With BROWSER, embed CSS and images into one self-contained file in
`markdown-ide-browser-directory'; otherwise link them for eww."
  (unless (executable-find "pandoc")
    (user-error "pandoc not found, run `make markdown-ide' in %s" user-emacs-directory))
  (let* ((dir (file-name-as-directory (expand-file-name default-directory)))
         (out (markdown-ide--html-file
               (if browser markdown-ide-browser-directory temporary-file-directory)))
         (args (if browser
                   (list "--embed-resources"
                         (concat "--resource-path=" dir)
                         (concat "--css=" (expand-file-name markdown-ide-preview-css)))
                 ;; relative links and images resolve against the markdown file
                 (list (format "--variable=header-includes=<base href=\"file://%s\">" dir)))))
    (save-restriction
      (widen)
      (unless (zerop (apply #'call-process-region
                            (point-min) (point-max) "pandoc" nil "*markdown-ide-pandoc*" nil
                            "--from=gfm" "--to=html5" "--standalone"
                            (concat "--metadata=pagetitle=" (buffer-name))
                            (concat "--output=" out)
                            args))
        (user-error "pandoc failed, see *markdown-ide-pandoc*")))
    out))

(defun markdown-ide--refresh-eww (file)
  "Show FILE in the *markdown-preview* buffer, keeping its position."
  (let ((buf (get-buffer-create "*markdown-preview*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t)
            (pos (point)))
        (erase-buffer)
        (shr-insert-document
         (with-temp-buffer
           (insert-file-contents file)
           (libxml-parse-html-region (point-min) (point-max))))
        (goto-char (min pos (point-max))))
      (unless (derived-mode-p 'special-mode)
        (special-mode)))
    buf))

(defun markdown-ide--after-save ()
  (when (get-buffer-window "*markdown-preview*" t)
    (markdown-ide--refresh-eww (markdown-ide--render)))
  (when markdown-ide--browser-preview
    (markdown-ide--render t)))

(defun markdown-ide-preview ()
  "Preview the current Markdown buffer in a side window, refreshed on save."
  (interactive)
  (require 'shr)
  (add-hook 'after-save-hook #'markdown-ide--after-save nil t)
  (display-buffer (markdown-ide--refresh-eww (markdown-ide--render))
                  '(display-buffer-in-side-window (side . right) (window-width . 0.5))))

(defun markdown-ide-preview-browser ()
  "Open the rendered current buffer in the web browser.
The file is re-rendered on save, reload the page to see changes."
  (interactive)
  (setq markdown-ide--browser-preview t)
  (add-hook 'after-save-hook #'markdown-ide--after-save nil t)
  (browse-url (concat "file://" (markdown-ide--render t))))

(load (concat user-emacs-directory "kbd/markdown.el"))

(provide 'init-markdown-ide)
;;; init-markdown-ide.el ends here
