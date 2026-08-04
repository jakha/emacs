(load (concat user-emacs-directory "languages/go/init-go-mode.el"))

(load (concat user-emacs-directory "languages/go/init-debug.el"))

;;(load (concat user-emacs-directory "languages/go/init-go-eldoc.el"))

;;(load (concat user-emacs-directory "languages/go/init-company-go.el"))

;;(load (concat user-emacs-directory "languages/go/init-go-rename.el"))

;;(load (concat user-emacs-directory "languages/go/init-gotest.el"))

;;(load (concat user-emacs-directory "languages/go/init-goscratch.el"))

(load (concat user-emacs-directory "languages/go/init-go-direx.el"))

(load (concat user-emacs-directory "languages/go/init-go-mod-vendor.el"))

;;(load (concat user-emacs-directory "languages/go/init-go-guru.el"))

;;(load (concat user-emacs-directory "languages/go/init-multicompile.el"))

;;(add-hook 'before-save-hook 'gofmt-before-save)

;; (setq-default gofmt-command "goimports")
;; (add-hook 'go-mode-hook 'go-eldoc-setup)
;; (add-hook 'go-mode-hook (lambda ()
;;                             (set (make-local-variable 'company-backends) '(company-go))
;;                             (company-mode)))
;; ;;(add-hook 'go-mode-hook 'yas-minor-mode)
;; (add-hook 'go-mode-hook 'flycheck-mode)

(require 'cl-macs)
(require 'cl-lib)

(defun goja-run (run-file &optional params)
  "RUN-FILE, &OPTIONAL PARAMS."
  (interactive)
  (projectile-run-compilation
   (lambda ()
	 (setf default-directory (projectile-project-root))
	 (let ((compilation-buffer-name (concat "*" run-file "*")))
	   (when (not (null  (get-buffer compilation-buffer-name)))
		 (let ((kill-buffer-query-functions nil))
		   (kill-buffer compilation-buffer-name)))
	   (setq split-width-threshold t)
	   (let ((run-string (concat "go run -v -race " run-file)))
		 (when (stringp params)
		   (setq run-string (concat run-string params)))
		 (compile run-string nil))
	   (setq split-width-threshold nil)
	   (ja-rename-buffer "*compilation*" compilation-buffer-name)
	   (lexical-let ((buf-name compilation-buffer-name))
	   	 (async-start
	   	  (lambda ()
	   		(sleep-for 2))
	   	  (lambda (result)
			(with-current-buffer buf-name
			  (set-window-point
			   (get-buffer-window  buf-name)
			   (point-max))))))))))

(cl-defun ja-rename-buffer (old-name new-name)
  "OLD-NAME NEW-NAME."
  (when (eq (buffer-name) old-name)
	(rename-buffer new-name)
	(return-from ja-rename-buffer))
  (let ((remembered-buffer (buffer-name)))
	(switch-to-buffer old-name)
	(rename-buffer new-name)
	(switch-to-buffer remembered-buffer)))

(defun ide-run-last-build ()
  "."
  (interactive)
  (setq *context*
		(load-json-file-to-hash-table
		 (get-config-path)))
  (run-last-build *context*))

(defun run-last-build(config-obj)
  "CONFIG-OBJ."
  (let ((env-file-path (get-env-file-path)))
	(when (file-exists-p env-file-path)
	  (load-env env-file-path)))
	(goja-run (goja-get-last-build config-obj)))

(defun goja-get-last-build (config-obj)
  "CONFIG-OBJ."
  (gethash "last-build" (gethash "compile" config-obj)))

(defun goja-add-last-build-to-build-list ()
  "."
  (interactive)
  (setq *context*
		(load-json-file-to-hash-table
		 (get-config-path)))
  (goja-add-to-build-list (goja-get-last-build *context*)))

(add-hook 'go-mode-hook 'create-go-ide-dir)

(defun create-go-ide-dir ()
  "Will create .emacs-go-ide directory in root of project if not exist."
  (let* ((go-mod-path (locate-dominating-file buffer-file-name "go.mod"))
		 (git-dir-path (locate-dominating-file buffer-file-name ".git"))
		 (path-to-create go-mod-path))
	(when (null go-mod-path)
	  (if (null git-dir-path)
		  (setq path-to-create default-directory)
		(setq path-to-create git-dir-path)))
	(when (not (file-directory-p (concat path-to-create "/.emacs-go-ide")))
	  (make-directory (concat path-to-create "/.emacs-go-ide")))))

(defun goja-create-go-ide-dir ()
  "."
  (interactive)
  (create-go-ide-dir))

(defun get-empty-config-obj ()
  "."
  (setq compile-config (make-hash-table :test 'equal))
  (setq config-obj (make-hash-table :test 'equal))
  (puthash "last-build" "" compile-config)
  (puthash "build-list" (list) compile-config)
  (puthash "compile" compile-config config-obj)
  config-obj)

(defun get-config-path ()
  "Will return go IDE config path."
  (let ((config-path (concat (locate-dominating-file buffer-file-name ".emacs-go-ide")
							 ".emacs-go-ide/config.json")))
	(when (not (file-exists-p config-path))
	  (write-region "" nil config-path))
	config-path))

(defun goja-add-to-build-list (build-path)
  "Add BUILD-PATH to build-path list in config."
  (let* ((config-obj (load-json-file-to-hash-table (get-config-path)))
		 (compile-obj (gethash "compile" config-obj))
		 (build-list (gethash "build-list" compile-obj)))
	(when (null build-list)
	  (setq build-list (list)))
	(add-to-list 'build-list  build-path)
    (puthash "build-list" build-list compile-obj)
	(puthash "compile" compile-obj config-obj)
	(persist-go-ide-config config-obj)))


(defun persist-go-ide-config (config-obj)
  "CONFIG-OBJ IDE object to save."
  (write-region
   (json-encode config-obj) nil
   (get-config-path)))

(defun pick-to-build (config-obj)
  "CONFIG-OBJ."
  (interactive)
  (ivy-completing-read "Choose build: "
					   (gethash "build-list"
								(gethash "compile"
										 config-obj))))

(defun get-config-obj ()
  "."
  (condition-case nil
	  (load-json-file-to-hash-table (get-config-path))
	(json-error
	 (get-empty-config-obj))))


(defun build-current-buffer-main()
  "."
  (interactive)
  (setq *context* (get-config-obj))
  (build-current-buffer *context*))

(defun build-current-buffer (config-obj)
  "CONFIG-OBJ."
  (let ((build-path (replace-regexp-in-string
					 (projectile-project-root)
					 ""
					 (buffer-file-name))))
	(let ((env-file-path (get-env-file-path)))
	  (when (file-exists-p env-file-path)
		(load-env env-file-path)))
	(goja-run build-path)
	(set-as-last-build build-path config-obj)
	(persist-go-ide-config config-obj)))


(defvar-local *context* (list) "Context contain all info about alias, kubeconfig, namespace for kubernetes.")

(defun ide-pick-to-build ()
  "."
  (interactive)
  (setq *context* (load-json-file-to-hash-table (get-config-path)))
  (let ((build-path (pick-to-build *context*))
		(env-file-path (get-env-file-path)))
	(when (file-exists-p env-file-path)
	  (load-env env-file-path))
	(goja-run build-path)
	(set-as-last-build build-path *context*)
	(persist-go-ide-config *context*)))

(defun ide-make-migration ()
  "."
  (interactive)
  (setq *context* (load-json-file-to-hash-table (get-config-path)))
  (let ((build-path (pick-to-build *context*))
		(migration-name (read-string "Enter migration name:")))
	(goja-run build-path (concat " make " migration-name))
	(set-as-last-build build-path *context*)
	(persist-go-ide-config *context*)))

(defun set-as-last-build (build-path config-obj)
  "BUILD-PATH CONFIG-OBJ ."
  (let* ((compile (gethash "compile" config-obj)))
	(puthash "last-build" build-path compile)
	(puthash "compile" compile config-obj))
  config-obj)

;; (define-transient-command goja-build-transient ()
;;   ["Actions"
;;    ("c" "current main" build-current-buffer-main)
;;    ("p" "pick build" ide-pick-to-build)
;;    ("m" "make migration" ide-make-migration)])

(defun get-env-file-path ()
  "."
  (concat (locate-dominating-file buffer-file-name ".emacs-go-ide")
		  ".env"))


(defun create-buffer-observer (buffer-name hooks)
  "Will watch BUFFER-NAME modifications and do HOOKS."
  (lexical-let ((lexical-hooks hooks)
				(lexical-buffer-name buffer-name)
				(lexical-point-max (with-current-buffer buffer-name
									 (point-max))))
	#'(lambda ()
		(while (not (null (get-buffer lexical-buffer-name)))
		  (sleep-for 0 100)
		  (let ((current-point-max
				 (with-current-buffer lexical-buffer-name
				   (point-max))))
			(when (not (eq  lexical-point-max current-point-max))
			  (with-current-buffer lexical-buffer-name
				(goto-char current-point-max))
			  (setq lexical-point-max current-point-max)))))))

(defun goja-get-package ()
  "."
  (interactive)
  (let* ((package-name (ivy-completing-read "Package: " (go-mod-requires)))
		 (proc-name (concat "go-get-" package-name)))
	(spinner-start  'progress-bar-filled)
	(let ((go-get-proc (start-process
						proc-name
						nil
						"go"
						"get"
						package-name)))
	  (set-process-sentinel go-get-proc (lambda (proc data)
										  (when (not (process-live-p proc))
											(spinner-stop))))
	  (set-process-filter go-get-proc (lambda (proc data)
										(message data))))))


(defun go-mod-requires ()
  "."
  (let ((go-mod-path (concat (projectile-project-root) "go.mod"))
		(result (list))
		(in-require-scope nil))
	(when (not (file-exists-p go-mod-path))
	  (error "Not found file"))
	(dolist (row (split-string (file-to-string go-mod-path) "\n"))
	  (cond  (in-require-scope
			  (cond ((string-match-p ")" row)
		   			 (setq in-require-scope nil))
					(t
					 (let ((package (s-trim (first (split-string row " ")))))
					   (setq result  (append result (list package)))))))
			 ((string-match-p "require" row)
			  (cond ((string-match-p "(" row)
					 (setq in-require-scope t))
					(t
					 (let ((go-package-name (s-trim (nth 1 (split-string row " ")))))
					   (setq result (append result (list go-package-name)))))))))
	result))

(defun goja-get (package)
  "PACKAGE - module name."
  
  )

(defun file-to-string (file)
  "FILE to string function."
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(defun run-buffer-observer-in-thread (buffer-name hooks)
  "Run BUFFER-NAME observer in thread.Eval HOOKS in thread."
  ;; (setq thread (make-thread
  ;; 				(create-buffer-observer buffer-name hooks)
  ;; 				buffer-name))
;;  thread
  )

(provide 'init-go)
;;; init-go.el ends here
