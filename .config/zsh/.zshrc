# https://github.com/fuzakebito/dotfiles/blob/v2/config/zsh/.zshrc
ZSHRC_DIR=${${(%):-%N}:A:h}

# https://zenn.dev/fuzmare/articles/zsh-source-zcompile-all
# source command override technique
function source {
  ensure_zcompiled $1
  builtin source $1
}
function ensure_zcompiled {
  local compiled="$1.zwc"
  if [[ ! -r "$compiled" || "$1" -nt "$compiled" ]]; then
    echo "Compiling $1"
    zcompile $1
  fi
}
# ensure_zcompiled ~/.zshrc

source $ZSHRC_DIR/eager.zsh
# 存在するかわからないファイルの読み込み
# source FILENAME 2>/dev/null || :
export DOT_DIR="${HOME}/dotfiles"
source "${DOT_DIR}/.config/sh/settings.sh" 2>/dev/null || :
source "${HOME}/.zshrc.local" 2>/dev/null || :

# sheldon cache technique
export SHELDON_CONFIG_DIR="$ZDOTDIR"
# export SHELDON_CONFIG_DIR="$ZSHRC_DIR/sheldon"
sheldon_cache="$SHELDON_CONFIG_DIR/sheldon.zsh"
sheldon_toml="$SHELDON_CONFIG_DIR/plugins.toml"
if [[ ! -r "$sheldon_cache" || "$sheldon_toml" -nt "$sheldon_cache" ]]; then
  sheldon source > $sheldon_cache
fi
source "$sheldon_cache"
unset sheldon_cache sheldon_toml

zsh-defer zsh-defer unfunction source
