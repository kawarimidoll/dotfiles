{ pkgs, ... }:
{
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
    };
  };

  services.nix-daemon.enable = true;

  fonts = {
    packages = with pkgs; [
      departure-mono
      hackgen-nf-font
      nerdfonts
      noto-fonts-color-emoji
      scientifica
      udev-gothic-nf
    ];
  };

  system = {
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
