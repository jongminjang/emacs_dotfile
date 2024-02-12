;;; Init.el --- my custom configuration for emacs  -*- lexical-binding: t; -*-

(setq inhibit-splash-screen t)
(add-to-list 'default-frame-alist '(height . 54))
(add-to-list 'default-frame-alist '(width . 150))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(set-language-environment "Korean")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(global-display-line-numbers-mode)
(line-number-mode)
(column-number-mode)

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

(use-package expand-region
  :ensure t
  :bind
  (("C-c =" . er/expand-region)))

(use-package multiple-cursors
  :ensure t
  :bind
  ("C-c l" . mc/edit-lines)
  ("C-c n" . mc/mark-next-like-this))

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
;; (use-package helm
;;   :ensure t
;;   :init (progn
;;       (setq helm-buffers-fuzzy-matching t)
;;       (helm-mode 1)
;;       )
;;   :bind (("C-x C-f" . helm-find-files)
;;          ("C-x f" . helm-recentf)
;;          ("M-y" . helm-show-kill-ring)
;;       	 ("M-x" . helm-M-x)
;;          ("C-x b" . helm-buffers-list)))

;; (use-package helm-descbinds
;;   :ensure t
;;   :bind ("C-h b" . helm-descbinds)
;;   :config
;; )

(use-package ivy
  :ensure t
  :config
  (progn 
    (ivy-mode)
    (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t)
    (setq ivy-count-format "(%d/%d)")
    ;; enable this if you want `swiper' to use it
    ;; (setq search-default-mode #'char-fold-to-regexp)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
    (global-set-key (kbd "<f1> l") 'counsel-find-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
    ))

(use-package counsel
  :ensure t
  :config
  (progn (counsel-mode 1)
	 ))

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
  (progn 
	 (global-undo-tree-mode)
	 (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
	 ))
  
;; optional if you want which-key integration
;; (use-package which-key
;;     :config
;;     (which-key-mode))


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



(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))

;; (use-package lsp-mode
;;   :init
;;   ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;;   (setq lsp-keymap-prefix "C-c l")
;;   :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;;          (js-mode . lsp)
;; 	 (typescript-ts-base-mode . lsp)
;;          ;; if you want which-key integration
;;          (lsp-mode . lsp-enable-which-key-integration))
;;   :commands lsp)

;; ;; optionally
;; (use-package lsp-ui :commands lsp-ui-mode)
;; ;; if you are helm user
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)

;; ;;(add-hook 'typescript-ts-base-mode-hook 'lsp)

(add-hook 'js-ts-mode-hook 'eglot-ensure)
(add-hook 'js-jsx-mode-hook 'eglot-ensure)
(add-hook 'typescript-ts-base-mode-hook 'eglot-ensure)



(use-package zenburn-theme
  :ensure t
  :config (progn (load-theme 'zenburn)
		 (set-face-attribute 'region nil :background "#666")))

(global-set-key (kbd "C-z") 'ignore)

(load "motion-and-kill-dwim")
(load "motion-and-kill-dwim-key-binding")

(defhydra smartparens-hydra ()
            "Smartparens"
            ("d" sp-down-sexp "Down")
            ("e" sp-up-sexp "Up")
            ("u" sp-backward-up-sexp "Backward Up")
            ("a" sp-backward-down-sexp "Backward Down")
            ("f" sp-forward-sexp "Forward")
            ("b" sp-backward-sexp "Backward")
	    ("n" sp-next-sexp "Next")
	    ("p" sp-previous-sexp "Previous")
            ("k" sp-kill-sexp "Kill" :color blue)
            ("q" nil "Quit" :color blue))



(use-package smart-mode-line
  :ensure t
  :config (progn
	    (setq sml/theme 'respectful)
	    (smart-mode-line-enable)
	    ))

(use-package prescient
  :ensure t)
(use-package ivy-prescient
  :ensure t)
(use-package company-prescient
  :ensure t)

(use-package projectile
  :ensure t
  :config (progn
	    (projectile-mode +1)
	    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)))

;;; end of doc

