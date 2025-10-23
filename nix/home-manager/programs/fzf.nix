# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
{
  programs.fzf = {
    enable = true;

    defaultOptions = [
      "--height=40%"
      "--reverse"
      "--border"
    ];

    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [
      "--preview 'bat --line-range :50 {}'"
    ];

    historyWidgetOptions = [
      "--reverse"
    ];
  };
}
