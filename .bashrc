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
__source ~/.fzf.zsh

# -----------------
#  prompt
# -----------------
if has "starship"; then
  eval "$(starship init bash)"
else
  __ps_color() {
    printf '\e[%dm%s\e[m' "$2" "$1"
  }
  __ps_git_br() {
    local exit=$?
    local branch=$(git rev-parse --abrev-ref HEAD 2>/dev/null)
    [ -n "$branch" ] && __ps_color " $branch" 32
    return $exit
  }
  __ps_cmd_err() {
    [ $? -ne 0 ] && __ps_color " x" 31
  }
  __ps_dir() {
    local pwd=$(pwd)
    if [ "$pwd" = "$HOME" ]; then
      printf '🏠'
    else
      printf "$pwd"
    fi
  }
  # ネットではPS1_NEWLINE_LOGINを使って改行する方法が示されているが普通に先頭に\nを入れれば良さそう
  export PS1='n$(__ps_dir)$(__ps_git_br)$(__ps_cmd_err)n$ '
fi

# -----------------
#  OS Setting
# -----------------
OS='unknown'
if [[ "$(uname)" = "Darwin" ]]; then
  OS='mac'
elif [[ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]]; then
  OS='windows'
elif [[ "$(expr substr $(uname -s) 1 5)" = "Linux" ]]; then
  OS='linux'
fi

__source "${DOT_DIR}/etc/${OS}/bashrc"

# -----------------
#  Local Setting
# -----------------
__source ~/.bashrc.local
