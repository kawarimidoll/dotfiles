#!/bin/bash
# homebrew update script

set -e

brew_with_echo() {
  echo "brew $*"
  brew "$@"
}

date -Iseconds

brew_with_echo doctor
brew_with_echo update
brew_with_echo upgrade --fetch-HEAD
brew_with_echo upgrade --cask
brew_with_echo cleanup -s

echo 'log list...'
{
  date "+timestamp: %F %T %Z"
  brew tap         | sed 's/^/tap: /'
  brew leaves      | sed 's/^/brew: /'
  brew list --cask | sed 's/^/cask: /'
  mas-list | sort             | sed 's/^/mas: /'
} > "${DOT_OS_DIR}/brew-list.log"
echo 'done.'
