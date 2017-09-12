;;; init.el --- my custom configuration for emacs

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("gnu" . "https://elpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(defalias 'pi 'package-install)
(defalias 'pl 'package-list-packages)

(add-to-list 'load-path "~/.emacs.d/lisp")
(load "disable-mouse")
(load "desktop-management")

(require 'use-package)
(setq use-package-verbose t)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (progn   (exec-path-from-shell-copy-env "GOPATH")
	   (exec-path-from-shell-initialize)))

(use-package markdown-mode
  :ensure t
  :defer t
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
  :bind (("C-a" . crux-move-beginning-of-line)))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package go-mode
  :defer t
  :ensure t
  :mode ("\\.go$" . go-mode))

;; (use-package color-moccur
;;   :commands (isearch-moccur isearch-all)
;;   :bind (("M-s O" . moccur)
;;          :map isearch-mode-map
;;          ("M-o" . isearch-moccur)
;;          ("M-O" . isearch-moccur-all))
;;   :init
;;   (setq isearch-lazy-highlight t)
;;   :config
;;   (use-package moccur-edit))

(use-package company-go
  :ensure t)

(use-package flycheck
  :ensure t
  :config
  (progn
    (global-flycheck-mode)
    (add-to-list 'load-path "~/goprojects/src/github.com/dougm/goflymake")
    (require 'go-flycheck)))

;;; 뭔가 잘못되었을때 helm 이 켜져 있으면 엄청 짜증난다. 마지막에 켜도록 하자
(use-package helm
  :ensure t
  :bind (("C-x C-f" . helm-find-files)
         ("C-x f" . helm-recentf)
         ("M-y" . helm-show-kill-ring)
	 ("M-x" . helm-M-x)
         ("C-x b" . helm-buffers-list))
  :config (progn
	    (setq helm-buffers-fuzzy-matching t)
	    (helm-mode 1)))

(use-package helm-descbinds
  :ensure t
  :bind ("C-h b" . helm-descbinds))

(use-package company-tern
  :ensure t
  :config (progn
	    (add-hook 'js-mode-hook (lambda () (tern-mode t)))
	    (add-to-list 'company-backends 'company-tern)))

(use-package smartparens
  :ensure t
  :init
  (progn (require 'smartparens-config)
	 (smartparens-global-mode t)
	 (show-smartparens-global-mode t))
  :config
  (progn (sp-use-smartparens-bindings))
  :bind (:map smartparens-mode-map ("M-<backspace>" . nil)))

;;(define-key smartparens-mode-map (kbd "M-<backspace>") nil)

;;(add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
;;(add-hook 'markdown-mode-hook 'turn-on-smartparens-strict-mode)

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))
  
; (use-package linum-relative
;   :config 
;   (helm-linum-relative-mode 1)
;   )

;; (show-paren-mode)

(global-set-key (kbd "C-z") 'ignore)

(load "motion-and-kill-dwim")
(load "motion-and-kill-dwim-key-binding")
