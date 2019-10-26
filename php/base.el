;; Put follow code into init.el
(when (file-directory-p (concat user-emacs-directory "php/php-mode"))
  (load (concat user-emacs-directory "php/php-mode/php-mode-autoloads.el")))
  
(when (file-directory-p (concat user-emacs-directory "php/company-mode"))
      (load (concat user-emacs-directory "php/company-mode/company.el")))

(unless (package-installed-p 'ac-php)
    (package-refresh-contents)
    (package-install 'ac-php))


(defun my-php-mode-stan ()
  "My PHP-mode hook."
  (require 'flycheck-phpstan)
  (global-flycheck-mode t))

(add-hook 'php-mode-hook 'my-php-mode-stan)

;;auto-completion
(require 'php-mode)			

(add-hook 'php-mode-hook 'php-enable-psr2-coding-style)


(require 'phpcbf)


(custom-set-variables
 '(phpcbf-executable "/usr/bin/phpcbf")
 '(phpcbf-standard "PSR2"))

;; Auto format on save.
(add-hook 'php-mode-hook 'phpcbf-enable-on-save)


(add-hook 'php-mode-hook
          '(lambda ()
             ;; Enable auto-complete-mode
             (auto-complete-mode t)
             (require 'ac-php)
             (setq ac-sources '(ac-source-php))

             ;;(company-mode t)
	     ;; Enable company-mode
            ;; (require 'company-php)
	     
             ;; As an example (optional)
             (yas-global-mode 1)

             ;; Enable ElDoc support (optional)
             (ac-php-core-eldoc-setup)

	     ;; (set (make-local-variable 'company-backends)
             ;;      '((company-ac-php-backend company-dabbrev-code)
             ;;        company-capf company-files))
	     
             ;; Jump to definition (optional)
             (define-key php-mode-map (kbd "M-]")
               'ac-php-find-symbol-at-point)

             ;; Return back (optional)
             (define-key php-mode-map (kbd "M-[")
               'ac-php-location-stack-back)))
