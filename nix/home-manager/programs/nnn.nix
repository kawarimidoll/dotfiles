# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nnn.enable
{ pkgs, ... }:
{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
  };
}
