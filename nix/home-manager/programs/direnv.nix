# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    config = {
      disable_stdin = true;
      strict_env = true;
      warn_timeout = 0;
    };
    nix-direnv.enable = true;

    # workaround
    # https://github.com/nix-community/home-manager/issues/8170#issuecomment-3542413378
    package = pkgs.direnv.overrideAttrs (oldAttrs: {
      nativeCheckInputs = builtins.filter (pkg: pkg != pkgs.fish) (oldAttrs.nativeCheckInputs);
      checkPhase = ''
        runHook preCheck
        make test-go test-bash test-zsh
        runHook postCheck
      '';
    });
  };
}
