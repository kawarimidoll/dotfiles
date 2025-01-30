;;; ChatGPTによる生成
;; 行番号の表示
(global-display-line-numbers-mode 1)

;; バックアップファイルを作らない
(setq make-backup-files nil)

;; 起動時にホームディレクトリに移動する
(cd "~")

;; スタートアップメッセージを非表示にする
(setq inhibit-startup-message t)

;;; Emacs実践入門
;; c-mにnewline-and-indentを割り当てる（初期値はnewline）
(global-set-key (kbd "C-m") 'newline-and-indent)

;; c-hをバックスペースに
(global-set-key (kbd "C-h") 'delete-backward-char)

;; 折り返しトグル
;(global-set-key (kbd "C-c l") 'toggle-truncate-lines)

;; c-tをウィンドウ移動に
(global-set-key (kbd "C-t") 'other-window)

;; modeline
;; カラム番号
(column-number-mode t)
;; ファイルサイズ
(size-indication-mode t)
;; バッテリー
(display-battery-mode t)
;; 選択行数と文字数 default-mode-line-formatが無いっぽい？有効にならない
;; (defun count-lines-and-chars ()
;;   (if mark-active
;;       (format "(%dlines,%dchars) "
;; 	      (count-lines (region-beginning) (region-end))
;; 	      (- (region-end) (region-beginning)))
;;   ""))
;; (add-to-list 'default-mode-line-format
;; 	     '(:eval (count-lines-and-chars)))

;; titlebar
;; ツールメニュー非表示
(tool-bar-mode 0)
;; フルパス表示
(setq frame-title-format "%f")

;; 行番号非表示 存在しない？
;;(global-linum-mode 0)

;; tab
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
;; (add-hook '___-mode-hook
;; 	  (lambda ()
;; 	    (setq indent-tabs-mode nil)))

;;font
(set-face-attribute 'default nil
		    :family "Menlo"
		    :height 120)
(set-frame-font "UDEV Gothic 35NF-16" nil t)

;; paren-mode
(setq shoe-paren-delay 0) ; default 0.125
(show-paren-mode t)
;; (setq show-paren-style 'expression)
;; (set-face-background 'show-paren-match-face nil)
;; (set-face-underline-p 'show-paren-match-face "darkgreen")

;; backup
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups/"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups/") t)))

;; auto reload
(global-auto-revert-mode t)

;;; hooks
;; auto executable
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)
;; show eldoc
(defun elisp-mode-hooks ()
  "lisp-mode-hooks"
  (when (require 'eldoc nil t)
    (setq eldoc-idle-delay 0.2)
    (setq eldoc-echo-area-use-multiline-p t)
    (turn-on-eldoc-mode)))
(add-hook 'emacs-lisp-mode-hook 'elisp-mode-hooks)

;; cua-mode
(cua-mode t) ; enable common-user-access
(setq cua-enable-cua-keys nil) ; disable cua key binding

;;; package
(require 'package)
;; (add-to-list
;;  'package-archives
;;  '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list
 'package-archives
 '("melpa" . "https://melpa.org/packages/"))

(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(git-gutter magit ac-emoji ac-mozc helm-projectile less-css-mode markdown-mode projectile projectile-ripgrep quickrun sass-mode timesheet web-mode yaml-imenu yaml-mode auto-complete elscreen helm-c-moccur howm point-stack wgrep helm multi-term htmlize)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(load-theme 'modus-operandi t)

;; helm
(require 'helm)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(when (require 'helm-c-moccur nil t)
  (setq
   helm-c-moccur-highlight-info-line-flag t
   helm-c-moccur-enable-auto-look-flag t
   helm-c-moccur-enable-initial-pattern t)
  (global-set-key (kbd "C-M-o") 'helm-c-moccur-occur-by-moccur))

;; color-moccur
(when (require 'color-moccur nil t)
  (global-set-key (kbd "M-o") 'occur-by-moccur)
  (setq moccur-split-word t)
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$"))

;; wgrep
(require 'wgrep nil t)

;; auto-complete-mode
(when (require 'auto-complete-config nil t)
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default)
  (setq ac-use-menu-map t)
  (setq ac-ignore-case nil))

;; howm
(setq howm-directory (concat user-emacs-directory "howm"))
(setq howm-menu-lang 'ja)
;; (setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")
(when (require 'howm-mode nil t)
  (global-set-key (kbd "C-c , ,") 'howm-menu))
(defun howm-save-buffer-and-kill ()
  "save and kill howm memo at the same time"
  (interactive)
  (when (and (buffer-file-name) (howm-buffer-p))
    (save-buffer)
    (kill-buffer nil)))
(define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)

;; git-gutter
(when (require 'git-gutter nil t)
  (global-git-gutter-mode))
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)

;; multi-term
(when (require 'multi-term nil t)
  (setq multi-term-program "/Users/kawarimidoll/.nix-profile/bin/zsh"))

;; woman
(setq woman-cache-filename "~/.emacs.d/womancach.el")
(setq woman-manpath '("/usr/share/man"
                      "/usr/local/share/man"
                      "/usr/local/share/man/ja"))
