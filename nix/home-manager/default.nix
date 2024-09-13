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
      cargo
      clippy
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
      gnumake
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
      rust-analyzer
      rustfmt
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
      watchexec
      wget
      yarn
      zig
      zsh-autopair

      nodePackages.typescript-language-server

      # rmw
      # vim-language-server
    ];
  };

  # environment.pathsToLink = [ "/share/zsh" ];

  programs.home-manager.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      package = pkgs.zsh-syntax-highlighting;
    };
    initExtra = ''
      source ~/dotfiles/.zshrc
      source ~/.nix-profile/share/zsh/zsh-autopair/autopair.zsh
    '';
  };
}
