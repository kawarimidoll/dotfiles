#!/bin/bash

# echo "  create symlink to iCloud directory."
# ln -sniv "$HOME/Library/Mobile\ Documents" "$HOME/iCloud"

echo "  create symlink to lazygit config directory."
mkdir -p "$HOME/Library/Application Support/jesseduffield/lazygit"
ln -sf "$HOME/.config/lazygit/config.yml" "$HOME/Library/Application Support/jesseduffield/lazygit/config.yml"

# echo "  create symlink to homebrew directory."
# https://stackoverflow.com/questions/65259300/detect-apple-silicon-from-command-line
# if [[ "$(uname -m)" == 'arm64' ]]; then
#   ln -sf "/opt/homebrew" "$HOME/homebrew"
# else
#   ln -sf "/usr/local" "$HOME/homebrew"
# fi

# echo "  enable key-repeating for VScodeVim."
# defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false         # For VS Code
# defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false # For VS Code Insider
# defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false    # For VS Codium

echo ""
echo "  Next step: Download Xcode from AppStore."
echo "  After download, run commands below to setup applications."
echo ""
echo "  sudo xcodebuild -license"
echo "  xcode-select --install"
echo "  (for Apple Silicon Mac) sudo softwareupdate --install-rosetta"
echo "  bash ~/dotfiles/etc/mac/setup-brew.sh"
