{
  description = "My package definition";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    crane.url = "github:ipetkov/crane";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    vim-overlay = {
      url = "github:kawarimidoll/vim-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    koi = {
      url = "github:kawarimidoll/koi";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
    cage = {
      url = "github:Warashi/cage";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    gh-graph = {
      url = "github:kawarimidoll/gh-graph";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    gh-prism = {
      url = "github:kawarimidoll/gh-prism";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
    gh-q = {
      url = "github:kawarimidoll/gh-q";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-packages = {
      url = "github:kawarimidoll/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neoki = {
      url = "github:kawarimidoll/neoki";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
    hjkls = {
      url = "github:kawarimidoll/hjkls";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
    # arto は自前 nixpkgs+crane でビルドしたバイナリを arto.cachix.org に push している。
    # follows=nixpkgs/crane だとハッシュがずれ Rust 部分が cache に当たらずローカルビルドに
    # なるため、arto の CI と同じ rev に固定して follows させる。rev は nix run .#update{,-home}
    # の pinArto が arto の flake.lock から自動同期する(下記 url は初期値)。
    arto-nixpkgs.url = "github:NixOS/nixpkgs/e52c192be9d7b2c4bd4aed326c8731b35f8bb75c";
    arto-crane.url = "github:ipetkov/crane/469fd08d0bcf6926321fa973c6777fbc87785dd7";
    arto = {
      url = "github:arto-app/Arto";
      inputs.nixpkgs.follows = "arto-nixpkgs";
      inputs.crane.follows = "arto-crane";
    };
    version-lsp = {
      url = "github:skanehira/version-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.crane.follows = "crane";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    kakehashi = {
      url = "github:atusy/kakehashi";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.flake-utils.follows = "flake-utils";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.systems.follows = "systems";
    };
    guard-and-guide = {
      url = "github:kawarimidoll/guard-and-guide";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.bun2nix.follows = "bun2nix";
      inputs.systems.follows = "systems";
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
      pkgs = import nixpkgs { inherit system; };
      # neovim-nightly は flake update で最新コミット(= CI の cachix push 前)を掴むと
      # ローカルビルドになる。aarch64-darwin もキャッシュ対象だが数コミット分ラグがある。
      # nix-community.cachix.org に実在する最新コミットを探して pin し、常に「最新の cache」を使う。
      pinNeovim = ''
        echo "Pinning neovim-nightly to latest cached build..."
        nvim_rev=""
        revs=$(${pkgs.gh}/bin/gh api "repos/nix-community/neovim-nightly-overlay/commits?per_page=20" --jq '.[].sha' 2>/dev/null || true)
        for rev in $revs; do
          out=$(nix eval --raw "github:nix-community/neovim-nightly-overlay/$rev#packages.${system}.default.outPath" 2>/dev/null) || continue
          if nix path-info --store https://nix-community.cachix.org "$out" >/dev/null 2>&1; then
            nvim_rev="$rev"
            break
          fi
        done
        if [ -n "$nvim_rev" ]; then
          echo "  neovim-nightly -> $nvim_rev (cached)"
          nix flake lock --override-input neovim-nightly-overlay "github:nix-community/neovim-nightly-overlay/$nvim_rev"
        else
          echo "  no cached neovim-nightly found in recent commits; keeping latest (local build)"
        fi
      '';
      # arto-nixpkgs/arto-crane を arto 自身の flake.lock の rev に同期し、arto を CI と同一
      # ハッシュ = arto.cachix.org のキャッシュ経由でビルドさせる(Rust 部分のローカルビルド回避)。
      pinArto = ''
        echo "Pinning arto nixpkgs/crane to arto's own lock (for arto.cachix.org)..."
        arto_src=$(nix eval --raw --impure --expr 'let f = builtins.getFlake (builtins.toString ./.); in f.inputs.arto.outPath' 2>/dev/null || true)
        lock="$arto_src/flake.lock"
        if [ -n "$arto_src" ] && [ -f "$lock" ]; then
          np_node=$(${pkgs.jq}/bin/jq -r '.nodes[.root].inputs.nixpkgs' "$lock")
          np_rev=$(${pkgs.jq}/bin/jq -r --arg n "$np_node" '.nodes[$n].locked.rev' "$lock")
          cr_node=$(${pkgs.jq}/bin/jq -r '.nodes[.root].inputs.crane' "$lock")
          cr_rev=$(${pkgs.jq}/bin/jq -r --arg n "$cr_node" '.nodes[$n].locked.rev' "$lock")
          if [ -n "$np_rev" ] && [ "$np_rev" != null ] && [ -n "$cr_rev" ] && [ "$cr_rev" != null ]; then
            echo "  arto-nixpkgs -> $np_rev"
            echo "  arto-crane   -> $cr_rev"
            nix flake lock \
              --override-input arto-nixpkgs "github:NixOS/nixpkgs/$np_rev" \
              --override-input arto-crane "github:ipetkov/crane/$cr_rev"
          else
            echo "  could not read arto lock revs; keeping current pins"
          fi
        else
          echo "  arto source not found; keeping current pins"
        fi
      '';
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
              ${pinNeovim}
              ${pinArto}
              # nix-darwin を先に。/etc/nix/nix.conf(substituters, trusted-users,
              # max-jobs 等)を先に反映させ、home-manager のビルドがその設定下で走るようにする。
              echo "Updating nix-darwin..."
              nix run nix-darwin -- switch --flake .#kawarimidoll-darwin
              echo "Updating home-manager..."
              nix run nixpkgs#home-manager -- switch --flake .#myHomeConfig
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
              ${pinNeovim}
              ${pinArto}
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
              sudo /run/current-system/sw/bin/darwin-rebuild switch --flake .#kawarimidoll-darwin
              echo "Update complete!"
            ''
          );
        };
      };

      darwinConfigurations.kawarimidoll-darwin = nix-darwin.lib.darwinSystem {
        system = system;
        specialArgs = {
          inherit inputs;
        };
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
