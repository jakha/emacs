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

(defun markdown-ide--html-file ()
  "HTML file the preview of the current buffer is rendered to."
  (expand-file-name
   (format "md-preview-%s.html"
           (md5 (or buffer-file-name (buffer-name))))
   temporary-file-directory))

(defun markdown-ide--render ()
  "Render the current buffer with pandoc, return the HTML file name."
  (unless (executable-find "pandoc")
    (user-error "pandoc not found, run `make markdown-ide' in %s" user-emacs-directory))
  (let ((out (markdown-ide--html-file))
        ;; relative links and images resolve against the markdown file
        (base (format "<base href=\"file://%s\">"
                      (file-name-as-directory (expand-file-name default-directory)))))
    (save-restriction
      (widen)
      (unless (zerop (call-process-region
                      (point-min) (point-max) "pandoc" nil "*markdown-ide-pandoc*" nil
                      "--from=gfm" "--to=html5" "--standalone"
                      (concat "--metadata=pagetitle=" (buffer-name))
                      (concat "--variable=header-includes=" base)
                      (concat "--css=file://" (expand-file-name markdown-ide-preview-css))
                      (concat "--output=" out)))
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
  (let ((file (markdown-ide--render)))
    (when (get-buffer-window "*markdown-preview*" t)
      (markdown-ide--refresh-eww file))))

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
  (add-hook 'after-save-hook #'markdown-ide--after-save nil t)
  (browse-url (concat "file://" (markdown-ide--render))))

(load (concat user-emacs-directory "kbd/markdown.el"))

(provide 'init-markdown-ide)
;;; init-markdown-ide.el ends here
