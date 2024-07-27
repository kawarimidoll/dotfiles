{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  username = "kawarimidoll";
in {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";

    packages = with pkgs; [
      bat
      bottom
    ];
  };

  programs.home-manager.enable = true;
}
