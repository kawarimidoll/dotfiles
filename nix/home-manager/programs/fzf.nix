# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fzf.enable
{
  programs.fzf = {
    enable = true;

    defaultCommand = "fd --type f --hidden --exclude '.git/'";
    defaultOptions = [
      "--height=40%"
      "--reverse"
      "--border"
    ];

    fileWidget = {
      command = "fffe -f";
      options = [ "--preview 'bat --line-range :30 {}'" ];
    };

    changeDirWidget = {
      command = "fd --type d";
      options = [ "--preview 'tree {} | head -30'" ];
    };

    historyWidget.options = [ "--reverse" ];
  };
}
