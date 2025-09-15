#!/bin/bash
set -e  # エラー発生時に終了

# XDG環境変数のデフォルト値を設定
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

DOT_DIR="${HOME}/dotfiles"
GITHUB_URL="https://github.com/kawarimidoll/dotfiles"
LOGO='
       _       _    __ _ _
    __| | ___ | |_ / _(_) | ___  ___
   / _` |/ _ \| __| |_| | |/ _ \/ __|
  | (_| | (_) | |_|  _| | |  __/\__ \
   \__,_|\___/ \__|_| |_|_|\___||___/
'
DIALOG="
  author: @kawarimidoll
  repository: $GITHUB_URL

  This script includes:
  (1) download dotfiles
  (2) link dotfiles
  (3) setup applications

  Select:
  [a] run all above
  [d] only download dotfiles
  [l] only link dotfiles
  [s] only setup applications
  You can use multiple choose like 'dl'
"
# ref:
# https://qiita.com/b4b4r07/items/24872cdcbec964ce2178

has() {
  type "$1" > /dev/null 2>&1
}
die() {
  echo "$1"
  echo "  terminated."
  exit 1
}
die_if_error() {
  if [ $? -ne 0 ]; then
    die "Error occurred during $1"
  fi
}

OS='unknown'
if [ "$(uname)" = "Darwin" ]; then
  OS='mac'
elif [ "$(uname)" = "Linux" ]; then
  OS='linux'
elif [ "$(uname -s | cut -c-5)" = "MINGW" ]; then
  OS='windows'
fi

download_dotfiles() {
  if [ -d "$DOT_DIR" ]; then
    echo "$DOT_DIR is already exist"
  else
    if has "git"; then
      git clone --recursive "$GITHUB_URL" "$DOT_DIR"
      die_if_error "git clone"
    elif has "curl" || has "wget"; then
      local tarball_url="${GITHUB_URL}/archive/master.tar.gz"
      if has "curl"; then
        curl -L "$tarball_url"
      else
        wget -O - "$tarball_url"
      fi | tar xv
      die_if_error "download and extract"
      mv -f dotfiles-master "$DOT_DIR"
      die_if_error "move directory"
    else
      die "cannot download dotfiles."
    fi
  fi
}

link_dotfiles() {
  cd "$DOT_DIR" || die "cannot cd to $DOT_DIR"
  local skipped_files=()
  for f in $( (git ls-files; git untracked) | grep -E '^\.' | grep -vE 'deprecated|\.git')
  do
    mkdir -p "$HOME/$(dirname "$f")"
    die_if_error "create directory $f"
    if [ -L "$HOME/$f" ]; then
      # 既存リンクのリンク先を取得
      existing_target=$(readlink "$HOME/$f")
      if [ "$existing_target" = "$DOT_DIR/$f" ]; then
        # 既に正しいリンクがあるのでスキップ
        echo "skip (already exists): $f"
        continue
      fi
    fi
    ln -sniv "$DOT_DIR/$f" "$HOME/$f" || { skipped_files+=("$f"); }
  done
  if [ ${#skipped_files[@]} -gt 0 ]; then
    echo ''
    echo "Skipped files:"
    for sf in "${skipped_files[@]}"; do
      echo "  $sf"
    done
    echo ''
  fi
}

echo "$LOGO" "$DIALOG"
read -r selection
if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"d"* ]]; then
  echo "  begin download dotfiles."
  download_dotfiles
  echo "  end download dotfiles."
  echo ''
fi
if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"l"* ]]; then
  echo "  begin link dotfiles."
  link_dotfiles

  mkdir -p "${XDG_CACHE_HOME}/less"
  mkdir -p "${XDG_STATE_HOME}/zsh"
  mkdir -p "${XDG_DATA_HOME}/terminfo"
  echo "  end link dotfiles."
  echo ''
fi
if [[ "$selection" = *"a"* ]] || [[ "$selection" = *"s"* ]]; then
  echo "  begin setup applications."

  os_install_sh="${DOT_DIR}/etc/${OS}/install.sh"
  [ -f "$os_install_sh" ] && sh -c "$os_install_sh"
  echo "  end setup applications."
  echo ''
fi

echo "  finished."
