# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac
# -----------------
#  Common setting
# -----------------
__source() {
  [ -f $1 ] && source $1
}

export DOT_DIR="${HOME}/dotfiles"
__source "${DOT_DIR}/etc/commonrc.sh"

# -----------------
#  Alias
# -----------------
alias she='vim ~/.bashrc'
alias shs='source ~/.bashrc'

# -----------------
#  Options
# -----------------
shopt -s checkwinsize
shopt -s direxpand
shopt -s extglob
shopt -s globstar
shopt -s histappend
shopt -s nocaseglob

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# -----------------
#  Default settings
# -----------------
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable this,
# if it's already enabled in /etc/bash.bashrc and /etc /profile sources /etc/etc.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash_completion/bash_completion ]; then
    source /usr/share/bash_completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# -----------------
#  FZF
# -----------------
__source ~/.fzf.bash

# -----------------
#  prompt
# -----------------
if has "starship"; then
  export STARSHIP_CONFIG="${DOT_DIR}/etc/starship.toml"
  eval "$(starship init bash)"
else
  __ps_git_br() {
    local exit=$?
    echo $(git current-branch 2>/dev/null)
    return $exit
  }
  __ps_cmd_err() {
    if [ $? -ne 0 ]; then
      echo 31
    else
      echo 36
    fi
  }
  # ネットではPS1_NEWLINE_LOGINを使って改行する方法が示されているが普通に先頭に\nを入れれば良さそう
  PS1='\n\W \e[32m$(__ps_git_br)\e[m\n\e[$(__ps_cmd_err)m\$\e[m '
fi

# -----------------
#  Local Setting
# -----------------
__source ~/.bashrc.local

:
