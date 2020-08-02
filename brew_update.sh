#!/bin/sh

set -x
brew doctor
brew update
brew upgrade
brew cask upgrade
brew cleanup
set +x
echo 'log list...'
LOGFILE=brew-list.log
echo 'logged:' > $LOGFILE
date "+%F %T %Z" | tee -a $LOGFILE
echo 'tap:' >> $LOGFILE
brew tap >> $LOGFILE
echo 'brew:' >> $LOGFILE
brew leaves >> $LOGFILE
echo 'cask:' >> $LOGFILE
brew cask list >> $LOGFILE
echo 'mas:' >> $LOGFILE
mas list >> $LOGFILE
echo 'done.'
