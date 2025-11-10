# 基本設定
setopt auto_cd              # ディレクトリ名だけでcd
setopt auto_list            # 補完候補を一覧表示に
setopt auto_menu            # 補完候補をtabで選択
setopt bsd_echo             # echoをbash互換にする なおデフォルトはecho -eに相当
setopt complete_in_word     # 単語の途中でも補完を行う
setopt correct              # コマンドのスペルミスを指摘
setopt extended_glob        # 拡張グロブを有効化
setopt globdots             # 補完時にドットファイルも候補に表示
setopt interactive_comments # コンソールでも#をコメントと解釈
setopt multios              # 複数のリダイレクトを有効化（例: cmd > file1 > file2）
setopt nonomatch            # 引数の#とかをファイル名として認識するのを防止
setopt print_eight_bit      # 日本語ファイル名を表示する
# setopt ksh_arrays # 配列の添字を0から開始 むしろなんでzshは1から始まる設定なの…

# History設定
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh-sheldon/history"
HISTSIZE=10000
SAVEHIST=10000
setopt append_history       # 履歴を追記
setopt hist_ignore_all_dups # 重複を記録しない
setopt hist_ignore_dups     # 重複を記録しない
setopt hist_save_no_dups    # 重複を記録しない
setopt hist_reduce_blanks   # 余分なスペースを削除
setopt hist_ignore_space    # スペースで開始したコマンドを記録しない
setopt hist_verify          # 履歴使用時に編集
setopt share_history        # セッション間で履歴を共有

# Historyディレクトリ作成
mkdir -p "$(dirname "$HISTFILE")"

# [zshで特定のコマンドをヒストリに追加しない条件を柔軟に設定する - mollifier delta blog](https://mollifier.hatenablog.com/entry/20090728/p1)
zshaddhistory() {
  local line=${1%%$'\n'}  # 末尾の改行を削除
  local cmd=${line%% *}   # 最初の単語（コマンド名）を取得

  # 存在しないコマンドをヒストリに追加しない（サブコマンドの存在までは確認されない）
  # 指定したコマンドをヒストリに追加しない
  [[ "$(command -v $cmd)" != '' && ${cmd} != (man|brew|rgf|nv|nvim|vi|vim) ]]
}
