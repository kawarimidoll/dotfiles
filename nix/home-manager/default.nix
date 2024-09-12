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

      act
      bat
      bat-extras.batdiff
      bat-extras.batgrep
      bat-extras.batman
      bat-extras.batpipe
      bat-extras.batwatch
      bat-extras.prettybat
      binutils
      bottom
      bun
      clang-tools # clang-format
      coreutils
      croc
      csvq
      curl
      deno
      diff-so-fancy
      diffutils
      direnv
      efm-langserver
      emacs
      eza
      ffmpeg_7-full
      findutils
      fx
      fzf
      gawk
      gh
      ghq
      gifsicle
      git
      git-extras
      git-interactive-rebase-tool
      git-quick-stats
      git-recent
      git-trim
      git-workspace
      gleam
      gnugrep
      gnupg
      gnused
      gnutar
      go
      grex
      gum
      highlight
      imagemagick
      jid
      jj
      jnv
      jq
      lazygit
      libsixel
      lsd
      lua-language-server
      macchina
      moreutils
      nano
      neofetch
      neovim # nightly
      nix-zsh-completions
      nixfmt-rfc-style
      nodejs_22
      pnpm
      ripgrep
      rustup
      silicon
      slides
      starship
      sttr
      stylua
      tokei
      tree
      tz
      unzip
      vim # latest
      wget
      yarn
      zig
      zsh
      zsh-autocomplete
      zsh-autopair
      zsh-autosuggestions
      zsh-completions
      zsh-fast-syntax-highlighting

      nodePackages.typescript-language-server

      # rmw
      # vim-language-server
    ];
  };

  programs.home-manager.enable = true;
}
