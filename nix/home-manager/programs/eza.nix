# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable
{
  programs.eza = {
    enable = true;
    colors = "auto";
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
    ];
  };
}
