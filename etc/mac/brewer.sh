#!/bin/bash
# homebrew update script

set -e

brew_fixed_path() {
  env PATH="$(echo "$PATH" | sed -r 's#/opt/chefdk/[^:]+:##g')" brew "$@"
}
brew_with_echo() {
  echo "brew $*"
  brew_fixed_path "$@"
}

brew_with_echo doctor
brew_with_echo update
brew_with_echo upgrade
brew_with_echo upgrade --cask
brew_with_echo cleanup -s

echo 'log list...'
{
  date "+timestamp: %F %T %Z"
  brew_fixed_path tap         | sed 's/^/tap: /'
  brew_fixed_path leaves      | sed 's/^/brew: /'
  brew_fixed_path list --cask | sed 's/^/cask: /'
  mas list | sort             | sed 's/^/mas: /'
} > "${DOT_OS_DIR}/brew-list.log"
echo 'done.'
