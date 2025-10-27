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
export CLAUDE_CONFIG_DIR="${XDG_CONFIG_HOME}/claude"
export GEM_HOME="${XDG_DATA_HOME}/gem"
export GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"
export GOPATH="${XDG_DATA_HOME}/go"
export LESS="-iMR"
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export PYTHONSTARTUP="${XDG_CONFIG_HOME}/python/pythonrc.py"
export TERMINFO="${TERMINFO:-${XDG_DATA_HOME}/terminfo}"
export TERMINFO_DIRS="${TERMINFO}:/usr/share/terminfo"
export PNPM_HOME="${XDG_DATA_HOME}/pnpm"
export NI_CONFIG_FILE="$HOME/.config/ni/nirc"
export NIX_USER_CONF_FILES="${XDG_CONFIG_HOME}/nix/nix.conf:${XDG_CONFIG_HOME}/nix/local.conf"
export PAGER="less ${LESS}"

# https://mikoto2000.blogspot.com/2024/09/vim-pager-filetype.html
export MANPAGER='sh -c "sed -E '\''s/\x1B\[[0-9;]*[mGKH]//g'\'' | vim -RMn --not-a-term -c '\''ru ftplugin/man.vim'\'' -c '\''se ft=man nolist nonu'\'' -"'

# -----------------
#  Paths
# -----------------
# export EDITOR="vim"
export EDITOR="nvim"
# export GOPATH="${HOME}/go"
PATH="${HOME}/bin:${PATH}"
PATH="${CARGO_HOME}/bin:${PATH}"
PATH="${HOME}/.deno/bin:${PATH}"
PATH="${HOME}/.cache/.bun/bin:${PATH}"
PATH="${GOPATH}/bin:${PATH}"
PATH="${PNPM_HOME}:${PATH}"
# uv tool dir --bin
PATH="${XDG_DATA_HOME}/../bin:${PATH}"

# to use LM Studio CLI (lms)
export PATH="$PATH:${HOME}/.lmstudio/bin"

# -----------------
#  Aliases
# -----------------
# [9 Evil Bash Commands Explained](https://qiita.com/rana_kualu/items/be32f8302017b7aa2763)
# https://vim-jp.org/vim-users-jp/2009/11/07/Hack-99.html
alias cdd='cd ..'
alias cddd='cd ../..'
alias cdddd='cd ../../..'
alias cdot='cd $DOT_DIR'
alias chmod='chmod --preserve-root'
alias chown='chown --preserve-root'
alias cp='cp -i'
alias dd='echo "dd command is restricted"'
alias desk='deno task'
alias egrep='egrep --color=auto'
alias g='git'
alias grep='grep --color=auto'
alias fetch='git fetch --all --prune --tags'
alias fgrep='fgrep --color=auto'
alias ld='lazydocker'
alias lg='lazygit'
alias ls='ls --color=auto'
alias lsf='ls -FAogh --time-style="+%F %R"'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias nv='nvim'
# alias nvmin='nvim -u ~/dotfiles/.config/nvim/min-edit.vim'
alias nvimprofile='nvim --cmd "profile start profile.txt" --cmd "profile file ~/.config/nvim/init.vim" -c quit'
# alias nvinit='nvim ~/.config/nvim/init.vim'
# alias nvp="nvim -c 'put *'"
alias nvr="nvim -c 'call EditProjectMru()'"
alias pull='git pull-with-check'
alias push='git push-with-check'
# alias rm='rm -i --preserve-root'
alias she="nvim ${shell_rc}"
alias shl="nvim ${shell_rc}.local"
alias shs="source ${shell_rc}"
alias rgg="rg --hidden --trim --glob '!**/.git/*' --glob='!*.lock' --glob='!*-lock.json'"
alias rgf="rgg --fixed-strings --"
alias sudo='sudo '
alias vi='vim'
alias vimrc='vim ~/.vim/vimrc'
alias vimrclocal='vim ~/.vimrc.local'
alias vimprofile='vim --cmd "profile start profile.txt" --cmd "profile file ~/.vim/vimrc" -c quit'
# alias vin='vim -u NONE -N'
# alias vip="vim -c 'put *'"
alias vir="vim -c 'call EditProjectMru()'"
alias wcl='wc -l'
alias wget='wget --hsts-file="${XDG_DATA_HOME}/wget-hsts"'
# alias wtf='wtfutil'
alias x='xplr'
alias xcd='cd $(xplr)'

alias nvf='fffe --editor nvim'
alias vif='fffe --editor vim'
alias hxf='fffe --editor hx'

if has 'lsd'; then
  alias ls='lsd'
  alias lsf='lsd -FAl --blocks=permission,size,date,name --date="+%F %R"'
  alias tree='lsd --tree'
fi

if has 'eza'; then
  alias lsf='eza -F -alh --no-user --time-style=long-iso --icons --git'
  alias tree='eza --all --git-ignore --tree --icons --ignore-glob=.git'
fi

# -----------------
#  Functions
# -----------------
# 事前に許可したファイルしかrmしないようにする
# https://zenn.dev/kawarimidoll/articles/70e473a198badf
rm() {
  rm_abort() {
    echo "'rm' is dangerous command! Use 'trash' instead."
    echo "AI Agents are not permitted to use 'trash' command too. Request the user to delete the files."
    return 1
  }

  # 安全に削除できるファイル名を連想配列で定義
  local -A safe_files=(
    [".DS_Store"]=1
    ["node_modules"]=1
    ["_gen"]=1
  )

  # オプション以外の引数を抽出
  local args=()
  local arg
  for arg in "$@"; do
    [[ "$arg" != -* ]] && args+=("$arg")
  done

  # 引数があるか確認
  if [[ ${#args[@]} -eq 0 ]]; then
    rm_abort
    return $?
  fi

  # 全ての引数が安全か判定
  local base
  for arg in "${args[@]}"; do
    base=$(basename "$arg")
    if [[ -z "${safe_files[$base]}" ]]; then
      rm_abort
      return $?
    fi
  done

  # 実行
  command rm -i --preserve-root "$@"
}

# https://zenn.dev/kgmyshin/articles/git-worktrees
# Git worktree cd - sourceで実行する必要があるため関数として定義
wtc() {
  source "/Users/kawarimidoll/dotfiles/bin/_wtc"
}

# https://zenn.dev/kawarimidoll/articles/cf3c48589adb71
nix() {
  command nix "$@"
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    echo ""
    echo "nix command failed!"
    echo "Did you forget to 'git add' new files?"
  fi
  return $exit_code
}

# aliasにすると定義したところで評価されてしまうので関数にする必要がある
cdg() {
  cd "$(git rev-parse --show-toplevel)" || return
}

silica() {
  fname="${HOME}/Downloads/silicon-$(date +%Y%m%d-%H%M%S).png"
  silicon --font 'UDEV Gothic 35JPDOC' --output "$fname" "$@"
  echo "silicon saved: $fname"
}

docker-all-delete() {
  # https://gist.github.com/yheihei/656bb221d4d51c5614123c23b1ce5898
  docker system prune
  docker container prune
  docker rm -f "$(docker ps -a -q)"
  docker image prune
  docker rmi "$(docker images -a -q)"
  docker volume prune
  docker network prune
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

if has 'walk'; then
  lk() {
    cd "$(walk "$@")" || return
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

pushf() {
  git push --force-with-lease --force-if-includes -u origin "${1:-$(git current-branch)}"
}

clone() {
  has 'ghq' || return 1
  ghq get --partial blobless "$1"
  local target=""
  target=$(echo "$1" | sed -r 's;https?://[^/]+|\.git$;;')
  local dir=""
  dir=$(ghq list | grep --color=never --fixed-strings "$target")
  [ -n "$dir" ] && cd "$(ghq root)/$dir" || return
  git dead
  git branch -D "$(git default-branch)"
}

stash() {
  git stash save "${1:-$(date +%Y%m%d%H%M%S)}"
}

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

__get_oneliners() {
  fzf --header="@ becomes the cursor position" < "${DOT_DIR}/etc/oneliners.txt"  |  \
    sed 's/\[.*\]//'
}

# -----------------
#  xd - extended cd
# -----------------
__source "${DOT_DIR}/etc/xd.sh"

# -----------------
#  broot
# -----------------
# __source "${HOME}/.config/broot/launcher/bash/br"

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

PATH="${DOT_DIR}/bin:${PATH}"
