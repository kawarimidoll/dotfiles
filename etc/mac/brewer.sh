#!/bin/sh
# homebrew update script

set -x
brew doctor || exit 1
brew update
brew upgrade
brew upgrade --cask
brew cleanup
set +x
echo 'log list...'
logfile="${DOT_DIR}/etc/mac/brew-list.log"
date "+timestamp: %F %T %Z" > $logfile
brew tap         | sed 's/^/tap: /'  >> $logfile
brew leaves      | sed 's/^/brew: /' >> $logfile
brew list --cask | sed 's/^/cask: /' >> $logfile
mas list         | sed 's/^/mas: /'  >> $logfile
echo 'done.'
