(use-package prolog
  :ensure t)

(setq prolog-system 'swi)

(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode))
                               auto-mode-alist))
