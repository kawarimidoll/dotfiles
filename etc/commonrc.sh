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
alias she="vim ${shell_rc}"
alias shl="vim ${shell_rc}.local"
alias shs="source ${shell_rc}"
alias sudo='sudo '
alias vimrc='vim ~/.vimrc'
alias vimrclocal='vim ~/.vimrc.local'
alias vin='vim -u NONE -N'
alias vir='vim -c "edit #<1"'

# -----------------
#  Functions
# -----------------
has() {
  type "$1" > /dev/null 2>&1
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
  local preview_cmd='head -100'
  if has "bat"; then
    preview_cmd='bat --color=always --style=header,grid --line-range :100 {}'
  fi
  local ignore_exts='png,jpg,jpeg,gif,webp,svg,ico,ttf,otf,woff,woff2,keep'
  local file=$(rg --files --hidden --follow \
    --glob '!**/.git/*' --glob '!'"**/*.{$ignore_exts}" | \
    fzf --multi --exit-0 --query="$@" --preview "$preview_cmd")
  [ -n "$file" ] && vim $(echo "$file" | paste -s -d ' ' -)
}

fgt() {
  local list="fbr\nfsw\nfmer\nfdel\nfst\nfadd"
  local cmd=$(echo -e "$list" | fzf --no-multi --preview "case {} in
    fbr) echo 'select git branch' ;;
    fsw) echo 'switch to selected git branch' ;;
    fmer) echo 'merge selected git branch to current branch' ;;
    fdel) echo 'delete selected git branch' ;;
    fst) echo 'check current git status and manage staging' ;;
    fadd) echo 'git add and show' ;;
  esac")
  [ -n "$cmd" ] && "$cmd"
}

fadd() {
  local out
  while out=$(git status --short |
    awk '{if (substr($0,2,1) != " ") print $2}' |
    fzf --multi --exit-0 --expect=ctrl-d,ctrl-f \
    --header 'Enter: add, Ctrl-f: patch add, Ctrl-d: show diff, Esc:quit'); do
    local files=$(echo ${out} | tail -n+2)
    [ -z "$files" ] && continue
    case "$(echo ${out} | head -1)" in
      ctrl-d ) git diff "$files" ;;
      ctrl-f ) git add --patch "$files" ;;
      * ) git add "$files" ;;
    esac
  done
}

fst() {
  local listup_command="git status --short"
  if has "unbuffer"; then
    local listup_command="unbuffer $listup_command"
  fi
  local prefix_git="cut -c4- <<< {} | xargs git"
  eval $listup_command | fzf --ansi --exit-0 --no-multi \
    --height 100% --preview-window=down:80% \
    --preview "$prefix_git diff --color=always --;$prefix_git diff --staged --color=always --" \
    --header "Enter: add, Ctrl-s: unstage, Ctrl-d: discard, Ctrl-u/i: scroll preview" \
    --bind "ctrl-u:preview-down,ctrl-i:preview-up" \
    --bind "enter:reload($prefix_git add;$listup_command)" \
    --bind "ctrl-s:reload($prefix_git restore --staged;$listup_command)" \
    --bind "ctrl-d:reload($prefix_git restore;$listup_command)" #\
    # --bind "ctrl-f:reload($prefix_git add --patch;$listup_command)"
}

fcm() {
  local _binds="ctrl-y:toggle-preview,ctrl-u:preview-down,ctrl-i:preview-up"
  local message=$(git diff --staged --name-only | fzf --phony --exit-0 --no-multi \
    --height 100% --preview-window=down:80% \
    --preview "git diff --staged --color=always -- {}" \
    --header "$_binds" --bind "$_binds" \
    --prompt "commit message: " --print-query | head -1)
  if [ -z "$message" ]; then
    echo 'commit message is required.'
    return 1
  fi
  git commit --message="$message"
}

fbr() {
  [ -z $(git current-branch) ] && return 1
  git branch "$@" | grep -v -e HEAD | \
    fzf --no-multi --exit-0 --cycle --preview \
    "cut -c3- <<< {} | xargs git log -30 --oneline --pretty=format:'[%ad] %s <%an>' --date=format:'%F'" | \
    cut -c3- | sed 's#.*/##'
}

fsw() {
  local branch=$(fbr $@)
  if [ -n "$branch" ]; then
    echo "Switching to branch '$branch'..."
    git switch "$branch"
  fi
}

fdel() {
  local branch=$(fbr $@)
  if [ -n "$branch" ]; then
    echo -n "Delete branch '$branch'? [y/N]: "
    read yn
    case "${yn:0:1}" in
      [yY]) git branch -d "$branch" ;;
    esac
  fi
}

fmer() {
  local branch=$(fbr $@)
  if [ -n "$branch" ]; then
    echo -n "Merge branch '$branch' to current branch? [y/N]: "
    read yn
    case "${yn:0:1}" in
      [yY]) git merge "$branch" ;;
    esac
  fi
}

fshow() {
  local _binds="ctrl-y:toggle-preview,ctrl-u:preview-down,ctrl-i:preview-up"
  git log --graph --color=always --format="%C(auto)%h%d %C(black bold)%cr %C(auto)%s" |
    fzf --no-sort --no-multi --exit-0 --tiebreak=index --ansi --height 100% \
    --preview "echo {} | grep -o '[a-f0-9]\{7\}' | xargs git show --color=always" \
    --header "$_binds" --bind "$_binds" \
    --preview-window=down:60% | grep -o '[a-f0-9]\{7\}'
  # get commit message
  # sed -e 's/[a-f0-9]\{7\}\( (.\+)\)\? [0-9]\+ \w\+ \w\+ //'
}

fxup() {
  local hash=$(fshow $@)
  if [ -n "$hash" ]; then
    git commit --fixup "$hash"
    echo -n "Squash now? [y/N]: "
    read yn
    case "${yn:0:1}" in
      [yY]) git rebase --interactive --autosquash;;
    esac
  fi
}

# -----------------
#  xd - extended cd
# -----------------
__source "${DOT_DIR}/etc/xd.sh"

# -----------------
#  OS Setting
# -----------------
OS='unknown'
if [ "$(uname)" = "Darwin" ]; then
  OS='mac'
elif [ "$(uname)" = "Linux" ]; then
  OS='linux'
elif [ "$(expr substr $(uname -s) 1 5)" = "MINGW" ]; then
  OS='windows'
fi
__source "${DOT_DIR}/etc/${OS}/commonrc.sh"
