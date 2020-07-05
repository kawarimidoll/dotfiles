#!/bin/sh

echo 'brew doctor'
brew doctor
echo 'brew update'
brew update
echo 'brew upgrade'
brew upgrade
echo 'brew cask upgrade'
brew cask upgrade
echo 'brew cleanup'
brew cleanup
echo 'log list'
echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"' > ~/Desktop/brew-list.log
date >> ~/Desktop/brew-list.log
brew list >> ~/Desktop/brew-list.log
brew cask list >> ~/Desktop/brew-list.log
cp ~/Desktop/brew-list.log brew-list.log
echo 'date'
date
