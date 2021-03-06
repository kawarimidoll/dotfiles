# -----------------
#  Common setting
# -----------------
__source() {
  [ -f $1 ] && source $1
}
__add_fpath() {
  [ -e $1 ] && fpath=($1 $fpath)
}

export DOT_DIR="${HOME}/dotfiles"
shell_rc="${HOME}/.zshrc"
__source "${DOT_DIR}/etc/commonshrc"

# -----------------
#  Modules
# -----------------
__add_fpath "~/.zsh/completion"
autoload -Uz compinit
compinit -u

autoload -Uz zmv
autoload -Uz colors && colors

# -----------------
#  Alias
# -----------------
alias zmv='noglob zmv -W'

alias -g CP='| tee >(pbcopy)'
alias -g F='| fzf'
alias -g G='| grep'
alias -g H='| head'
alias -g J='| jq'
alias -g L='| less -R'
alias -g S='| sort'
alias -g T='| tail'
alias -g V='| view'
alias -g X='| xargs'
alias -g NOTIFY="&& osascript -e 'display notification \"Done!\" with title \"Terminal\"'"

# 独自コマンド
# findで明らかに検索しなくて良さそうなものを対象から外す
fnd () {
  find "$1" -mindepth 1 -type d \( -name 'node_modules' -o -name '.*' \) -prune -o -type f -not -name '.DS_Store' "${@:2}" -print
}
# json format
jf () {
  jq < "$1" > "pretty-$1"
  mv "pretty-$1" "$1"
}
# json lint (need specific file input)
jl () {
  docker container run --rm -v "${PWD}:/data" cytopia/jsonlint "$1"
}
# yaml lint (all files in current directory)
yl () {
  docker container run --rm -it -v "${PWD}:/data" cytopia/yamllint .
}

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
setopt interactive_comments # コンソールでも#をコメントと解釈
# setopt ksh_arrays # 配列の添字を0から開始 むしろなんでzshは1から始まる設定なの…
setopt nonomatch # 引数の#とかをファイル名として認識するのを防止
setopt print_eight_bit # 日本語ファイル名を表示する
setopt share_history # 同時に起動しているzshの間でhistoryを共有する

# -----------------
#  Zstyles
# -----------------
# 補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# docker補完の設定
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# 現在のディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sodoの後ろでコマンドを補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin

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

oneliners() {
  local oneliner=$(__get_oneliners) || return 1
  local cursol="${oneliner%%@*}"
  BUFFER="${oneliner/@/}"
  CURSOR="${#cursol}"
  zle redisplay
}
zle -N oneliners
bindkey '^x' oneliners

# -----------------
#  PATH
# -----------------
# PATH="/path/to/the/directory:$PATH"

# -----------------
#  prompt
# -----------------
if has "starship"; then
  eval "$(starship init zsh)"
else
  __ps_git_br() {
    local exit=$?
    echo $(git current-branch 2>/dev/null)
    return $exit
  }
  nl=$'\n'
  PROMPT="${nl}%c %{${fg[green]}%}$(__ps_git_br)%{${reset_color}%}${nl}%{%(?.${fg[cyan]}.${fg[red]})%}%#%{${reset_color}%} "
fi

# -----------------
#  velociraptor
# -----------------
if has 'vr'; then
  source <(vr completions zsh)
fi

# -----------------
#  Local Setting
# -----------------
__source ~/.zshrc.local

:
