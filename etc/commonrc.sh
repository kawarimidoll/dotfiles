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
alias lg='lazygit'
alias ls='ls --color=auto'
alias lsf='ls -FAogh --time-style="+%F %R"'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias rm='rm -i'
alias sudo='sudo '
alias vimrc='vim ~/.vimrc'
alias vimrclocal='vim ~/.vimrc.local'
alias vin='vim -u NONE -N'
alias vir='vim -c "edit #<1"'

# -----------------
#  Functions
# -----------------
gcm() {
  local msg="$@"
  git commit --message="${msg}"
}

pull() {
  local current=$(git current-branch)
  [[ -z "$current" ]] && return 1

  local branch="$1"
  [[ -z "$branch" ]] && branch="$current"

  echo "git pull origin ${branch}"
  git pull origin ${branch}
}

push() {
  local current=$(git current-branch)
  [[ -z "$current" ]] && return 1

  local branch="$1"
  [[ -z "$branch" ]] && branch="$current"

  echo "git push origin ${branch}"
  git push origin ${branch}
}

# -----------------
#  fzf
# -----------------
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'

cgh() {
  # local dir=$(ghq list --full-path | fzf +m --preview "ls -FA1 {}") && cd "$dir"
  local dir
  dir=$(ghq list | fzf +m --preview "ls -FA1 $(ghq root)/{}") && cd "$(ghq root)/$dir"
}

vif() {
  local file
  file=$(fzf -m --preview "bat --color=always --style=header,grid --line-range :100 {}") && vim "$file"
}

fcd() {
  local dir=$(find -mindepth 1 -path '*/\.*' -prune -o -type d -print 2> /dev/null | cut -b3- | fzf +m) && cd "$dir"
}
