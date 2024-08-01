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
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # update:
  #   nix run .#update
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    ...
  } @ inputs: let
    system = "aarch64-darwin";
    username = "kawarimidoll";
    pkgs = import nixpkgs {inherit system;};
  in {
    apps.${system}.update = {
      type = "app";
      program = toString (pkgs.writeShellScript "update-script" ''
        set -e
        echo "Updating flake..."
        nix flake update
        echo "Updating home-manager..."
        nix run nixpkgs#home-manager -- switch --flake .#myHomeConfig
        echo "Update complete!"
      '');
    };

    darwinConfigurations.kawarimidoll-darwin = nix-darwin.lib.darwinSystem {
      system = system;
      modules = [
        ./nix/nix-darwin
      ];
    };

    homeConfigurations = {
      myHomeConfig = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./nix/home-manager
        ];
      };
    };
  };
}
