#!/bin/sh
# homebrew update script

set -x
brew doctor || exit 1
brew update
brew upgrade
brew cask upgrade
brew cleanup
set +x
echo 'log list...'
LOGFILE=brew-list.log
date "+timestamp: %F %T %Z" > $LOGFILE
brew tap       | sed 's/^/tap: /'  >> $LOGFILE
brew leaves    | sed 's/^/brew: /' >> $LOGFILE
brew cask list | sed 's/^/cask: /' >> $LOGFILE
mas list       | sed 's/^/mas: /'  >> $LOGFILE
echo 'done.'
