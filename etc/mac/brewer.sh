#!/bin/bash
# homebrew update script

set -e

date -Iseconds

(
  set -x
  brew doctor
  brew update
  brew upgrade --fetch-HEAD
  brew upgrade --cask
  brew cleanup -s
)

echo 'log list...'
{
  date "+timestamp: %F %T %Z"
  brew tap         | sed 's/^/tap: /'
  brew leaves      | sed 's/^/brew: /'
  brew list --cask | sed 's/^/cask: /'
  mas-list | sort             | sed 's/^/mas: /'
} > "$(dirname "$0")/brew-list.log"
echo 'done.'
