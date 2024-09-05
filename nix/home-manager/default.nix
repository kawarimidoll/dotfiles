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
    overlays = [
      (inputs.vim-overlay.overlays.features {
        compiledby = "kawarimidoll-nix";
        lua = true;
        cscope = true;
        sodium = true;
        ruby = true;
        python3 = true;
      })
      inputs.neovim-nightly-overlay.overlays.default
    ];
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
      git
      jj
      curl
      jq
      ripgrep
      eza
      alejandra
      bat
      bottom
      bun

      vim # latest

      neovim # nighly
    ];
  };

  programs.home-manager.enable = true;
}
