# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.gh.enable
{ pkgs, inputs, ... }:
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
    extensions = [
      pkgs.gh-dash
      inputs.gh-q.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.gh-graph.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
