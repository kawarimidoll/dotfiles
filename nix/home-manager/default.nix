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
      (inputs.vim-overlay.lib.features {
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
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "claude-code"
          "copilot-cli"
        ];
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
        kakehashi = inputs.kakehashi.packages.${system}.default;
        guard-and-guide = inputs.guard-and-guide.packages.${system}.default;
        hjkls = inputs.hjkls.packages.${system}.default;
        nur = inputs.nur-packages.packages.${system};
        llm-agents = inputs.llm-agents.packages.${system};
        # unstableでビルド不可になった場合の修正用
        # stablePkgs.appの形式で呼ぶことでビルドできるようにする
        # stablePkgs = inputs.nixpkgs-stable.legacyPackages.${system};
      in
      with pkgs;
      [
        guard-and-guide
        koi
        cage
        arto
        hjkls
        version-lsp
        kakehashi

        llm-agents.codex
        llm-agents.copilot-cli
        llm-agents.copilot-language-server

        nur.fff-mcp
        nur.ghost
        nur.jsmigemo
        nur.plamo-translate
        nur.rustmigemo
        nur.rxpipes
        nur.stormy
        nur.zmx

        act3
        agent-browser
        # ast-grep
        # atuin
        bash-language-server
        beautysh
        binutils
        bottom
        carl
        container # apple-container
        clock-rs
        curl
        delta
        deno
        diff-so-fancy
        diffnav
        dprint
        dust
        efm-langserver
        emmylua-check
        emmylua-ls
        ffmpeg_7
        findutils
        gawk
        gemini-cli
        ghq
        gifsicle
        git
        git-extras
        git-filter-repo
        git-interactive-rebase-tool
        git-quick-stats
        git-recent
        git-trim
        git-workspace
        gitleaks
        gleam
        glsl_analyzer
        glslang
        gnugrep
        gnumake
        gnupg
        gnused
        gnutar
        go
        gopls
        grex
        grpcui
        grpcurl
        gum
        helix
        highlight
        hyperfine
        imagemagick
        jq
        just
        just-lsp
        kew
        lazydocker
        lazygit
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
        mergiraf
        moreutils
        nano
        nb
        neovim # nightly
        # nono
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
        ollama
        ov
        pnpm
        presenterm
        procs
        qrtool
        rainfrog
        rebar3
        resterm
        restman
        ripgrep
        rustup
        sampler
        sccache
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
        # superhtml
        tailspin
        termbg
        termdown
        terminaltexteffects
        termshot
        termsnap
        termsvg
        # termusic
        tirith
        tokei
        tombi
        treefmt
        typescript-go
        typos-lsp
        tz
        unixtools.procps # watch ps sysctl top
        unzip
        upterm
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
        xplr
        yazi
        zig

        zsh

        hackgen-nf-font
        moralerspace
        nerd-fonts.departure-mono
        nerd-fonts.symbols-only
        noto-fonts-color-emoji
        twitter-color-emoji
        udev-gothic-nf
      ];
  };

  # environment.pathsToLink = [ "/share/zsh" ];

  programs.home-manager.enable = true;

  # claude-code 本体 + MCP サーバー。
  # mcpServers は .mcp.json を内包する home-manager プラグインとして生成され、
  # claude が --plugin-dir 付きでラップされる → 全プロジェクトで有効（global / 宣言的）。
  # settings/agents 等は ~/.claude/ に書かれ symlink 管理の ~/.config/claude/ と衝突するため設定しない。
  programs.claude-code = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    mcpServers.fff = {
      type = "stdio";
      command = "fff-mcp";
    };
  };

  imports = [
    inputs.nix-index-database.homeModules.nix-index
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
  # programs.nushell.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gitui.enable
  # programs.gitui.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship.enable = true;
}
