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
    stateVersion = "24.11";

    packages =
      let
        koi = inputs.koi.packages.${pkgs.system}.default;
      in
      with pkgs;
      [
        koi

        act
        astroterm
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
        delta
        deno
        diff-so-fancy
        diffutils
        direnv
        djlint
        efm-langserver
        emacs
        erlang_27
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
        git-trim # build failed
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
        helix
        highlight
        imagemagick
        jid
        jj
        jnv
        jq
        lazygit
        libsixel
        logdy
        logdy
        lsd
        ltex-ls
        lua-language-server
        macchina
        moreutils
        nano
        nb
        neofetch
        neovim # nightly
        nim
        nix-search-cli
        nix-zsh-completions
        nixfmt-rfc-style
        nodejs_22
        nyancat
        pnpm
        rainfrog
        rebar3
        ripgrep
        rustup
        silicon
        slides
        starship
        sttr
        stylua
        superhtml
        tokei
        tree
        typos-lsp
        tz
        unzip
        vim # latest
        vim-startuptime
        watchexec
        wget
        yarn
        yazi
        zig
        zsh-autopair

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
