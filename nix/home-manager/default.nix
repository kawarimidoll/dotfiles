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
        binutils
        bottom
        buf
        bun
        clang-tools # clang-format
        coreutils
        graphqurl
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
        helix
        highlight
        imagemagick
        jid
        jj
        jnv
        jq
        lazydocker
        lazygit
        lazysql
        libsixel
        logdy
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
        oxker
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

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batpipe
      batwatch
      prettybat
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lsd.enable
  programs.lsd.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.eza.enable
  programs.eza = {
    enable = true;
    colors = "auto";
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
  programs.zsh = {
    dotDir = ".config/zsh";
    enable = true;
    enableCompletion = true;
    # https://gist.github.com/ctechols/ca1035271ad134841284?permalink_comment_id=2158147#gistcomment-2158147
    # https://gist.github.com/ctechols/ca1035271ad134841284?permalink_comment_id=3994613#gistcomment-3994613
    completionInit = ''
      autoload -Uz compinit
      for dump in ${"ZDOTDIR:-$HOME"}/.zcompdump(N.mh+24); do
        echo "Run compinit. Wait for a while."
        compinit
      done
      compinit -C
    '';
    autocd = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    history = {
      append = true;
      ignoreAllDups = true;
      # ignoreDups = true; ignoreAllDupsがあれば不要
      ignoreSpace = true;
      share = true;
    };
    syntaxHighlighting.enable = true;
    zsh-abbr = {
      enable = true;
      abbreviations = {
        g = "git";
        gco = "git checkout";
      };
    };
    initExtra = ''
      source ~/dotfiles/.zshrc
      source ~/.nix-profile/share/zsh/zsh-autopair/autopair.zsh
    '';
  };
}
