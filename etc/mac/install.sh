#!/bin/bash

setup_homebrew() {
  brew_list() {
    grep "$1" brew-list.log | sed 's/.* //'
  }
  which curl >> /dev/null || die "curl is required."
  if ! has "brew"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
  which brew >> /dev/null || die "brew is required."
  brew doctor || die "brew doctor raised error."
  brew update
  if [ -e brew-list.log ]; then
    brew tap "$(brew_list tap)"
    brew install "$(brew_list brew)"
    brew cask install "$(brew_list cask)"
    brew_list brew | grep mas >> /dev/null || brew install mas
    mas install "$(brew_list mas)"
  else
    echo "  brew-list.log is needed."
  fi
  brew cleanup
}

echo "  begin setup homebrew."
setup_homebrew
echo "  end setup homebrew."

echo "  create symlink to iCloud directory."
ln -sniv "$HOME/Library/Mobile Documents" "$HOME/iCloud"

echo "  create symlink to karabiner config file."
karabiner_dir="$HOME/.config/karabiner"
mkdir -p "$karabiner_dir"
ln -sniv karabiner.json "$karabiner_dir/karabiner.json"
