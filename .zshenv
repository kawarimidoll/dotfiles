setopt no_global_rcs
export ZDOTDIR="$HOME/.config/zsh"

# 読み込み順
# https://qiita.com/muran001/items/7b104d33f5ea3f75353f
# ログインシェルの場合
#   /etc/zshenv
#   $ZDOTDIR/.zshenv
#   /etc/zprofile
#   $ZDOTDIR/.zprofile
#   /etc/zshrc
#   $ZDOTDIR/.zshrc
#   /etc/zlogin
#   $ZDOTDIR/.zlogin
# インタラクティブシェルの場合
#   /etc/zshenv
#   $ZDOTDIR/.zshenv
#   /etc/zshrc
#   $ZDOTDIR/.zshrc
# シェルスクリプトの場合
#   /etc/zshenv
#   $ZDOTDIR/.zshenv
# ログアウトする場合
#   $ZDOTDIR/.zlogout
#   /etc/zlogout
#
# setopt no_global_rcsすると/etc/z**がスキップされる
# ただし/etc/zshenvはどうやっても最初に読み込まれる
