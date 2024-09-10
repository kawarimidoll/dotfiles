{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  username = "kawarimidoll";
in
{
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
      bat
      bat-extras.batman
      bat-extras.batpipe
      bat-extras.batgrep
      bat-extras.batdiff
      bat-extras.batwatch
      bat-extras.prettybat
      bottom
      bun
      cargo
      csvq
      curl
      deno
      direnv
      eza
      git
      gleam
      go
      gnugrep
      jj
      jq
      lsd
      lua-language-server
      nixfmt-rfc-style
      pnpm
      ripgrep
      rust-analyzer
      stylua
      vim-language-server
      yarn
      zig

      vim # latest
      neovim # nighly

      nodePackages.typescript-language-server
    ];
  };

  programs.home-manager.enable = true;
}
