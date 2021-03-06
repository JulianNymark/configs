;;--------------------------------[ GENERAL ]--------------------------------;;

;; stuff
(setq echo-keystrokes 0.1)
(setq use-dialog-box 0)

;; init stuff
(setq inhibit-splash-screen 1
      initial-scratch-message nil)

;; backup in one place. flat, no tree structure
(unless (file-exists-p "~/.emacs.d/emacs-autosave")
  (make-directory "~/.emacs.d/emacs-autosave/"))
(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs.d/emacs-backup"))
      auto-save-file-name-transforms '((".*" "~/.emacs.d/emacs-autosave/" t)))

;; y-or-n
(defalias 'yes-or-no-p 'y-or-n-p)

;; del selected stuff when type
(delete-selection-mode 1)

;; lisp
(setq inferior-lisp-program "sbcl")

;; enable some spooky "advaced" features
(put 'upcase-region 'disabled nil)

;; j keybindings
(load-file "~/.emacs.d/j-kbd.el")

;; extra .el
;; (add-to-list 'load-path "~/.emacs.d/extras/")

;;--------------------------------[ PACKAGES ]--------------------------------;;
(require 'package)
                                        ; list the packages you want
(setq package-list '(web-mode multiple-cursors paredit go-mode lua-mode less-css-mode markdown-mode yaml-mode dockerfile-mode systemd ace-jump-mode emmet-mode magit origami editorconfig))
                                        ; list the repositories containing them
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ;;("marmalade" . "http://marmalade-repo.org/packages/")
                         ;;("elpa" . "http://tromey.com/elpa/")
                         ))

;; activate all the packages (in particular autoloads)
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;;--------------------------------[ HOOKS ]--------------------------------;;
;; delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; minibuffer paredit (if in list of paredit-minibuffer-commands)
(add-hook 'minibuffer-setup-hook 'conditionally-enable-paredit-mode)
(defun conditionally-enable-paredit-mode ()
  "enable paredit-mode during eval-expression"
  (if (memq this-command '(eval-expression
                           slime-interactive-eval))
      (paredit-mode 1)))

(add-hook 'emacs-lisp-mode-hook       'enable-paredit-mode)
(add-hook 'lisp-mode-hook             'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook           'enable-paredit-mode)

(defun my-sql-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (setq indent-line-function 'insert-tab)  )
(add-hook 'sql-mode-hook 'my-sql-mode-hook)

(defun stricter-bash ()
  (interactive)
  (save-excursion
    (let ((first-characters (buffer-substring-no-properties 1 (min 38 (+ 1 (buffer-size))))))
      ;; (message first-characters)
      (if (string-match "bash" first-characters)
          (if (not (string= first-characters "#!/usr/bin/env bash\nset -euo pipefail"))
              (progn
                (goto-char 0)
                (insert "#!/usr/bin/env bash\nset -euo pipefail\n"))
            )))))
(defun my-bash-mode-hook ()
  (add-hook 'before-save-hook 'stricter-bash))
(add-hook 'sh-mode-hook 'my-bash-mode-hook)

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook 'subword-mode)
(add-hook 'go-mode-hook 'origami-mode)

(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.cl\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.love\\'" . lua-mode))
(add-to-list 'auto-mode-alist '("\\.pde\\'" . java-mode))
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))

(add-to-list 'auto-mode-alist '("\\.sql$" .
                                (lambda ()
                                  (sql-mode)
                                  (sql-highlight-postgres-keywords))))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.handlebars\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.scss?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\`.*/COMMIT_" . diff-mode))
(add-to-list 'auto-mode-alist '("\\.csv\\'" . whitespace-mode))

(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("php"    . "\\.php\\'")
        ("php"    . "\\.html\\'")
        ("blade"  . "\\.blade\\.")))

(setq web-mode-content-types-alist
      '(("jsx" . "\\.js[x]?\\'")))

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-sql-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)

(setq web-mode-enable-current-column-highlight t)

(require 'emmet-mode)
(add-hook 'web-mode-hook  'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; always whitespace minor mode! (but make it look good)
(add-hook 'prog-mode-hook #'whitespace-mode)

;; py-autopep8
;; (require 'py-autopep8)
;; (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)


;;-------------------------------[ APPEARANCE ]------------------------------;;

;; bell
(setq visible-bell 1)

;; highlight parens
(show-paren-mode 1)

;; numbers n stuff
(line-number-mode 1)
(column-number-mode 1)

;; remove bars
(menu-bar-mode 0)

;; remove GUI bars
(if (display-graphic-p)
    (progn
      (tool-bar-mode 0)
      (scroll-bar-mode 0)
      (menu-bar-mode 0)))

(setq default-frame-alist '((tool-bar-lines 0)
                            (tool-bar-mode 0)
                            (scroll-bar-mode 0)
                            (menu-bar-mode 0)
                            ))

(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

;; font size
(set-face-attribute 'default nil :height 100)

;; smaller tabs (and spacetabs)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; c-style
(setq c-default-style "linux"
      c-basic-offset 4)

;; THEME :D
;;(load-theme 'monokai t)
;;(load-theme 'sanityinc-tomorrow-day t)
;;(load-theme 'github t)
(load-theme 'adwaita t)


;; better region-color
;;(set-face-attribute 'region nil :background "#3a3a3a" :foreground "#fff")

;; don't blink cursor
(blink-cursor-mode 0)

;; whitespace-mode prettify
(setq whitespace-style
      '(face spaces space-before-tab space-after-tab newline tabs tab-mark trailing indentation))
;; list of whitespace-style settings
;;    tabs spaces trailing lines-tail space-before-tab newline indentation
;;    empty space-after-tab space-mark tab-mark newline-mark

;; WS what symbols = what thing? and how they look (characters)
(setq whitespace-display-mappings '((space-mark ?\  [?.])
                                    (newline-mark ?\n [?$ ?\n])
                                    (tab-mark ?\t [?│ ?\t])))

;; set face color & tab-mark color
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-space ((((class color) (background dark)) (:background nil :foreground "#4f4f4b")) (((class color) (background light)) (:background nil :foreground "#dddddd")) (t (:inverse-video t))))
 '(whitespace-tab ((((class color) (background dark)) (:background nil :foreground "#4f4f4b")) (((class color) (background light)) (:background nil :foreground "#dddddd")) (t (:inverse-video t)))))

;;--------------------------------[ EXTRAS ]--------------------------------;;

;; multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-M->") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-M-<") 'mc/skip-to-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c C-SPC") 'mc/mark-pop)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; ace jump mode!
(require 'ace-jump-mode)
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (editorconfig origami github-theme yaml-mode web-mode systemd paredit multiple-cursors monokai-theme markdown-mode lua-mode less-css-mode go-mode emmet-mode dockerfile-mode color-theme-sanityinc-tomorrow ace-jump-mode))))

;; origami-mode
(require 'origami)
(load-file "~/.emacs.d/j-kbd/origami.el")

;; editorconfig
(require 'editorconfig)
(editorconfig-mode 1)
