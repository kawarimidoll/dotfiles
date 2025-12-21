#!/bin/bash
# homebrew update script

set -ex

date -Iseconds

brew doctor
brew update
brew upgrade --fetch-HEAD
brew upgrade --cask
brew cleanup -s

{
  date "+# timestamp: %F %T %Z"
  brew bundle dump --no-vscode --no-go --no-flatpak --file=-
} > "$(dirname "$0")/Brewfile"
wc -l "$(dirname "$0")/Brewfile"
echo 'done.'
