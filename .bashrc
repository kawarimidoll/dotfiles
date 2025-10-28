# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# -----------------
#  Common setting
# -----------------
__source() {
  [ -f $1 ] && source $1
}

export DOT_DIR="${HOME}/dotfiles"
shell_rc="${HOME}/.bashrc"
__source "${DOT_DIR}/.config/sh/settings.sh"

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
  __source /usr/share/bash-completion/bash_completion || \
    __source /etc/bash_completion
fi

if ! has '__git_complete'; then
  __source /usr/share/bash-completion/completions/git || \
    __source /etc/bash_completion/completions/git
fi
if has '__git_complete'; then
  # use git completion with alias 'g'
  __git_complete g __git_main
fi

# -----------------
#  Functions
# -----------------
oneliners() {
  local oneliner=$(__get_oneliners) || return 1
  local cursol="${oneliner%%@*}"
  READLINE_LINE="${oneliner/@/}"
  READLINE_POINT="${#cursol}"
}
bind -x '"^x":"oneliners"'

# -----------------
#  Local Setting
# -----------------
__source ~/.bashrc.local

:
