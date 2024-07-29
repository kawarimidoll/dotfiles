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
      (final: prev: {
        vim = prev.vim.overrideAttrs (oldAttrs: {
          version = "latest";
          src = inputs.vim-src;
          configureFlags =
            oldAttrs.configureFlags
            ++ [
              "--enable-terminal"
              "--with-compiledby=nix-home-manager"
              "--enable-luainterp"
              "--with-lua-prefix=${prev.lua}"
              "--enable-fail-if-missing"
            ];
          buildInputs =
            oldAttrs.buildInputs
            ++ [prev.gettext prev.lua prev.libiconv];
        });
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

      vim # latest

      neovim # nighly
    ];
  };

  programs.home-manager.enable = true;
}
