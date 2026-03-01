{ pkgs, lib, ... }:
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

  system = {
    primaryUser = "kawarimidoll";
    stateVersion = 5;
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
