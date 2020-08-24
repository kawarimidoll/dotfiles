# -----------------
#  Common setting
# -----------------
__source() {
  [ -f $1 ] && source $1
}

export DOT_DIR="${HOME}/dotfiles"
__source "${DOT_DIR}/etc/commonrc.sh"

# -----------------
#  zsh-completions
# -----------------
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
autoload -U compinit
compinit -u

# -----------------
#  Alias
# -----------------
alias she='vim ~/.zshrc'
alias shs='source ~/.zshrc'

alias -g F='| fzf'
alias -g G='| grep'
alias -g J='| jq'
alias -g L='| less'
alias -g X='| xargs'

# 独自コマンド
# findで明らかに検索しなくて良さそうなものを対象から外す
fnd () {
  find $1 -mindepth 1 -type d \( -name 'node_modules' -o -name '.*' \) -prune -o -type f -not -name '.DS_Store' ${@:2} -print
}
# json format
jf () { cat $1 | jq > pretty-$1; mv pretty-$1 $1 }
# json lint (need specific file input)
jl () { docker container run --rm -v $(pwd):/data cytopia/jsonlint $1 }
# yaml lint (all files in current directory)
yl () { docker container run --rm -it -v $(pwd):/data cytopia/yamllint . }

# -----------------
#  Options
# -----------------
setopt auto_list # 補完候補を一覧表示に
setopt auto_menu # 補完候補をtabで選択
setopt bsd_echo # echoをbash互換にする なおデフォルトはecho -eに相当
setopt correct # コマンドのスペルミスを指摘
setopt hist_ignore_all_dups # 同じコマンドをhistoryに残さない
setopt hist_ignore_dups # 同じコマンドをhistoryに残さない
setopt hist_ignore_space # スペースから始まるコマンドをhistoryに残さない
setopt hist_no_store # historyコマンドをhistoryに残さない
setopt hist_reduce_blanks # historyに保存するときに余分なスペースを削除する
setopt hist_save_no_dups # 同じコマンドをhistoryに残さない
setopt hist_verify # historyを使用時に編集
# setopt ksh_arrays # 配列の添字を0から開始 むしろなんでzshは1から始まる設定なの…
setopt nonomatch # 引数の#とかをファイル名として認識するのを防止
setopt print_eight_bit # 日本語ファイル名を表示する
setopt share_history # 同時に起動しているzshの間でhistoryを共有する

# 補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# -----------------
#  FZF
# -----------------
__source ~/.fzf.zsh

# -----------------
#  Functions
# -----------------
# [Terminalの現在行をエディタで編集して実行する - ハイパーマッスルエンジニアになりたい](https://www.rasukarusan.com/entry/2020/04/20/083000)
edit_current_line() {
  local tmpfile=$(mktemp)
  echo "$BUFFER" > $tmpfile
  vim $tmpfile -c "normal $" -c "set filetype=zsh"
  BUFFER="$(cat $tmpfile)"
  CURSOR=${#BUFFER}
  rm $tmpfile
  zle reset-prompt
}
zle -N edit_current_line
bindkey '^w' edit_current_line

# -----------------
#  PATH
# -----------------
# PATH="/path/to/the/directory:$PATH"

# -----------------
#  starship🚀
# -----------------
eval "$(starship init zsh)"

# -----------------
#  OS Setting
# -----------------
OS='unknown'
if [[ "$(uname)" = "Darwin" ]]; then
  OS='mac'
elif [[ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]]; then
  OS='windows'
elif [[ "$(expr substr $(uname -s) 1 5)" = "Linux" ]]; then
  OS='linux'
fi
__source "${DOT_DIR}/etc/${OS}/zshrc"

# -----------------
#  Local Setting
# -----------------
__source ~/.zshrc.local
