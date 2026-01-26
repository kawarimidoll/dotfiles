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

    sessionVariables = {
      DOT_DIR = "${config.home.homeDirectory}/dotfiles";
    };

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.11";

    packages =
      let
        system = pkgs.stdenv.hostPlatform.system;
        koi = inputs.koi.packages.${system}.default;
        cage = inputs.cage.packages.${system}.default;
        arto = inputs.arto.packages.${system}.default;
        version-lsp = inputs.version-lsp.packages.${system}.default;
        hjkls = inputs.hjkls.packages.${system}.default;
        nur = inputs.nur-packages.packages.${system};
      in
      with pkgs;
      [
        koi
        cage
        arto
        hjkls
        version-lsp

        nur.difit
        nur.ghost
        nur.jsmigemo
        nur.kakehashi
        nur.lolcrab
        nur.plamo-translate
        nur.rustmigemo
        nur.rxpipes
        nur.stormy

        act
        ad
        asciiquarium
        ast-grep
        astroterm
        atuin
        bash-language-server
        beautysh
        binutils
        blesh
        bottom
        broot
        buf
        carl
        cbonsai
        cfonts
        chawan
        clang-tools # clang-format
        cmatrix
        codex
        container # apple-container
        # coreutils
        croc
        csview
        csvlens
        csvq
        curl
        delta
        deno
        diff-so-fancy
        diffnav
        # diffutils
        doxx
        dprint
        dust
        efm-langserver
        emmylua-check
        emmylua-ls
        erlang_27
        ffmpeg_7-full
        findutils
        fx
        gawk
        gemini-cli
        genact
        ghq
        gifsicle
        git
        git-extras
        git-interactive-rebase-tool
        git-quick-stats
        git-recent
        git-trim
        git-workspace
        github-copilot-cli
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
        gonzo
        gopls
        graphqurl
        grex
        grpcui
        grpcurl
        gum
        helix
        highlight
        hyperfine
        imagemagick
        intelli-shell
        jid
        jnv
        jq
        jqp
        just
        just-lsp
        kew
        lavat
        lazydocker
        lazygit
        lazyssh
        libcaca
        libsixel
        libwebp
        lnav
        logdy
        lolcat
        ltex-ls
        lua-language-server
        macchina
        mcat
        mcfly
        moreutils
        nano
        nb
        neo
        neovim # nightly
        nh
        ni
        nim
        nix-output-monitor
        nix-search-cli
        nixd
        nixfmt
        nodejs_22
        nurl
        nyancat
        ov
        pnpm
        posting
        presenterm
        procs
        qq
        qrtool
        rainfrog
        rebar3
        resterm
        restman
        ripgrep
        rustup
        sampler
        screenfetch
        serie
        sheldon
        sig
        silicon
        sl
        slides
        sqlit-tui
        sttr
        stylua
        superfile
        superhtml
        tailspin
        termbg
        termdown
        terminaltexteffects
        termshot
        termsnap
        termsvg
        # termusic
        tokei
        tombi
        treefmt
        ttyper
        tuios
        typescript-go
        typos-lsp
        tz
        unixtools.procps # watch ps sysctl top
        unzip
        usql
        uutils-coreutils-noprefix
        uutils-diffutils
        uv
        vhs
        vim # latest
        vim-startuptime
        walk
        watchexec
        wget
        wtfutil
        xh
        xleak
        xplr
        yarn
        yazi
        zig
        zls

        zsh

        pokemonsay
        kittysay

        jj-fzf
        jjui

        hackgen-nf-font
        moralerspace
        nerd-fonts.departure-mono
        nerd-fonts.symbols-only
        noto-fonts-color-emoji
        scientifica
        twitter-color-emoji
        udev-gothic-nf

        # emacs
        # gg-jj
        # lazyjj
        # oxker
        # rmw
      ];
  };

  # environment.pathsToLink = [ "/share/zsh" ];

  programs.home-manager.enable = true;

  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./programs/bash.nix
    ./programs/bat.nix
    ./programs/direnv.nix
    ./programs/eza.nix
    ./programs/fzf.nix
    ./programs/gh.nix
    ./programs/nnn.nix
  ];

  # https://github.com/nix-community/nix-index-database
  programs.nix-index-database.comma.enable = true;

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

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.enable
  programs.nushell.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gitui.enable
  # programs.gitui.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship.enable = true;
}
