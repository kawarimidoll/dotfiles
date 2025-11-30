# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.bat.enable
{
  programs.bat = {
    enable = true;

    config = {
      pager = "ov -F --header=3 --wrap=false";
      wrap = "never";
    };
  };
}
