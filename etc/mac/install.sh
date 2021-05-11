#!/bin/bash

echo "  create symlink to iCloud directory."
ln -sniv "$HOME/Library/Mobile\ Documents" "$HOME/iCloud"

echo "  enable key-repeating for VScodeVim."
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false    # For VS Codium

echo ""
echo "  Next step: Download Xcode from AppStore."
echo "  After download, run commands below to setup applications."
echo ""
echo "  sudo xcodebuild -license"
echo "  xcode-select --install"
echo "  (for Apple Silicon Mac) sudo softwareupdate --install-rosetta"
echo "  bash $DOT_DIR/etc/mac/setup-brew.sh"
