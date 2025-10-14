#!/bin/bash

# echo "  create symlink to iCloud directory."
# ln -sniv "$HOME/Library/Mobile\ Documents" "$HOME/iCloud"

echo ""
echo "  Next step: Download Xcode from AppStore."
echo "  After download, run commands below to setup applications."
echo ""
echo "  sudo xcodebuild -license"
echo "  xcode-select --install"
echo "  (for Apple Silicon Mac) sudo softwareupdate --install-rosetta"
echo "  bash ~/dotfiles/etc/mac/setup-brew.sh"
