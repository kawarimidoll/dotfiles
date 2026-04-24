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

    package = pkgs.direnv.overrideAttrs (oldAttrs: {
      # Workaround: darwin の CGO mismatch で external linking がコケる。
      # https://github.com/nix-community/home-manager/issues/8170#issuecomment-3542413378
      # 関連 PR: https://github.com/NixOS/nixpkgs/pull/486452
      env = (oldAttrs.env or { }) // { CGO_ENABLED = "1"; };

      # Workaround: darwin の codesign 破壊 nix bug で checkPhase がハングする。
      # nativeCheckInputs の fish が test-fish で SIGKILL されるだけでなく、
      # bash テスト (`## Testing base ##` の reload) でも同様にハングするため、
      # checkPhase 全体をスキップする。
      # 関連: https://github.com/NixOS/nixpkgs/issues/507531
      #       https://github.com/NixOS/nix/pull/15638
      # nix 側の fix がリリースされ cache が再生成されたら削除する。
      doCheck = false;
    });
  };
}
