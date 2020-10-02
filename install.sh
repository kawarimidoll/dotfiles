#!/bin/bash

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

  select:
  [a] run all above
  [d] only download dotfiles
  [l] only link dotfiles
  [s] only setup applications
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

__source() {
  [ -f "$1" ] && source "$1"
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
    elif has "curl" || has "wget"; then
      local tarball_url="${GITHUB_URL}/archive/master.tar.gz"
      if has "curl"; then
        curl -L "$tarball_url"
      else
        wget -O - "$tarball_url"
      fi | tar xv
      mv -f dotfiles-master "$DOT_DIR"
    else
      die "cannot download dotfiles."
    fi
  fi
}

link_dotfiles() {
  cd "$DOT_DIR"
  if [ $? -ne 0 ]; then
    echo "cannot cd to $DOT_DIR"
  else
    for f in $(find . -not -path '*.git/*' -not -path '*.DS_Store' -path '*/.*' -type f -print | cut -b3-)
    do
      ln -sniv "$DOT_DIR/$f" "$HOME/$f"
    done
  fi
}

echo "$LOGO" "$DIALOG"
read selection
if [ "$selection" = "a" -o "$selection" = "d" ]; then
  echo "  begin download dotfiles."
  download_dotfiles
  echo "  end download dotfiles."
  echo ""
fi
if [ "$selection" = "a" -o "$selection" = "l" ]; then
  echo "  begin link dotfiles."
  link_dotfiles
  echo "  end link dotfiles."
  echo ""
fi
if [ "$selection" = "a" -o "$selection" = "s" ]; then
  echo "  begin setup applications."
  __source "${DOT_DIR}/etc/${OS}/install.sh"
  echo "  end setup applications."
  echo ""
fi

echo "  finished."
