# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
{
  programs.fzf = {
    enable = true;

    defaultCommand = "fd --type f";
    defaultOptions = [
      "--height=40%"
      "--reverse"
      "--border"
    ];

    fileWidgetCommand = "fffe -f";
    fileWidgetOptions = [ "--preview 'bat --line-range :30 {}'" ];

    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview 'tree {} | head -30'" ];

    historyWidgetOptions = [ "--reverse" ];
  };
}
