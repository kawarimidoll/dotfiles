source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

HELPDIR="${HOME}/.nix-profile/share/zsh/${ZSH_VERSION}/help"

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

# 区切り文字としたい記号をWORDCHARSから除く
# vimでいうiskeywordの逆
# M-f, M-b, ^w などの動作に影響する
typeset -g WORDCHARS="${WORDCHARS//[\/=]/}"

bindkey -e
bindkey "^[[Z" reverse-menu-complete # Shift-Tabで補完候補を逆順

bindkey "^P" history-substring-search-up
bindkey "^N" history-substring-search-down

# c-[/c-]でvimのf/Fのように文字検索
bindkey '^]' vi-find-next-char
bindkey '^[' vi-find-prev-char

bindkey ' '      zeno-auto-snippet
bindkey '^m'     zeno-auto-snippet-and-accept-line
bindkey '^i'     zeno-completion
bindkey '^x '    zeno-insert-space
bindkey '^x^m'   accept-line
bindkey '^x^z'   zeno-toggle-auto-snippet
bindkey '^r'     zeno-smart-history-selection
bindkey '^x^a'   zeno-insert-snippet
# bindkey '^x^f'   zeno-ghq-cd

# ghq + fzf でリポジトリに移動
ghq-cd-widget() {
local dir
dir=$(ghq list | fzf --no-multi --exit-0 --preview="ls -FA1 $(ghq root)/{}")
if [ -n "$dir" ]; then
  BUFFER="cd $(ghq root)/$dir"
  zle redisplay
  zle accept-line
else
  zle redisplay
fi
}
zle -N ghq-cd-widget
bindkey '^x^f' ghq-cd-widget

# [zshのコマンドラインを任意のテキストエディタで編集する - Qiita](https://qiita.com/mollifier/items/7b1cfe609a7911a69706)
autoload -Uz edit-command-line
zle -N edit-command-line
edit_current_line() {
  EDITOR="vim -c 'setl awa|norm!G$'" zle edit-command-line
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

# カスタムZLEウィジェット
# 参考: zshで範囲選択・削除・コピー・切り取りする - Qiita
# https://qiita.com/takc923/items/35d9fe81f61436c867a8

# quote-word: カーソル位置の単語をクォート
quote-word() {
  zle select-a-word
  zle quote-region
}
zle -N quote-word

# backward-delete-char-or-region: 選択中は範囲削除、通常時はautopair-delete
backward-delete-char-or-region() {
  if [ $REGION_ACTIVE -eq 0 ]; then
    zle autopair-delete
  else
    zle kill-region
  fi
}
zle -N backward-delete-char-or-region

# autopairプラグインの後で上書きする必要があるため、zsh-deferで遅延バインド
zsh-defer bindkey '^h' backward-delete-char-or-region

# delete-char-or-region: 選択中は範囲削除、通常時は直後の1文字削除
delete-char-or-region() {
  if [ $REGION_ACTIVE -eq 0 ]; then
    zle delete-char
  else
    zle kill-region
  fi
}
zle -N delete-char-or-region
bindkey '^d' delete-char-or-region

# backward-kill-word-or-region: 選択中は範囲切り取り、通常時は単語切り取り
backward-kill-word-or-region() {
  if [ $REGION_ACTIVE -eq 0 ]; then
    zle autopair-delete-word
  else
    zle kill-region
  fi
}
zle -N backward-kill-word-or-region

# autopairプラグインの後で上書きする必要があるため、zsh-deferで遅延バインド
zsh-defer bindkey '^w' backward-kill-word-or-region

# backward-kill-to-space: 直前の空白まで削除（Vimの WORD 削除に相当）
backward-kill-to-space() {
  # 末尾の空白文字を全て削除（## = 1回以上の最長マッチ）
  LBUFFER=${LBUFFER%%[[:space:]]##}
  # 末尾の非空白文字を全て削除
  LBUFFER=${LBUFFER%%[^[:space:]]##}
}
zle -N backward-kill-to-space
bindkey '^[[119;6u' backward-kill-to-space  # Ctrl+Shift+w

# copy-region-and-deactivate: 範囲コピーして選択終了
copy-region-and-deactivate() {
  if [ $REGION_ACTIVE -ne 0 ]; then
    zle copy-region-as-kill
    REGION_ACTIVE=0
  fi
}
zle -N copy-region-and-deactivate
bindkey '^[W' copy-region-and-deactivate
bindkey '^[w' copy-region-and-deactivate

# quote-word-or-region: 選択中はquote-region、通常時はquote-word
quote-word-or-region() {
  if [ $REGION_ACTIVE -eq 0 ]; then
    zle quote-word
  else
    zle quote-region
  fi
}
zle -N quote-word-or-region
bindkey '^[[39;5u' quote-word-or-region  # Ctrl+'

autoload -Uz add-zsh-hook

# Set tab name of kitty https://github.com/kovidgoyal/kitty/issues/930
__kitty_tab_title_precmd() {
  print -Pn "\e]0;%~\a"
}
add-zsh-hook precmd __kitty_tab_title_precmd
