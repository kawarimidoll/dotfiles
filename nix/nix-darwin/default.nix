{pkgs, ...}: {
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
      hackgen-nf-font
    ];
  };

  system = {
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
    casks = [
      # "sublime-text"
    ];
  };
}
