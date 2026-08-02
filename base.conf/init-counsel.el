(use-package counsel
  :ensure t)

(global-set-key (kbd "M-x") 'counsel-M-x)

(global-set-key (kbd "M-f") 'counsel-find-file)
(global-set-key (kbd "M-d") 'dired)

(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
;; (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
;; (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "M-g") 'counsel-git)
;;(global-set-key (kbd "C-c j") 'counsel-git-grep)
;;(global-set-key (kbd "C-c k") 'counsel-ag)
;;(global-set-key (kbd "C-c l") 'counsel-locate)

;;(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
