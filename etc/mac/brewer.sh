#!/bin/sh
# homebrew update script

set -e
set -x
brew doctor
brew update
brew upgrade
brew upgrade --cask
brew cleanup
set +x
echo 'log list...'
logfile="${DOT_OS_DIR}/brew-list.log"
date "+timestamp: %F %T %Z" > $logfile
brew tap         | sed 's/^/tap: /'  >> $logfile
brew leaves      | sed 's/^/brew: /' >> $logfile
brew list --cask | sed 's/^/cask: /' >> $logfile
mas list         | sed 's/^/mas: /'  >> $logfile
echo 'done.'
