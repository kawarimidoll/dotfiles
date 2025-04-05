# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.direnv.enable
{
  programs.direnv = {
    enable = true;
    config = {
      disable_stdin = true;
      strict_env = true;
      warn_timeout = 0;
    };
    nix-direnv.enable = true;
  };
}
