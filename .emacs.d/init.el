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
(tool-bar-mode nil)
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
