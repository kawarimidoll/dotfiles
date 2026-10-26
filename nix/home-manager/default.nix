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
        guard-and-guide = inputs.guard-and-guide.packages.${system}.default;
        agtlog = inputs.agtlog.packages.${system}.default;
        hjkls = inputs.hjkls.packages.${system}.default;
        edgeneon = inputs.edgeneon.packages.${system}.default;
        mmdr = inputs.mermaid-rs-renderer.packages.${system}.default;
        nur = inputs.nur-packages.packages.${system};
        llm-agents = inputs.llm-agents.packages.${system};
        zsh-head = pkgs.zsh.overrideAttrs (old: {
          # postInstall が bin/zsh-${version} を消すため upstream の VERSION と一致させる
          version = builtins.head (
            builtins.match ".*VERSION=([^\n]+).*" (builtins.readFile "${inputs.zsh-src}/Config/version.mk")
          );
          src = inputs.zsh-src;
          # git ソースの docs 生成には yodl が要るが nixpkgs の yodl は Linux 専用
          outputs = [ "out" ];
          installTargets = [
            "install.bin"
            "install.modules"
            "install.fns"
          ];
          postInstall =
            builtins.replaceStrings [ "make install.info install.html" "mv $out/share/zsh/htmldoc" ] [ "" "# " ]
              old.postInstall;
          doCheck = false;
        });
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
        agtlog
        hjkls
        edgeneon
        version-lsp
        mmdr

        llm-agents.ax
        llm-agents.codex
        llm-agents.copilot-cli
        llm-agents.copilot-language-server
        llm-agents.git-surgeon
        llm-agents.officecli
        llm-agents.pdfvision

        nur.fff-mcp
        nur.ghost
        nur.jsmigemo
        nur.kakehashi
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
        rclone
        rebar3
        resterm
        restman
        resvg
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
        # sqlit-tui
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
        typescript
        typos-lsp
        tz
        unixtools.watch # procps' ps/top lack the task-port entitlement on macOS
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
        zat
        zig

        zsh-head

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

  # magiwa tunables, shared with services.jankyborders in nix-darwin. Passed as
  # a file rather than baked in so a change needs no rebuild of the app bundle.
  home.file.".config/magiwa/config.json".text = builtins.toJSON (import ../magiwa.nix);

  # magiwa: 信号機ボタンの緑を「独立 Space 送り」から「現デスクトップで gap 付き
  # 最大化」に差し替える常駐プロセス。実体は magiwa/build.sh でビルドする
  # Magiwa.app（gitignore 済み）で、アクセシビリティ権限は初回に一度承認する。
  launchd.agents.magiwa = {
    enable = true;
    config = {
      ProgramArguments = [
        "${config.home.homeDirectory}/dotfiles/magiwa/Magiwa.app/Contents/MacOS/magiwa"
      ];
      RunAtLoad = true;
      # 権限が未承認でも magiwa 自身が待機するので、これはクラッシュ時の保険
      KeepAlive = true;
      ThrottleInterval = 60;
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/magiwa.log";
    };
  };

  # symlink の .app は Spotlight やランチャーの検索に出ないため実体をコピーする。
  # copyApps は配置先を rsync --delete で同期するので directory は既定の専用サブディレクトリのままにする。
  targets.darwin = {
    linkApps.enable = false;
    copyApps.enable = true;
  };

  # https://github.com/felis-terminal/felis
  # モジュール既定の package は本 flake の nixpkgs でビルドされ natsukium cache に当たらないため、
  # felis flake 自身の packages を使う。
  programs.felis = {
    enable = true;
    package = inputs.felis.packages.${pkgs.stdenv.hostPlatform.system}.felis;
  };

  imports = [
    inputs.felis.homeManagerModules.felis
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

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nh.enable
  # nix-darwin の nix.gc は root で動き home-manager の世代を消さないため、こちらで掃除する。
  # extraArgs は Darwin では文字列だと 1 引数として渡されるのでリストで書く。
  # --keep-one: direnv プロジェクトごとに最新の gcroot を残し、再入時の再ビルドを避ける。
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = [
        "--keep-since"
        "30d"
        "--keep"
        "3"
        "--keep-one"
      ];
    };
  };

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.nushell.enable
  # programs.nushell.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gitui.enable
  # programs.gitui.enable = true;

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship.enable = true;
}
