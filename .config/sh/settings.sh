has() {
  type "$1" > /dev/null 2>&1
}

# -----------------
#  XDG Environments
# -----------------
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"
# export XDG_RUNTIME_DIR="/run/user/${UID}"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GEM_HOME="${XDG_DATA_HOME}/gem"
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"
export GOPATH="${XDG_DATA_HOME}/go"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc.py"
export TERMINFO="${XDG_DATA_HOME}/terminfo"
export TERMINFO_DIRS="${XDG_DATA_HOME}/terminfo:/usr/share/terminfo"
export PNPM_HOME="${XDG_DATA_HOME}/pnpm"
export NI_CONFIG_FILE="$HOME/.config/ni/nirc"
export NIX_USER_CONF_FILES="${XDG_CONFIG_HOME}/nix/nix.conf:${XDG_CONFIG_HOME}/nix/local.conf"

# -----------------
#  Paths
# -----------------
export EDITOR="vim"
# export EDITOR="nvim"
# export GOPATH="${HOME}/go"
PATH="${HOME}/bin:${PATH}"
PATH="${DOT_DIR}/bin:${PATH}"
PATH="${CARGO_HOME}/bin:${PATH}"
PATH="${HOME}/.deno/bin:${PATH}"
PATH="${GOPATH}/bin:${PATH}"
PATH="${PNPM_HOME}:${PATH}"

# to detect formulae for apple silicon
PATH="/opt/homebrew/bin:$PATH"

# -----------------
#  Aliases
# -----------------
# [9 Evil Bash Commands Explained](https://qiita.com/rana_kualu/items/be32f8302017b7aa2763)
# https://vim-jp.org/vim-users-jp/2009/11/07/Hack-99.html
alias bg='batgrep'
alias bx='bundle exec'
alias cdd='cd ..'
alias cddd='cd ../..'
alias cdddd='cd ../../..'
alias cdot="cd $DOT_DIR"
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias cp='cp -i'
alias dc='docker container'
alias dd='echo "dd command is restricted"'
alias desk='deno task'
alias di='docker image'
alias dp='docker compose'
alias dr='docker run'
alias ds='docker system'
alias egrep='egrep --color=auto'
alias g='git'
alias golint='revive -formatter friendly -config $HOME/.config/revive.toml'
alias gq='ghq get'
alias grep='grep --color=auto'
alias fetch='git fetch --all --prune --tags'
alias fgrep='fgrep --color=auto'
alias fl='flutter'
alias kittyconfig="nvim ${DOT_DIR}/.config/kitty/kitty.conf"
alias lg='lazygit'
alias ls='ls --color=auto'
alias lsf='ls -FAogh --time-style="+%F %R"'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias nv='nvim'
alias nvmin='nvim -u ~/dotfiles/.config/nvim/min-edit.vim'
alias nvimprofile='nvim --cmd "profile start profile.txt" --cmd "profile file ~/.config/nvim/init.vim" -c quit'
alias nvinit='nvim ~/.config/nvim/init.vim'
alias nvp="nvim -c 'put *'"
alias nvr="nvim -c 'call EditProjectMru()'"
alias push='git push-with-check'
alias rc='bundle exec rails console'
alias rm='rm -i --preserve-root'
alias rs='bundle exec rails server'
alias she="nvim ${shell_rc}"
alias shl="nvim ${shell_rc}.local"
alias shs="source ${shell_rc}"
alias stw="snap-tweet --locale ja --output-dir ~/Downloads"
alias rgg="rg --hidden --trim --glob '!**/.git/*'"
alias rgf="rgg --fixed-strings --"
alias sudo='sudo '
alias vi='vim'
alias vimrc='vim ~/.vim/vimrc'
alias vimrclocal='vim ~/.vimrc.local'
alias vimprofile='vim --cmd "profile start profile.txt" --cmd "profile file ~/.vim/vimrc" -c quit'
alias vin='vim -u NONE -N'
alias vip="vim -c 'put *'"
alias vir="vim -c 'call EditProjectMru()'"
alias wcl='wc -l'
alias wget='wget --hsts-file="${XDG_DATA_HOME}/wget-hsts"'
alias wtf='wtfutil'
alias x='xplr'
alias xcd='cd $(xplr)'
alias yq='gojq --yaml-input --yaml-output'

if has 'lsd'; then
  alias ls='lsd'
  alias lsf='lsd -FAl --blocks=permission,size,date,name --date="+%F %R"'
  alias tree='lsd --tree'
fi

if has 'eza'; then
  alias lsf='eza -F -alh --no-user --time-style=long-iso --icons --git'
  alias tree='eza --all --git-ignore --tree --icons --ignore-glob=.git'
fi

if has 'procs'; then
  alias ps='procs'
fi

if has 'fcp'; then
  alias cp='fcp'
fi

if has 'batman'; then
  alias man='batman'
fi
if has 'batdiff'; then
  alias diff='batdiff --delta'
fi

# -----------------
#  Functions
# -----------------
ma() {
  # https://rcmdnk.com/blog/2014/07/20/computer-vim/
  man "$@" | col -bx | vim -RM --not-a-term -c 'set ft=man nolist nonumber' -
}

# aliasにすると定義したところで評価されてしまうので関数にする必要がある
cdg() {
  cd "$(git rev-parse --show-toplevel)"
}

silica() {
  fname="~/Downloads/silicon-$(date +%Y%m%d-%H%M%S).png"
  silicon --font 'UDEV Gothic 35JPDOC' --output "$fname" "$@"
  echo "silicon saved: $fname"
}

# fuzzy edit gist
fest() {
  gh gist list "$@" | fzf --with-nth=-2,-4,-3,2..-5 | awk '{print $1}' \
    | xargs --no-run-if-empty --open-tty gh gist edit
}

# view web gist
vest() {
  gh gist list "$@" | fzf --with-nth=-2,-4,-3,2..-5 | awk '{print $1}' \
    | xargs --no-run-if-empty gh gist view --web
}

if has 'llama'; then
  ll() {
    cd "$(llama "$@")"
  }
fi

img_to_webp() {
  find . -maxdepth 1 \( -name \*.png -or -name \*.jpg -or -name \*.jpeg \) \
    | xargs -I_ sh -c 'printf _" -> "_".webp ..."; cwebp _ -o _".webp" >/dev/null 2>&1; echo " done."'
}

branch() {
  # https://github.com/junegunn/fzf/issues/1693#issuecomment-699642792
  git branch --sort=-authordate "$@" | grep --invert-match HEAD | \
    fzf --print-query --cycle --exit-0 --no-multi \
    --header-first --header='Create new branch when query is not matched' \
    --preview="sed -r 's/. ([^ ]+).*/\1/' <<< {} | \
      xargs git log -30 --pretty=format:'[%ad] %s <%an>' --date=format:'%F'" | \
    tail -1 | \
    sed -r 's#. (.*origin/)?([^ ]+).*#\2#' | \
    xargs --no-run-if-empty -I_ git twig _
}

fpull() {
  fetch

  if git diff --quiet HEAD..origin; then
    echo 'Working tree is up-to-date.'
    return 0
  fi

  if git status --short --null --untracked-files=no | grep --quiet .; then
    git stash
    pull
    git stash pop
  else
    pull
  fi
}

pull() {
  git pull origin "${1:-$(git current-branch)}"
}

pushf() {
  git push --force-with-lease --force-if-includes origin "${1:-$(git current-branch)}"
}

stash() {
  git stash save "${1:-$(date +%Y%m%d%H%M%S)}"
}

# -----------------
#  fzf
# -----------------
fzf_preview_cmd='head -50'
if has 'bat'; then
  fzf_preview_cmd='bat --color=always --style=header,grid --line-range :50 {}'
fi
export FZF_COMPLETION_TRIGGER=','
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height=40% --reverse --border'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS="--preview=${fzf_preview_cmd}"

cgh() {
  has 'ghq' || return 1
  local dir
  dir=$(ghq list | fzf --no-multi --exit-0 --query="$*" --preview="ls -FA1 $(ghq root)/{}")
  [ -n "$dir" ] && cd "$(ghq root)/$dir" || return
}

cdf() {
  local dir
  dir=$(cdr -l | awk '{ print $2 }' | fzf --no-multi --exit-0 --query="$*" --preview="echo {} | sed 's#~#$HOME#' | xargs -I_ ls -FA1 _")
  [ -n "$dir" ] && cd "${dir/\~/$HOME}" || return
}

nvf() {
  find_for_vim | \
    fzf --multi --exit-0 --query="$*" --preview="$fzf_preview_cmd" --cycle | \
    xargs --no-run-if-empty --open-tty nvim
}

vif() {
  find_for_vim | \
    fzf --multi --exit-0 --query="$*" --preview="$fzf_preview_cmd" --cycle | \
    xargs --no-run-if-empty --open-tty vim
}

hf() {
  find_for_vim | \
    fzf --multi --exit-0 --query="$*" --preview="$fzf_preview_cmd" --cycle | \
    xargs --no-run-if-empty --open-tty hx
}

# fgt() {
#   local list="fbr select git branch"
#   list="$list\nfsw switch to selected git branch"
#   list="$list\nfmer merge selected git branch to current branch"
#   list="$list\nfdel delete selected git branch"
#   list="$list\nfst check current git status and manage staging"
#   list="$list\nfadd git add and show"
#   list="$list\nfcm git commit with showing staged diff"
#   list="$list\nfshow select commit with show diff"
#   list=$(echo -e "$list" | sed -r 's/(\w+)/\\033[1;33m\1\\033[0m/')
#   local cmd=$(echo -e "$list" | fzf --ansi --cycle --no-multi --tiebreak=begin | sed -e 's/ .*//')
#   [ -n "$cmd" ] && "$cmd"
# }

# grass() {
#   echo 'Contributions of this week'
#   curl -sS https://github.com/kawarimidoll | \
#     grep -E "fill.*($(seq 0 6 | \
#     xargs -I_ date --date _' days ago' +%Y-%m-%d | paste -s -d '|' -))" | \
#     sed -r 's/.+count="([0-9]+)".+date="([0-9\-]+)".+/\2: \1/'
# }
#
__get_oneliners() {
  cat "${DOT_DIR}/etc/oneliners.txt" | \
    fzf --header="@ becomes the cursor position" |  \
    sed 's/\[.*\]//'
}
#
# goinit() {
#   if [ -f main.go ]; then
#     echo "main.go is already exists!"
#     return 1
#   fi
#   echo -e "package main\n\nfunc main() {\n\n}" > main.go
#   go mod init "$((git config --get remote.origin.url || basename `pwd`) | sed -e 's#https\?://##')"
# }
#
# gopackage() {
#   if [ $# -eq 0 ]; then
#     echo "package name is required!"
#     echo "usage: gopackage package_name"
#     return 1
#   fi
#   mkdir -p "$1" && \
#     echo -e "package $(basename $1)\n\nfunc init() {\n\n}" > "$1/$(basename $1).go"
# }

# -----------------
#  xd - extended cd
# -----------------
__source "${DOT_DIR}/etc/xd.sh"

# -----------------
#  broot
# -----------------
__source "${HOME}/.config/broot/launcher/bash/br"

# -----------------
#  OS Setting
# -----------------
OS='unknown'
if [ "$(uname)" = 'Darwin' ]; then
  OS='mac'
elif [ "$(uname)" = 'Linux' ]; then
  OS='linux'
elif [ "$(uname -s | cut -c-5)" = 'MINGW' ]; then
  OS='windows'
fi
export DOT_OS_DIR="${DOT_DIR}/etc/${OS}"
__source "${DOT_DIR}/.config/sh/${OS}.sh"

browse() {
  # [git-extras/git-browse](https://github.com/tj/git-extras/blob/master/bin/git-browse)
  case "$OSTYPE" in
  darwin*)
    # MacOS
    open "$1" ;;
  msys)
    # Git-Bash on Windows
    start "$1" ;;
  linux*)
    # Handle WSL on Windows
    if uname -a | grep -i -q Microsoft; then
      powershell.exe -NoProfile start "$1"
    else
      xdg-open "$1"
    fi ;;
  *)
    # fall back to xdg-open for BSDs, etc.
    xdg-open "$1" ;;
  esac
}
