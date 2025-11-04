# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.enable
{ pkgs, ... }:
let
  username = "kawarimidoll";
in
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
    extensions = with pkgs; [
      gh-copilot
      gh-dash
      gh-markdown-preview
      gh-notify
      (pkgs.stdenv.mkDerivation rec {
        pname = "gh-q";
        name = pname;
        version = "latest";
        src = pkgs.fetchFromGitHub {
          owner = username;
          repo = pname;
          rev = "a312c67b92baefadb07481ef1479c96d91243d41";
          hash = "sha256-cpR4ZxWobr1dyGr+zNr0IUa1yYlZK3sDz4m9LWjkRsc=";
        };
        installPhase = ''
          mkdir -p $out/bin
          cp $src/gh-q $out/bin/
          chmod +x $out/bin/gh-q
        '';
      })
      (pkgs.stdenv.mkDerivation rec {
        pname = "gh-graph";
        name = pname;
        version = "latest";
        src = pkgs.fetchFromGitHub {
          owner = username;
          repo = pname;
          rev = "f5982ff53393d33d1efce7568044060c7893aa8a";
          hash = "sha256-X9BVbn/eFCu57TmMXshFvYY2XgP2F5mAESJTSF8/GbQ=";
        };
        installPhase = ''
          mkdir -p $out/bin
          cp $src/gh-graph $out/bin/
          chmod +x $out/bin/gh-graph
        '';
      })
    ];
  };
}
