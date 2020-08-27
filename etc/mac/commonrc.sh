# -----------------
#  commonshrc for mac
# -----------------
alias brewer='sh ~/dotfiles/etc/mac/brewer.sh'
alias ctags='$(brew --prefix)/bin/ctags'
alias find='gfind'
alias ls='gls --color=auto'

PATH="/usr/local/opt/binutils/bin:$PATH"
# PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
PATH="/usr/local/opt/ed/bin:$PATH"
PATH="/usr/local/opt/ed/libexec/gnubin:$PATH"
# PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
PATH="/usr/local/opt/unzip/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/binutils/lib"
export CPPFLAGS="-I/usr/local/opt/binutils/include"

MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
MANPATH="/usr/local/opt/ed/libexec/gnuman:$MANPATH"
MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"
MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH"
MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"

__add_fpath "$(brew --prefix)/share/zsh-completions"
__add_fpath "$(brew --prefix)/share/zsh/site-functions"
