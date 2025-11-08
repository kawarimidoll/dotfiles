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
        koi = inputs.koi.packages.${pkgs.system}.default;
        cage = inputs.cage.packages.${pkgs.system}.default;
      in
      with pkgs;
      [
        koi
        cage

        act
        asciiquarium
        ast-grep
        astroterm
        atuin
        bash-language-server
        beautysh
        binutils
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
        coreutils
        cowsay
        croc
        csview
        csvlens
        csvq
        curl
        delta
        deno
        diff-so-fancy
        diffnav
        diffutils
        djlint
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
        jid
        jnv
        jq
        jqp
        just
        just-lsp
        lavat
        lazydocker
        lazygit
        lazyssh
        libcaca
        libsixel
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
        nil
        nim
        nix-output-monitor
        nix-search-cli
        nixfmt-rfc-style
        nodejs_22
        nurl
        nyancat
        pnpm
        procs
        presenterm
        qq
        rainfrog
        rebar3
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
        sttr
        stylua
        superfile
        superhtml
        termbg
        termdown
        terminaltexteffects
        termshot
        termsnap
        termsvg
        termusic
        tokei
        tombi
        treefmt
        ttyper
        typescript-go
        typos-lsp
        tz
        unzip
        usql
        uv
        vhs
        vim # latest
        vim-startuptime
        walk
        watchexec
        wget
        wtfutil
        xh
        xplr
        yarn
        yazi
        zig
        zls

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
        # vim-language-server
      ];
  };

  # environment.pathsToLink = [ "/share/zsh" ];

  programs.home-manager.enable = true;

  imports = [
    ./programs/bash.nix
    ./programs/direnv.nix
    ./programs/eza.nix
    ./programs/fzf.nix
    ./programs/gh.nix
    ./programs/nnn.nix
    ./programs/zsh.nix
  ];

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
  programs.bat.enable = true;

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
