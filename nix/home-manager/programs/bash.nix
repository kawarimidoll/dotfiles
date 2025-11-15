# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enable
{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFile = "${config.xdg.dataHome}/bash/history";
    historyFileSize = 2000;

    shellOptions = [
      "autocd"
      "cdspell"
      "checkjobs"
      "checkwinsize"
      "cmdhist"
      "direxpand"
      "dirspell"
      "dotglob"
      "extglob"
      "globstar"
      "histappend"
      "histreedit"
      "histverify"
      "nocaseglob"
    ];

    # Environment variables needed for settings.sh
    sessionVariables = {
      shell_rc = "${config.home.homeDirectory}/.bashrc";
    };

    # Shell initialization
    initExtra = ''
      # Ensure macOS native stty is used for ble.sh compatibility
      # Temporarily prepend /bin to PATH so ble.sh uses native stty (issue #63)
      _ble_init_saved_path=$PATH
      export PATH="/bin:$PATH"

      # Load ble.sh (Bash Line Editor)
      source "$(blesh-share)"/ble.sh --noattach

      # Restore original PATH
      export PATH=$_ble_init_saved_path
      unset _ble_init_saved_path

      # Helper function for safe sourcing
      __source() {
        [ -f "$1" ] && source "$1"
      }

      # Load common shell settings (shared with zsh)
      __source "$DOT_DIR/.config/sh/settings.sh"

      # Load local settings (optional, user-specific)
      __source "$DOT_DIR/.config/bash/.bashrc"
      __source ~/.bashrc.local

      # Attach ble.sh after all other configurations
      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
  };
}
