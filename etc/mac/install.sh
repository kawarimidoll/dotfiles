#!/bin/bash

echo "  create symlink to iCloud directory."
ln -sniv "$HOME/Library/Mobile Documents" "$HOME/iCloud"

echo "  create symlink to karabiner config file."
karabiner_dir="$HOME/.config/karabiner"
mkdir -p "$karabiner_dir"
ln -sniv karabiner.json "$karabiner_dir/karabiner.json"

echo ""
echo "  Next step: Download Xcode from AppStore."
echo "  After download, run commands below to setup applications."
echo ""
echo "  sudo xcodebuild -license"
echo "  xcode-select --install"
echo "  sudo softwareupdate --install-rosetta"
echo "  bash $DOT_DIR/etc/mac/setup-brew.sh"
