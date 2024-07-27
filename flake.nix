{
  description = "Minimal package definition for aarch64-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    vim-src = {
      url = "github:vim/vim";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # install:
  #   nix profile install .#my-packages
  # uninstall:
  #   nix profile remove my-packages
  # update:
  #   nix flake update
  #   nix profile upgrade my-packages
  # or
  #   nix run .#update
  outputs = {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    vim-src,
    home-manager,
  } @ inputs: let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system}.extend (
      neovim-nightly-overlay.overlays.default
    );
  in {
    packages.${system}.my-packages = pkgs.buildEnv {
      name = "my-packages-list";
      paths = with pkgs; [
        git
        curl
        jq
        ripgrep
        eza
        alejandra

        (vim.overrideAttrs (oldAttrs: {
          version = "latest";
          src = vim-src;
          configureFlags =
            oldAttrs.configureFlags
            ++ [
              "--enable-terminal"
              "--with-compiledby=kawarimidoll-nix"
              "--enable-luainterp"
              "--with-lua-prefix=${lua}"
              "--enable-fail-if-missing"
            ];
          buildInputs = oldAttrs.buildInputs ++ [gettext lua libiconv];
        }))

        neovim
      ];
    };

    apps.${system}.update = {
      type = "app";
      program = toString (pkgs.writeShellScript "update-script" ''
        set -e
        echo "Updating flake..."
        nix flake update
        echo "Updating profile..."
        nix profile upgrade my-packages
        echo "Update complete!"
      '');
    };

    homeConfigurations = {
      myHomeConfig = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = system;
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./.config/home-manager/home.nix
        ];
      };
    };
  };
}
