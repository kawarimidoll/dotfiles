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
