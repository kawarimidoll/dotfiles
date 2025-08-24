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
        cage = inputs.cage.packages.${pkgs.system}.default;
      in
      with pkgs;
      [
        koi
        cage

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
        cmatrix
        coreutils
        croc
        csvq
        curl
        delta
        deno
        diff-so-fancy
        diffutils
        djlint
        dprint
        dust
        efm-langserver
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
        # logdy
        git-workspace
        gleam
        globe-cli
        glsl_analyzer
        glslang
        gnugrep
        gnumake
        gnupg
        gnused
        gnutar
        go
        graphqurl
        grex
        grpcui
        grpcurl
        gum
        helix
        highlight
        imagemagick
        jid
        jnv
        jq
        lavat
        lazydocker
        lazygit
        libsixel
        lnav
        lolcat
        ltex-ls
        lua-language-server
        macchina
        mcfly
        moreutils
        nano
        nb
        neo
        neovim # nightly
        nh
        nil
        nim
        nix-output-monitor
        nix-search-cli
        nix-zsh-completions
        nixfmt-rfc-style
        nodejs_22
        nurl
        nyancat
        # oxker
        pnpm
        procs
        rainfrog
        rebar3
        ripgrep
        rustup
        silicon
        sl
        slides
        starship
        sttr
        stylua
        superhtml
        termdown
        terminaltexteffects
        tokei
        typos-lsp
        tz
        unzip
        usql
        uv
        vhs
        vim # latest
        vim-startuptime
        vtsls
        walk
        watchexec
        wget
        xh
        xplr
        yarn
        yazi
        zig
        zsh-autopair

        gg-jj
        jj-fzf
        jjui
        lazyjj

        hackgen-nf-font
        moralerspace
        nerd-fonts.departure-mono
        nerd-fonts.symbols-only
        noto-fonts-color-emoji
        scientifica
        twitter-color-emoji
        udev-gothic-nf

        # rmw
        # vim-language-server
        # emacs build failed
      ];
  };

  # environment.pathsToLink = [ "/share/zsh" ];

  programs.home-manager.enable = true;

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
      gh-notify
      (pkgs.stdenv.mkDerivation rec {
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
      (pkgs.stdenv.mkDerivation rec {
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

  imports = [
    ./programs/bat.nix
    ./programs/direnv.nix
    ./programs/eza.nix
    ./programs/nnn.nix
    ./programs/zsh.nix
  ];

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bun.enable
  programs.bun.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fd.enable
  programs.fd.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.fastfetch.enable
  programs.fastfetch.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.jujutsu.enable
  programs.jujutsu.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.less.enable
  programs.less.enable = true;
  programs.lesspipe.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.lsd.enable
  programs.lsd.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gitui.enable
  programs.gitui.enable = true;

}
