(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


(defalias 'pi 'package-install)
(defalias 'pl 'package-list-packages)

(require 'use-package)

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-copy-env "GOPATH")
    (exec-path-from-shell-initialize)))

(use-package markdown-mode
  :ensure t
  :config
  (progn
    (push '("\\.text\\'" . markdown-mode) auto-mode-alist)
    (push '("\\.markdown\\'" . markdown-mode) auto-mode-alist)
    (push '("\\.md\\'" . markdown-mode) auto-mode-alist)))

(setq linum-format "%4d")

(defun my-linum-mode-hook ()
  (linum-mode t))

(add-hook 'find-file-hook 'my-linum-mode-hook)


(use-package crux
  :ensure t
  )

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package go-mode
  :ensure t)

(use-package company-go
  :ensure t)

(add-to-list 'load-path "~/.emacs.d/lisp")
(load "disable-mouse")
(load "desktop-management")

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)
  (add-to-list 'load-path "~/goprojects/src/github.com/dougm/goflymake")
  (require 'go-flycheck))

;;; 뭔가 잘못되었을때 helm 이 켜져 있으면 엄청 짜증난다. 마지막에 켜도록 하자
;; (use-package helm
;;   :ensure t
;;   )
;; 
;; (global-set-key (kbd "M-x") #'helm-M-x)
;; (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
;; (global-set-key (kbd "C-x C-f") #'helm-find-files)
;; 
;; (helm-mode 1)
;; 
;; (use-package linum-relative
;;   :config 
;;   (helm-linum-relative-mode 1)
;;   )
