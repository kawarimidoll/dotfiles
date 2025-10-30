# -----------------
#  Common setting
# -----------------
__source() {
  [ -s $1 ] && source $1
}
# __add_fpath() {
#   [ -e $1 ] && fpath=($1 $fpath)
# }

export DOT_DIR="${HOME}/dotfiles"
shell_rc="${ZDOTDIR:-HOME}/.zshrc"
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

# -----------------
#  Zstyles
# -----------------
# キャッシュファイルの場所
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"

# 補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 現在のディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudoの後ろでコマンドを補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin

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
  local cursol="${oneliner%%__CURSOR__*}"
  BUFFER="${oneliner//__CURSOR__/}"
  CURSOR="${#cursol}"
  zle redisplay
}
zle -N oneliners
bindkey '^xo' oneliners
bindkey '^x^o' oneliners

# [zshで特定のコマンドをヒストリに追加しない条件を柔軟に設定する - mollifier delta blog](https://mollifier.hatenablog.com/entry/20090728/p1)
# [zshのhistoryに実行に失敗したコマンドを残さない](https://zenn.dev/shinespark/articles/33271e065af623)
zshaddhistory() {
  local cmd=${line%% *}

  # 以下の条件をすべて満たすものだけをヒストリに追加する
  # 成功した
  # 特定のコマンドではない
  [[ "$?" == 0
    && ${cmd} != (man|cd|mv|cp|rm|brew|rgf|nv|nvim|vi|vim|ma)
  ]]

  # 文字数で制限を持たせていたがやめた
  # local line=${1%%$'\n'}
  # [[ ${#line} -ge 5 ]]

  # コマンド存在確認を入れていたがサブコマンドの存在までは確認されないのでやめた
  # [["$(command -v $cmd)" != '']]
}

# Set tab name of kitty https://github.com/kovidgoyal/kitty/issues/930
precmd () { print -Pn "\e]0;%~\a" }

# -----------------
#  Local Setting
# -----------------
__source ~/.zshrc.local

:
