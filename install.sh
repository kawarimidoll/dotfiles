#!/bin/bash

DOTDIR="${HOME}/dotfiles"
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
  (3) setup homebrew

  select:
  [a] run all above
  [d] only download dotfiles
  [l] only link dotfiles
  [s] only setup homebrew
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

download_dotfiles() {
  if [ -d "$DOTDIR" ]; then
    echo "$DOTDIR is already exist"
  else
    if has "git"; then
      git clone --recursive "$GITHUB_URL" "$DOTDIR"
    elif has "curl" || has "wget"; then
      local tarball_url="${GITHUB_URL}/archive/master.tar.gz"
      if has "curl"; then
        curl -L "$tarball_url"
      else
        wget -O - "$tarball_url"
      fi | tar xv
      mv -f dotfiles-master "$DOTDIR"
    else
      die "cannot download dotfiles."
    fi
  fi
}

link_dotfiles() {
  cd "$DOTDIR"
  if [ $? -ne 0 ]; then
    echo "cannot cd to $DOTDIR"
  else
    for f in `find . -not -path '*.git/*' -not -path '*.DS_Store' -path '*/.*' -type f -print | cut -b3-`
    do
      ln -sniv "$DOTDIR/$f" "$HOME/$f"
    done
  fi
}

setup_homebrew() {
  brew_list() {
    cat brew-list.log | grep $1 | awk 'BEGIN{ORS=" "}{print $2}'
  }
  which curl >> /dev/null || die "curl is required."
  if !has "brew"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  which brew >> /dev/null || die "brew is required."
  brew doctor || die "brew doctor raised error."
  brew update
  if [ -e brew-list.log ]; then
    brew tap $(brew_list tap)
    brew install $(brew_list brew)
    brew cask install $(brew_list cask)
    brew_list brew | grep mas >> /dev/null || brew install mas
    mas install $(brew_list mas)
  else
    echo "  brew-list.log is needed."
  fi
  brew cleanup
}

echo "$LOGO" "$DIALOG"
read selection
if [ $selection = "a" -o $selection = "d" ]; then
  echo "  begin download dotfiles."
  download_dotfiles
  echo "  end download dotfiles."
  echo ""
fi
if [ $selection = "a" -o $selection = "l" ]; then
  echo "  begin link dotfiles."
  link_dotfiles
  echo "  end link dotfiles."
  echo ""
fi
if [ $selection = "a" -o $selection = "s" ]; then
  echo "  begin setup homebrew."
  setup_homebrew
  echo "  end setup homebrew."
  echo ""
fi

echo "  finished."