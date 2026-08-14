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
bind -x '"^x":"oneliners"'

# flyline (readline 置き換え): nixpkgs にないため Homebrew から読み込む
# flyline 下では readline の bind -x が効かないのでキーバインドを貼り直す
flyline_lib="/opt/homebrew/lib/bash/flyline"
if [[ -r "$flyline_lib" ]] && enable -f "$flyline_lib" flyline; then
  flyline key bind Ctrl+x 'always=runBashCommand(oneliners)'
fi
unset flyline_lib
