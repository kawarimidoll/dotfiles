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
        atuin
        bash-language-server
        beautysh
        binutils
        bottom
        broot
        buf
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
        dprint
        efm-langserver
        emacs
        erlang_27
        ffmpeg_7-full
        findutils
        fx
        fzf
        gawk
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
        gollama
        graphqurl
        grex
        grpcui
        grpcurl
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
        libsixel
        lnav
        logdy
        ltex-ls
        lua-language-server
        macchina
        mcfly
        moreutils
        nano
        nb
        nh
        nurl
        neofetch
        neovim # nightly
        nil
        nim
        nix-output-monitor
        nix-search-cli
        nix-zsh-completions
        nixfmt-rfc-style
        nodejs_22
        nyancat
        ollama
        oxker
        pnpm
        rainfrog
        rebar3
        riffdiff
        ripgrep
        rustup
        silicon
        procs
        slides
        starship
        sttr
        stylua
        superhtml
        tokei
        typos-lsp
        tz
        unzip
        usql
        vim # latest
        vim-startuptime
        vtsls
        walk
        watchexec
        wget
        xplr
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

  # # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.ghostty.enable
  # programs.ghostty = {
  #   enable = true;
  #   clearDefaultKeybinds = true;
  # };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.enable
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
    extensions = with pkgs; [
      gh-copilot
      gh-dash
      gh-markdown-preview
      (pkgs.stdenv.mkDerivation rec{
        pname = "gh-q";
        name = pname;
        version = "latest";
        src = pkgs.fetchFromGitHub {
          owner = username;
          repo = pname;
          rev = "a312c67b92baefadb07481ef1479c96d91243d41";
          hash = "sha256-cpR4ZxWobr1dyGr+zNr0IUa1yYlZK3sDz4m9LWjkRsc=";
        };
        installPhase = ''
          mkdir -p $out/bin
          cp $src/gh-q $out/bin/
          chmod +x $out/bin/gh-q
        '';
      })
      (pkgs.stdenv.mkDerivation rec{
        pname = "gh-graph";
        name = pname;
        version = "latest";
        src = pkgs.fetchFromGitHub {
          owner = username;
          repo = pname;
          rev = "16cc618618bbe7c9a745091b2f4eea74114ab967";
          hash = "sha256-CW1eIcjy1VuZxgfHPOpgO2Zo13XOw4SVJKW0FFCV3kM=";
        };
        installPhase = ''
          mkdir -p $out/bin
          cp $src/gh-graph $out/bin/
          chmod +x $out/bin/gh-graph
        '';
      })
    ];
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nnn.enable
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
  };

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

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bun.enable
  programs.bun.enable = true;

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
    historySubstringSearch = {
      enable = true;
      searchDownKey = "^N";
      searchUpKey = "^P";
    };
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
        "-" = "cd -";
        d = "docker";
        dp = "docker compose";
        g = "git";
        "git -" = "git switch -";
        gco = "git checkout";
      };
    };
    initExtra = ''
      source ~/dotfiles/.zshrc
      source ~/.nix-profile/share/zsh/zsh-autopair/autopair.zsh
    '';
  };
}
