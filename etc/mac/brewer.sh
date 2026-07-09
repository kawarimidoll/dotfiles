#!/bin/bash
# homebrew update script

BREWFILE="$(dirname "$0")/Brewfile"

set -ex

date -Iseconds

brew doctor
brew update
brew upgrade --fetch-HEAD
brew upgrade --cask
brew cleanup -s

{
  date "+# timestamp: %F %T %Z"
  brew bundle dump --no-vscode --no-go --no-cargo --no-flatpak --no-uv --no-describe --file=-
} > "$BREWFILE"
wc -l "$BREWFILE"
echo 'done.'
