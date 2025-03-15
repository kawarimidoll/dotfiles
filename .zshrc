# -----------------
#  Common setting
# -----------------
__source() {
  [ -s $1 ] && source $1
}
__add_fpath() {
  [ -e $1 ] && fpath=($1 $fpath)
}

export DOT_DIR="${HOME}/dotfiles"
# shell_rc="${HOME}/.zshrc"
__source "${DOT_DIR}/.config/sh/settings.sh"

# -----------------
#  Modules
# -----------------
# __add_fpath "~/.zsh/completion"
# autoload -Uz compinit
# compinit -u
#
# autoload -Uz zmv
autoload -Uz colors && colors

# -----------------
#  Alias
# -----------------
# alias zmv='noglob zmv -W'

# # ref: https://grml.org/zsh/zsh-lovers.html
# # `|&` is shorthand for `2>&1 |`, this connects not only stdout, but also stderr.
# alias -g C='| wc -l'
# alias -g CP='| tee >(pbcopy)'
# alias -g D='DISPLAY=:0.0'
# alias -g DN=/dev/null
# alias -g ED='export DISPLAY=:0.0'
# alias -g EG='|& egrep'
# alias -g EH='|& head'
# alias -g EL='|& less'
# alias -g ELS='|& less -S'
# alias -g ET='|& tail'
# alias -g ETL='|& tail -20'
# alias -g F='| fzf'
# alias -g FMT='| fmt -'
# alias -g G='| egrep'
# alias -g H='| head'
# alias -g HL='|& head -20'
# alias -g J='| jq'
# alias -g L='| less -R'
# alias -g LL='2>&1 | less'
# alias -g LS='| less -S'
# alias -g M='| more'
# alias -g MM='| most'
# alias -g NE='2> /dev/null'
# alias -g NS='| sort -n'
# alias -g NUL='> /dev/null 2>&1'
# alias -g PIPE='|'
# alias -g R=' > /c/aaa/tee.txt'
# alias -g RNS='| sort -nr'
# alias -g S='| sort'
# alias -g Sk='*~(*.bz2|*.gz|*.tgz|*.zip|*.z)'
# alias -g T='| tail'
# alias -g TL='| tail -20'
# alias -g US='| sort -u'
# alias -g V='| view'
# alias -g VM=/var/log/messages
# alias -g X0='| xargs -0'
# alias -g X0G='| xargs -0 egrep'
# alias -g X='| xargs'
# alias -g XG='| xargs egrep'

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
# setopt hist_ignore_all_dups # 同じコマンドをhistoryに残さない
# setopt hist_ignore_dups # 同じコマンドをhistoryに残さない
# setopt hist_ignore_space # スペースから始まるコマンドをhistoryに残さない
setopt hist_no_store # historyコマンドをhistoryに残さない
setopt hist_reduce_blanks # historyに保存するときに余分なスペースを削除する
setopt hist_save_no_dups # 同じコマンドをhistoryに残さない
setopt hist_verify # historyを使用時に編集
setopt interactive_comments # コンソールでも#をコメントと解釈
# setopt ksh_arrays # 配列の添字を0から開始 むしろなんでzshは1から始まる設定なの…
setopt nonomatch # 引数の#とかをファイル名として認識するのを防止
setopt print_eight_bit # 日本語ファイル名を表示する
# setopt share_history # 同時に起動しているzshの間でhistoryを共有する

# -----------------
#  Zstyles
# -----------------
# キャッシュファイルの場所
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"

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

# https://tech-blog.sgr-ksmt.org/2016/12/10/smart_fzf_history/
__get_histories() {
  history -n -r 1 | \
    fzf --no-sort +m --query "$LBUFFER" --prompt="History > "
}

select-history() {
  BUFFER=$(__get_histories) || return 1
  CURSOR="${#BUFFER}"
  zle redisplay
}
zle -N select-history
bindkey '^r' select-history

# -----------------
#  Functions
# -----------------
# [zshのコマンドラインを任意のテキストエディタで編集する - Qiita](https://qiita.com/mollifier/items/7b1cfe609a7911a69706)
autoload -Uz edit-command-line
zle -N edit-command-line
edit_current_line() {
  EDITOR="vim -c 'norm! G$' -c 'setl awa' -c 'setf zsh'" \
    zle edit-command-line
}
zle -N edit_current_line
bindkey '^xe' edit_current_line
bindkey '^x^e' edit_current_line

oneliners() {
  local oneliner=$(__get_oneliners) || return 1
  local cursol="${oneliner%%@*}"
  BUFFER="${oneliner/@/}"
  CURSOR="${#cursol}"
  zle redisplay
}
zle -N oneliners
bindkey '^xo' oneliners
bindkey '^x^o' oneliners

# [zshで特定のコマンドをヒストリに追加しない条件を柔軟に設定する - mollifier delta blog](https://mollifier.hatenablog.com/entry/20090728/p1)
zshaddhistory() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}

  # 以下の条件をすべて満たすものだけをヒストリに追加する
  # 全体が5字以上である
  # コマンドが存在する
  # 特定のコマンドではない
  [[ ${#line} -ge 5
    && "$(command -v $cmd)" != ''
    && ${cmd} != (man|cd|mv|cp|rm|brew|rgf|nv|nvim|vi|vim|ma)
  ]]
}
# -----------------
#  PATH
# -----------------
export HISTFILE="${XDG_STATE_HOME}/zsh/history.zsh"

# -----------------
#  prompt
# -----------------
if has "starship"; then
  # [zsh の起動速度を改善した](https://zenn.dev/ktakayama/articles/27b9d6218ed2f0ee9992)
  if [ ! -f /tmp/zsh_starship.cache ]; then
    starship init zsh > /tmp/zsh_starship.cache
    zcompile /tmp/zsh_starship.cache
  fi
  source /tmp/zsh_starship.cache
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
#  direnv
# -----------------
if has 'direnv'; then
  if [ ! -f /tmp/zsh_direnv.cache ]; then
    direnv hook zsh > /tmp/zsh_direnv.cache
    zcompile /tmp/zsh_direnv.cache
  fi
  source /tmp/zsh_direnv.cache
  # source <(direnv hook zsh)
fi

# Set tab name of kitty https://github.com/kovidgoyal/kitty/issues/930
precmd () { print -Pn "\e]0;%~\a" }

compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

# -----------------
#  tabtab completion
# -----------------
# uninstall by removing these lines
__source ~/.config/tabtab/zsh/__tabtab.zsh

# -----------------
#  Local Setting
# -----------------
__source ~/.zshrc.local

:
