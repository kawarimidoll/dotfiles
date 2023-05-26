# -----------------
#  settings.sh for linux
# -----------------

# [ターミナルで標準出力をクリップボードにコピーする - Qiita](https://qiita.com/sasaplus1/items/137a70e8f51f97a6636f)
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

alias arwer="yay -Qeq > ${DOT_OS_DIR}/yay-list.log"

__source /usr/share/zsh/plugins/zsh-autopair/autopair.zsh
__source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
__source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
