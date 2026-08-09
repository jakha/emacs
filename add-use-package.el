;;; package --- use package installing
;;; Commentary:

;; (when (not (file-directory-p "~/.emacs.d/site-lisp/use-package"))
;;   (let ((default-directory "~/.emacs.d"))
;;     (shell-command-to-string "git clone https://github.com/jwiegley/use-package.git ~/.emacs.d/site-lisp/use-package"))
;;   (let ((default-directory "~/.emacs.d/site-lisp/use-package"))
;;     (shell-command-to-string "echo 'LOAD_PATH  = -L ~/.emacs.d/site-lisp/use-package' > config.mk && make")))
;; (when (not (file-directory-p "~/.emacs.d/site-lisp/use-package"))
;;   (let ((default-directory "~/.emacs.d"))
;;     (shell-command-to-string "git clone https://github.com/jwiegley/use-package.git ~/.emacs.d/site-lisp/use-package"))
;;   (let ((default-directory "~/.emacs.d/site-lisp/use-package"))
;;     (shell-command-to-string "echo 'LOAD_PATH  = -L ~/.emacs.d/site-lisp/use-package' > config.mk && make")))

;; (defun load-use-package ()
;;   (add-to-list 'load-path "~/.emacs.d/site-lisp/use-package")
;;   (require 'use-package)
;;   (with-eval-after-load 'info
;;     (info-initialize)
;;     (add-to-list 'Info-directory-list
;; 		 "~/.emacs.d/site-lisp/use-package/")))


(defun ensure-use-package-git ()
  (let ((dest (expand-file-name "~/.emacs.d/site-lisp/use-package")))
	(unless (file-directory-p dest)
	  (make-directory (file-name-directory dest) t)  ;; mkdir -p the parent
	  (let ((default-directory (file-name-directory dest)))
		(unless (zerop (call-process "git" nil "*use-package-clone*" t
									 "clone" "https://github.com/jwiegley/use-package.git"
									 "use-package"))
		  (error "use-package clone failed, see *use-package-clone* buffer")))
	  (let ((default-directory dest))
			  (with-temp-file (expand-file-name "config.mk" dest)
			   (insert "LOAD_PATH = -L " dest "\n"))
		  (call-process "make" nil "*use-package-build*" t)))
	  dest))
                                                                                                                                                                                                                                            
(defun load-use-package ()
  (let ((dest (ensure-use-package-git)))
	(add-to-list 'load-path dest)
	(unload-feature 'use-package t)                                                                                                                                                                             
       (load (expand-file-name "use-package.el" dest) nil t)                                                                                                                                                       
      (with-eval-after-load 'info                                                                                                                                                                                  
        (info-initialize)
        (add-to-list 'Info-directory-list dest))))


(load-use-package)


