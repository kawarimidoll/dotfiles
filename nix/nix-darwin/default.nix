{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # デフォルトの ca-bundle.crt は TRUSTED CERTIFICATE 形式(trust/reject属性付き)を
  # 含むため、OpenSSL 3.x が一部のルートCAを reject しcurlのSSL検証が失敗する。
  # no-trust-rules版(標準PEM形式のみ)に切り替え、Mozilla バンドルにないルートCAを
  # macOS システム証明書で補完する。
  # ref: NixOS の security.pki.useCompatibleBundle 相当 (nix-darwin には未実装)
  security.pki.certificateFiles = lib.mkForce [
    "${pkgs.cacert}/etc/ssl/certs/ca-no-trust-rules-bundle.crt"
    "/etc/ssl/cert.pem" # macOS system CA store
  ];

  nix = {
    gc = {
      automatic = true;
      interval = {
        Hour = 9;
        Minute = 0;
      };
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
      download-buffer-size = 134217728; # 128MiB
      trusted-users = [ "root" "kawarimidoll" ];
      extra-substituters = [
        "https://kawarimidoll.cachix.org"
        # llm-agents (agent-browser 等) のビルド済みバイナリ取得元。flake の nixConfig
        # で宣言されているが非対話ビルドでは無視されるため明示追加する。無いと pnpm 11 の
        # ローカルビルドにフォールバックし darwin で SIGKILL (exit 137) する
        "https://cache.numtide.com"
      ];
      extra-trusted-public-keys = [
        "kawarimidoll.cachix.org-1:43W5G98mVTyDaMeG7ZGzx4h/be5u4ULUGV/9svLjKJY="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };
    linux-builder = {
      enable = true;
      package =
        inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.darwin.linux-builder;
    };
  };

  # services.nix-daemon.enable = true;

  # Disable /etc/zshrc and /etc/zshenv generation
  programs.zsh.enable = false;

  # fonts = {
  #   packages = with pkgs; [
  #     hackgen-nf-font
  #     moralerspace-hwnf
  #     moralerspace-nf
  #     nerd-fonts.departure-mono
  #     nerd-fonts.symbols-only
  #     noto-fonts-color-emoji
  #     scientifica
  #     twitter-color-emoji
  #     udev-gothic-nf
  #   ];
  # };

  # to enable/disable borders temporary, run:
  # launchctl stop/start org.nixos.jankyborders
  services.jankyborders = {
    enable = true;
    style = "round";
    width = 8.0;
    hidpi = true;
    active_color = "0xc0ff00f2";
    inactive_color = "0xff0080ff";
  };

  system = {
    primaryUser = "kawarimidoll";
    stateVersion = 5;

    # デフォルトキーボードショートカットの無効化 (symbolic hotkeys)
    # CustomUserPreferences."com.apple.symbolichotkeys" は AppleSymbolicHotKeys
    # 辞書全体を置換して既存エントリを消すため、-dict-add で対象 ID のみ上書きする
    activationScripts.postActivation.text =
      let
        disabledHotkeys = [
          28 # スクリーンショット: 画面をファイルに保存 (Cmd+Shift+3)
          29 # スクリーンショット: 画面をクリップボードにコピー
          30 # スクリーンショット: 選択範囲をファイルに保存 (Cmd+Shift+4)
          31 # スクリーンショット: 選択範囲をクリップボードにコピー
          60 # 入力ソース: 前の入力ソースを選択 (Ctrl+Space)
          61 # 入力ソース: 次のソースを選択 (Ctrl+Opt+Space)
          64 # Spotlight: 検索 (Cmd+Space)
          65 # Spotlight: Finder検索ウィンドウ (Cmd+Opt+Space)
          233 # ウィンドウ: しまう
          # 234-236 は未確認のため除外(おそらく「一般」カテゴリの残り)
          237 # ウィンドウ: 画面いっぱい
          238 # ウィンドウ: 中央
          239 # ウィンドウ: 元のサイズに戻す
          240 # ウィンドウ: 左半分にタイル
          241 # ウィンドウ: 右半分にタイル
          242 # ウィンドウ: 上半分にタイル
          243 # ウィンドウ: 下半分にタイル
          244 # ウィンドウ: 左上クォーター
          245 # ウィンドウ: 右上クォーター
          246 # ウィンドウ: 左下クォーター
          247 # ウィンドウ: 右下クォーター
          248 # ウィンドウ: 左右に整理
          249 # ウィンドウ: 右左に整理
          250 # ウィンドウ: 上下に整理
          251 # ウィンドウ: 下上に整理
        ];
        asUser = "launchctl asuser \"$(id -u -- kawarimidoll)\" sudo --user=kawarimidoll --";
        disableCmds = lib.concatMapStringsSep "\n" (
          id:
          "${asUser} defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${toString id} '<dict><key>enabled</key><false/></dict>'"
        ) disabledHotkeys;
      in
      ''
        ${disableCmds}
        # 再ログインせずにショートカット設定を反映する
        ${asUser} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';
    defaults = {
      NSGlobalDomain.AppleShowAllExtensions = true;
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
      dock = {
        autohide = true;
        show-recents = false;
        orientation = "bottom";
      };
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;

      # dangerous option!!!
      # cleanup = "uninstall";
    };
    brews = [
      "pinentry-mac"
      # "sleepwatcher" how to create brew services in nix?
    ];
    casks = [
      # "sublime-text"
    ];
  };
}
