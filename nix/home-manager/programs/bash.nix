# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bash.enable
{ pkgs, config, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [ "ignoreboth" ];
    historySize = 1000;
    historyFileSize = 2000;

    shellOptions = [
      "checkwinsize"
      "direxpand"
      "extglob"
      "globstar"
      "histappend"
      "nocaseglob"
    ];

    # Environment variables needed for settings.sh
    sessionVariables = {
      shell_rc = "${config.home.homeDirectory}/.bashrc";
    };

    # Shell initialization
    initExtra = ''
      # Helper function for safe sourcing
      __source() {
        [ -f "$1" ] && source "$1"
      }

      # Load common shell settings (shared with zsh)
      __source "$DOT_DIR/.config/sh/settings.sh"

      # Load local settings (optional, user-specific)
      __source ~/.bashrc.local

      # Oneliners function with keybinding
      oneliners() {
        local oneliner=$(__get_oneliners) || return 1
        READLINE_LINE="''${oneliner//__CURSOR__/}"
        READLINE_POINT=''${#''${oneliner%%__CURSOR__*}}
      }
      bind -x '"^x":"oneliners"'
    '';
  };
}
