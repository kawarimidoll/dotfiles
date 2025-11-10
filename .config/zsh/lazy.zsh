# zmv with noglob and -W option
autoload -Uz zmv
alias zmv='noglob zmv -W'

# キャッシュファイルの場所
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/zsh/zcompcache"

# 補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 現在のディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudoの後ろでコマンドを補完
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
  /usr/sbin /usr/bin /sbin /bin

bindkey -e
bindkey "^[[Z" reverse-menu-complete # Shift-Tabで補完候補を逆順

bindkey "^P" history-substring-search-up
bindkey "^N" history-substring-search-down

bindkey ' '      zeno-auto-snippet
bindkey '^m'     zeno-auto-snippet-and-accept-line
bindkey '^i'     zeno-completion
bindkey '^x '    zeno-insert-space
bindkey '^x^m'   accept-line
bindkey '^x^z'   zeno-toggle-auto-snippet
bindkey '^r'     zeno-history-selection
bindkey '^x^s'   zeno-insert-snippet
bindkey '^x^f'   zeno-ghq-cd

# [zshのコマンドラインを任意のテキストエディタで編集する - Qiita](https://qiita.com/mollifier/items/7b1cfe609a7911a69706)
autoload -Uz edit-command-line
zle -N edit-command-line
edit_current_line() {
  EDITOR="vim -c 'norm! G$' -c 'setl awa'" zle edit-command-line
}
zle -N edit_current_line
bindkey '^xe' edit_current_line
bindkey '^x^e' edit_current_line

oneliners() {
  local oneliner=$(__get_oneliners) || return 1
  # ZLEコンテキストかどうかを判定
  if zle; then
    # ZLEウィジェットとして動作：現在のバッファに挿入
    local before_cursor="${oneliner%%__CURSOR__*}"
    BUFFER="${oneliner//__CURSOR__/}"
    CURSOR="${#before_cursor}"
    zle redisplay
  else
    # 通常コマンドとして動作：次のプロンプトに挿入
    print -z "${oneliner//__CURSOR__/}"
  fi
}
zle -N oneliners
bindkey '^xo' oneliners
bindkey '^x^o' oneliners
