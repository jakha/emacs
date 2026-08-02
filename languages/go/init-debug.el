;;(load (concat user-emacs-directory "go-dlv.el/go-dlv.el"))

;;(setq dap-auto-configure-features '(sessions locals controls tooltip))

;;(use-package dap-mode
;; :ensure t
;; :after lsp-mode)
;;   :commands dap-debug
;;   :custom
;;   (dap-auto-configure-features '(sessions locals breakpoints expressions repl controls tooltip))
;;   :config
;;   (require 'dap-node)
;;   (dap-node-setup)
;;   (require 'dap-go)
;;   (dap-go-setup)
;;   (require 'dap-hydra)
;;   (require 'dap-gdb-lldb)
;;   (dap-gdb-lldb-setup)
;;   (dap-mode 1)
;;   (dap-auto-configure-mode 1))

;; (setq dap-print-io t)

;;(load (concat user-emacs-directory "utils/dap-dlv-go.el"))

;;(require 'dap-dlv-go)

;;(dap-register-debug-template
;; "Go Launch Unoptimized Debug Package"
 ;;(list :type "go"
      ;; :request "launch"
       ;;:name"Go Launch Unoptimized Debug Package"
       ;;:mode "debug"
       ;;:program nil
	   ;;:buildFlags "-gcflags '-N -l'"
       ;;:args nil
       ;;:env nil))

  ;; (with-eval-after-load 'dap-ui
  ;;   (setq dap-ui-buffer-configurations
  ;;         `(
  ;;           (,dap-ui--breakpoints-buffer . ((side . left) (slot . 3) (window-width . ,treemacs-width)))
  ;;           (,dap-ui--expressions-buffer . ((side . right) (slot . 1) (window-width . 0.3)))
  ;; 			(,dap-ui--locals-buffer . ((side . right) (slot . 2) (window-width . 0.3)))
  ;;           (,dap-ui--repl-buffer . ((side . bottom) (slot . 2) (window-height . 0.2)))))
  ;; (,dap-ui--sessions-buffer . ((side . right) (slot . 3) (window-width . 0.3)))
  ;; (,dap-ui--debug-window-buffer . ((side . bottom) (slot . 1) (window-height . 0.2)))
  ;;  )


;; (add-to-list 'display-buffer-alist '(" server log\\*\\'" display-buffer-no-window))

;; (defun ide-debug-last-build ()
;;   "."
;;   (interactive)
;;   (setq *context*
;; 		(load-json-file-to-hash-table
;; 		 (get-config-path)))
;;   (goja-debug-last-build *context*))


;; (defun goja-debug-last-build (config-obj)
;;   "CONFIG-OBJ."
;;   (setf default-directory (projectile-project-root))
;;   (let* ((env-file-path (get-env-file-path))
;; 		 (debug-buffer-name (concat
;; 							 (projectile-project-root)
;; 							 (goja-get-last-build config-obj)))
;; 		 (debug-buffer (find-file-noselect debug-buffer-name)))
;; 	(when (file-exists-p env-file-path)
;; 	  (load-env env-file-path))
;; 	(with-current-buffer debug-buffer
;; 	  (let ((args '(:type "go"
;; 						  :request "launch"
;; 						  :name "Launch Unoptimized Debug Package"
;; 						  :mode "debug"
;; 						  :program nil
;; 						  :buildFlags "-gcflags '-N -l'"
;; 						  :args nil
;; 						  :env nil
;; 						  :envFile nil)))
;; 		(dap-debug args)))))
;"."
