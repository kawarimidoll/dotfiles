# -----------------
#  settings.sh for linux
# -----------------

# [ターミナルで標準出力をクリップボードにコピーする - Qiita](https://qiita.com/sasaplus1/items/137a70e8f51f97a6636f)
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias arwer="yay -Qeq > ${DOT_DIR}/etc/linux/yay-list.log"

# https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

__source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh
__source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
__source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
