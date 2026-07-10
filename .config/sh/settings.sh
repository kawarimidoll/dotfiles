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
PATH="${PATH}:/usr/local/bin"
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
alias delete_deadlinks='find . -maxdepth 1 -xtype l -delete'
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
alias nvr="nv -c 'let g:open_latest_path_on_startup=1'"
alias pull='git pull-with-check'
alias push='git push-with-check'
alias pushf='git push-with-check --force'
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

alias lsf='eza -F -alh --no-user --time-style=long-iso --icons --git'
alias tree='eza --all --git-ignore --tree --icons --ignore-glob=.git'

# -----------------
#  Functions
# -----------------
# Ghosttyのスクロールバックから最後のコマンド出力を抽出してコピー
copy_last_command_output_from_ghostty_scrollback() {
  local file
  file="$(pbpaste)"
  if [[ ! -f "$file" ]]; then
    echo "Error: File not found: $file" >&2
    return 1
  fi
  perl -ne '
    push @lines, $_;
    END {
      pop @lines; pop @lines;
      for ($i = $#lines; $i >= 0; $i--) {
        if ($lines[$i] =~ /❯/) {
          print @lines[$i..$#lines];
          last;
        }
      }
    }
  ' "$file" | pbcopy
  echo "Copied last command output!"
}

# 事前に許可したファイルしかrmしないようにする
# https://zenn.dev/kawarimidoll/articles/70e473a198badf
rm() {
  rm_abort() {
    echo "'rm' is dangerous command! Use 'trash' instead."
    echo "For symlinks, use 'unlink'. For empty directories, use 'rmdir'."
    echo "AI Agents are not permitted to use 'trash' command too. Request the user to delete the files."
    return 1
  }

  # 安全に削除できるファイル名を連想配列で定義
  local -A safe_files=(
    [".DS_Store"]=1
    [".direnv"]=1
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
    # /tmp以下、TMPDIR以下、.cache以下のファイルは許可
    if [[ "$arg" == /tmp/* ]] \
      || [[ -n "$TMPDIR" && "$arg" == "$TMPDIR"* ]] \
      || [[ "$arg" == */.cache/* ]]; then
      continue
    fi

    # safe_filesに登録されているファイル名は許可
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

# Git worktree helper functions

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

direnv() {
  command direnv "$@"
  local exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    echo ""
    echo "direnv command failed!"
    echo "Did you forget to create .envrc?"
    echo "to use nix direnv, run \"echo 'use flake' > .envrc\""
  fi
  return $exit_code
}

# aliasにすると定義したところで評価されてしまうので関数にする必要がある
cdg() {
  cd "$(git rev-parse --show-toplevel)" || return
}

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

clone() {
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
  fzf --header="__CURSOR__ becomes the cursor position" < "${DOT_DIR}/etc/oneliners.txt"  |  \
    perl -pe 's/\[.*?\]//'
}

# -----------------
#  xd - extended cd
# -----------------
# __source "${DOT_DIR}/etc/xd.sh"

# -----------------
#  broot
# -----------------
# __source "${HOME}/.config/broot/launcher/bash/br"

# -----------------
#  OS Setting
# -----------------
# OS='unknown'
if [ "$(uname)" = 'Darwin' ]; then
  # OS='mac'
  source "${DOT_DIR}/.config/sh/mac.sh"
elif [ "$(uname)" = 'Linux' ]; then
  # OS='linux'
  source "${DOT_DIR}/.config/sh/linux.sh"
elif [ "$(uname -s | cut -c-5)" = 'MINGW' ]; then
  # OS='windows'
  # currently no windows settings
  :
fi

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

# cwd(git repo ならそのルート)から一意で短い zmx セッション名を導出。
# 例: ~/dotfiles → dotfiles / ~/ghq/github.com/foo/bar → foo-bar
# session 名はソケットのファイル名になるため /(スラッシュ)不可 → - に置換。
__zmx_session_name() {
  local dir
  dir=$(git -C "${1:-$PWD}" rev-parse --show-toplevel 2>/dev/null || printf '%s' "${1:-$PWD}")
  dir=${dir#"$HOME"/}          # /Users/kawarimidoll/ を除去
  dir=${dir#ghq/github.com/}   # ghq/github.com/ を除去
  dir=${dir#/}                 # 先頭の / を除去(home外の絶対パスで先頭-を防ぐ)
  printf '%s' "${dir//\//-}"   # 残りの / を - に
}

# zmx セッションを fzf で選んで attach。一覧に無い名前を入力すればそのまま新規作成。
# 引数なしなら cwd 由来の名前を初期クエリに入れる。
# 選択=そのセッション / 未マッチのクエリ=新規作成 / ESC=何もしない (bash/zsh 共通)
zmf() {
  local out
  out=$(zmx list --short 2>/dev/null | fzf \
    --no-multi --print-query --query "${1:-$(__zmx_session_name)}" \
    --prompt 'zmx> ' \
    --header 'Enter: attach / New name: create / Esc: cancel' --header-first \
    --preview 'zmx history {} 2>/dev/null | tail -200')
  case $? in 0|1) ;; *) return ;; esac  # 0=選択 / 1=新規クエリ / それ以外(ESC等)は中断
  local name=${out##*$'\n'}
  [[ -n "$name" ]] && zmx attach "$name"
}

# Claude Code を zmx portal モードで起動。全シェルコマンドを zmx run <session> 経由にさせ、
# ユーザーは別ターミナルの `zmx attach <session>` で観察できる (skills/zmx と同じ指示を注入)。
# 第1引数がセッション名(- 始まりでなければ)。省略時は cwd 由来名。残りは claude にそのまま渡す。
zmc() {
  local session
  if [ -n "$1" ] && [ "${1#-}" = "$1" ]; then
    session=$1; shift
  else
    session=$(__zmx_session_name)
  fi
  echo "zmx portal session: ${session}  (observe: zmx attach ${session})"
  # 普段の `cage claude` と同じサンドボックスで起動 (cage が無ければ素の claude)。
  # cage の auto-presets は command 名 claude で解決されるため presets はそのまま効く。
  local -a runner=(claude)
  command -v cage >/dev/null 2>&1 && runner=(cage claude)
  "${runner[@]}" --append-system-prompt "Run ALL shell commands through zmx instead of locally, so the user can observe and audit them via 'zmx attach ${session}'. Use 'zmx run ${session} <cmd>' (synchronous: tails until the command exits and returns its exit code; pass the command unquoted, one at a time). For long-running processes such as dev servers or watchers, add -d so it does not block: 'zmx run ${session} -d <cmd>' (do not wait on it; observe via 'zmx tail ${session}'). Transfer files with 'cat <local> | zmx write ${session} <path>'. Do NOT run commands locally and do NOT use 'zmx attach' (that is for the user). Session name: ${session}." "$@"
}

PATH="${DOT_DIR}/bin:${PATH}"
