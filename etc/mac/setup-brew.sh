#!/bin/bash

die() {
  echo "$1"
  echo "  terminated."
  exit 1
}
brew_list="${DOT_OS_DIR}/brew-list.log"

which curl >> /dev/null || die "curl is required."
which brew >> /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
which brew >> /dev/null || die "brew is required."
# git -C $(brew --repo homebrew/core) checkout master
brew doctor || die "brew doctor raised error."
brew update

if [ -e "$brew_list" ]; then
  grep ^tap: "$brew_list"  | sed 's/tap: //'  | xargs -I_ brew tap _
  grep ^brew: "$brew_list" | sed 's/brew: //' | xargs brew install
  grep ^cask: "$brew_list" | sed 's/cask: //' | xargs brew install --cask
  which mas >> /dev/null || brew install mas
  grep -o '^mas: [0-9]\+' "$brew_list" | sed 's/mas: //' | xargs mas install
else
  echo "  brew-list.log is needed."
fi
brew cleanup

symlinks_dir="$DOT_DIR/etc/mac/symlinks"
mkdir -p "$symlinks_dir"
ln -sf "$(brew --prefix)/opt/coreutils/libexec/gnubin" "$symlinks_dir/core_gnubin"
ln -sf "$(brew --prefix)/opt/findutils/libexec/gnubin" "$symlinks_dir/find_gnubin"

ln -sf "$(brew --prefix)" "$HOME/homebrew"
