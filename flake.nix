{
  description = "Minimal package definition for aarch64-darwin";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }: {
    # install:
    #   nix profile install .#my-packages
    # uninstall:
    #   nix profile remove my-packages
    # update:
    #   nix flake update
    #   nix profile upgrade my-packages
    packages.aarch64-darwin.my-packages = nixpkgs.legacyPackages.aarch64-darwin.buildEnv {
      name = "my-packages-list";
      paths = with nixpkgs.legacyPackages.aarch64-darwin; [
        git
        curl
        jq
        ripgrep
        eza
      ];
    };
  };
}
