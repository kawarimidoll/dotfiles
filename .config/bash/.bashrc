# this is bash settings

# Set terminal title to current directory
PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

# Oneliners function with keybinding
oneliners() {
  local oneliner=$(__get_oneliners) || return 1
  local prefix="${oneliner%%__CURSOR__*}"
  READLINE_LINE="${oneliner//__CURSOR__/}"
  READLINE_POINT=${#prefix}
}
bind -x '"\C-x\C-o": oneliners'

# コマンドラインをエディタで編集する (zsh の edit_current_line 相当)
edit-prompt() {
  local tmp
  tmp=$(mktemp "${TMPDIR:-/tmp}/bash-edit.XXXXXX") || return 1
  printf '%s' "$READLINE_LINE" >"$tmp"
  "${EDITOR:-vim}" -c 'setl awa|norm!G$' "$tmp"
  READLINE_LINE=$(<"$tmp")
  READLINE_POINT=${#READLINE_LINE}
  rm -f "$tmp"
}
bind -x '"\C-x\C-e": edit-prompt'

# flyline 下では readline の bind -x が効かないのでキーバインドを貼り直す
# leader は最後のキーから 1 秒でタイムアウトする
flyline_lib="/opt/homebrew/lib/bash/flyline"
if [[ -r "$flyline_lib" ]] && enable -f "$flyline_lib" flyline; then
  flyline key bind Ctrl+x 'always=setLeaderKey'
  flyline key bind Ctrl+o 'leaderKeyActive=runBashCommand(oneliners)'
  flyline key bind Ctrl+e 'leaderKeyActive=runBashCommand(edit-prompt)'
fi
unset flyline_lib
