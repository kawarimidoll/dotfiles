# this is bash settings

# Set terminal title to current directory
PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

# Oneliners function with keybinding
oneliners() {
  local oneliner=$(__get_oneliners) || return 1
  READLINE_LINE="''${oneliner//__CURSOR__/}"
  READLINE_POINT=''${#${oneliner%%__CURSOR__*}}
}
bind -x '"^x":"oneliners"'

# ghq + fzf でリポジトリに移動
ghq-cd-widget() {
  local dir
  dir=$(ghq list | fzf --no-multi --exit-0 --preview="ls -FA1 $(ghq root)/{}")
  if [ -n "$dir" ]; then
    cd "$(ghq root)/$dir"
    READLINE_LINE=""
    READLINE_POINT=0
  fi
}
bind -x '"\C-x\C-f": ghq-cd-widget'

export SHELDON_CONFIG_DIR="$DOT_DIR/.config/bash"
sheldon_cache="$SHELDON_CONFIG_DIR/sheldon.bash"
sheldon_toml="$SHELDON_CONFIG_DIR/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml
