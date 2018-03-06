;;; init.el --- my custom configuration for emacs

(setq inhibit-splash-screen t)
(add-to-list 'default-frame-alist '(height . 54))
(add-to-list 'default-frame-alist '(width . 100))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(set-language-environment "Korean")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(defalias 'pi 'package-install)
(defalias 'pl 'package-list-packages)

(add-to-list 'load-path "~/.emacs.d/lisp")
(if (memq window-system '(mac ns))
(load "disable-mouse"))
(load "desktop-management")

;; use-package에 빈 config가 있는것은
;; config가 있어야만 실행되었음을 알리는 메시지가 나오기 때문에
;; caveman debugging을 하기 위해 내가 넣어 둔 것이다.
(require 'use-package)
(setq use-package-verbose t)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (progn
     (add-to-list 'exec-path-from-shell-variables "GOPATH")
     (add-to-list 'exec-path-from-shell-variables "LANG")
	   (exec-path-from-shell-initialize)
     ))

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

(use-package expand-region
  :ensure t
  :bind
  (("C-=" . er/expand-region)))

(use-package multiple-cursors
  :ensure t
  :bind
  ("C-S-c C-S-c" . mc/edit-lines)
  ("C->" . mc/mark-next-like-this))

(use-package crux
  :ensure t
  :bind
  ("C-a" . crux-move-beginning-of-line)
  ("M-o" . crux-smart-open-line)
  ("M-O" . crux-smart-open-line-above))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package go-mode
  :defer t
  :ensure t
  :config (progn
	    (add-hook 'go-mode-hook
		      (lambda()
			;; goimports
			(setq gofmt-command "goimports")
			(require 'go-guru)
			(go-guru-hl-identifier-mode)
			(set (make-local-variable 'company-backends) '(company-go))))
	    (add-hook 'before-save-hook 'gofmt-before-save))
  :mode ("\\.go$" . go-mode))

;; go get   golang.org/x/tools/cmd/guru
(use-package go-guru
  :ensure t
  :defer t)

(use-package go-eldoc
  :ensure t
  :defer t
  :init (add-hook 'go-mode-hook 'go-eldoc-setup))

;; go get -u github.com/nsf/gocode
(use-package company-go
  :init
  ;; (progn
  ;;   (add-hook
  ;;    'go-mode-hook
  ;;    (lambda()
  ;;      (set (make-local-variable 'company-backends) '(company-go)))))
  :ensure t
  :defer t)

;; company for javascript
(use-package company-tern
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'js-mode-hook (lambda ()
      (tern-mode t)
      (add-to-list 'company-backends 'company-tern))))
  )

;; gometalinter
;; go get -u gopkg.in/alecthomas/gometalinter.v1
;; make link gometalinter that refers .v1
;; gometalinter --install
(use-package flycheck-gometalinter
  :ensure t
  :defer t
  :config
  ;; (progn (setq flycheck-gometalinter-disable-all t)
  ;; 		 (flycheck-gometalinter-setup))
  (flycheck-gometalinter-setup)
  :init
  ;; skips 'vendor' directories and sets GO15VENDOREXPERIMENT=1
  (setq flycheck-gometalinter-vendor t)
  ;; only show errors
  (setq flycheck-gometalinter-errors-only t)
  ;; only run fast linters
  (setq flycheck-gometalinter-fast t)
  ;; use in tests files
  (setq flycheck-gometalinter-test t)
  ;; disable linters
  (setq flycheck-gometalinter-disable-linters '("gotype" "gocyclo"))
  ;; Only enable selected linters
  (setq flycheck-gometalinter-disable-all t)
  (setq flycheck-gometalinter-enable-linters '("golint"))
  ;; Set different deadline (default: 5s)
  (setq flycheck-gometalinter-deadline "10s")
  ;; (progn
  ;;   (add-hook 'go-mode-hook 'flycheck-gometalinter-setup))
  )

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

(use-package magit
  :ensure t
  :defer t)

(use-package flycheck
  :ensure t
  :defer t
  :init
  (progn (add-hook 'prog-mode-hook 'flycheck-mode))
  :config
  (progn
    ;;(global-flycheck-mode)
    ))

;;; 뭔가 잘못되었을때 helm 이 켜져 있으면 엄청 짜증난다. 마지막에 켜도록 하자
;; bind 된 명령이 실행되는 시점에 helm이 로딩되고 config가 수행된다.
(use-package helm
  :ensure t
  :init (progn
      (setq helm-buffers-fuzzy-matching t)
      (helm-mode 1)
      )
  :bind (("C-x C-f" . helm-find-files)
         ("C-x f" . helm-recentf)
         ("M-y" . helm-show-kill-ring)
      	 ("M-x" . helm-M-x)
         ("C-x b" . helm-buffers-list)))

(use-package helm-descbinds
  :ensure t
  :bind ("C-h b" . helm-descbinds)
  :config
)

(use-package smartparens
  :ensure t
  :init (progn (require 'smartparens-config)
	       (smartparens-global-mode t)
	       (show-smartparens-global-mode t))
  :config (progn (sp-use-smartparens-bindings))
  ;; smartparens에서 M-<backspace>가 unwrap 함수를 수행하는건
  ;; 아무래도 적응이 안된다. 그래서 제거한다.
  :bind (:map smartparens-mode-map
	      ("M-<backspace>" . nil)
	      ("C-c C-u" . sp-unwrap-sexp)
	      ("C-c M-<backspace>" . sp-unwrap-sexp)
	      ("C-c C-<backspace>" . sp-unwrap-sexp)))

;;(define-key smartparens-mode-map (kbd "M-<backspace>") nil)

;;(add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
;;(add-hook 'markdown-mode-hook 'turn-on-smartparens-strict-mode)

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))
  

;; (show-paren-mode)

(use-package nodejs-repl
  :ensure t
  :defer t)

(use-package web-mode
  :ensure t
  :defer t
  :init (progn (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
		 (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
		 (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
		 (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
		 (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
		 (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
		 (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
		 (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))))

(use-package zenburn-theme
  :ensure t
  :config (progn (load-theme 'zenburn)
		 (set-face-attribute 'region nil :background "#666")))

(global-set-key (kbd "C-z") 'ignore)

(load "motion-and-kill-dwim")
(load "motion-and-kill-dwim-key-binding")
