#!/bin/sh

set -x
brew doctor
brew update
brew upgrade
brew cask upgrade
brew cleanup
date
set +x
echo 'log list...'
LOGFILE=~/Desktop/brew-list.log
echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"' > $LOGFILE
date >> $LOGFILE
brew list >> $LOGFILE
brew cask list >> $LOGFILE
cp $LOGFILE ./
echo 'done.'
