# -----------------
#  Aliases
# -----------------
alias cdd='cd ..'
alias cddd='cd ../..'
alias cdddd='cd ../../..'
alias cdf='cd $OLDPWD'
alias cdh='cd ~'
alias cdot="cd ${DOT_DIR}"
alias cp='cp -i'
alias dc='docker container'
alias di='docker image'
alias dp='docker-compose'
alias ds='docker system'
alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias ls='ls --color=auto'
alias lsf='ls -Faogh --time-style="+%F %R"'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias pull='git pull origin `git current-branch`'
alias push='git push origin `git current-branch`'
alias rm='rm -i'
alias sudo='sudo '
alias vimrc='vim ~/.vimrc'
alias vimrclocal='vim ~/.vimrc.local'
alias vin='vim -u NONE -N'

# -----------------
#  Functions
# -----------------
gcm() {
  local msg="$@"
  git commit --message="${msg}"
}
