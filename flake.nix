{
  description = "Minimal package definition for aarch64-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.git-hooks.follows = "git-hooks";
    };
    vim-overlay = {
      url = "github:kawarimidoll/vim-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
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

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      system = "aarch64-darwin";
      username = "kawarimidoll";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      apps.${system} = {
        update = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-script" ''
              set -e
              echo "Updating flake..."
              nix flake update
              echo "Updating home-manager..."
              nix run nixpkgs#home-manager -- switch --flake .#myHomeConfig
              echo "Updating nix-darwin..."
              nix run nix-darwin -- switch --flake .#kawarimidoll-darwin
              echo "Update complete!"
            ''
          );
        };

        update-home = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-script" ''
              set -e
              echo "Updating flake..."
              nix flake update
              echo "Updating home-manager..."
              nix run nixpkgs#home-manager -- switch --flake .#myHomeConfig
              echo "Update complete!"
            ''
          );
        };
        update-darwin = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-script" ''
              set -e
              echo "Updating flake..."
              nix flake update
              echo "Updating nix-darwin..."
              nix run nix-darwin -- switch --flake .#kawarimidoll-darwin
              echo "Update complete!"
            ''
          );
        };
      };

      darwinConfigurations.kawarimidoll-darwin = nix-darwin.lib.darwinSystem {
        system = system;
        modules = [ ./nix/nix-darwin/default.nix ];
      };

      homeConfigurations = {
        myHomeConfig = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs;
          };
          modules = [ ./nix/home-manager/default.nix ];
        };
      };
    };
}
# update:
#   nix run .#update (all)
#   nix run .#update-home
#   nix run .#update-darwin
