# https://nix-community.github.io/home-manager/options.xhtml#opt-programs.zsh.enable
{ pkgs, config, ... }:
{
  # https://zenn.dev/arjef/scraps/703608a91fe38e
  # https://scrapbox.io/r-hanafusa/zsh%2Fprezto_%E9%AB%98%E9%80%9F%E5%8C%96%E3%83%A1%E3%83%A2

  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.starship.enable
  programs.starship.enable = true;

  programs.zsh = {
    dotDir = "${config.xdg.configHome}/zsh";
    enable = true;
    enableCompletion = true;
    # https://gist.github.com/ctechols/ca1035271ad134841284?permalink_comment_id=2158147#gistcomment-2158147
    # https://gist.github.com/ctechols/ca1035271ad134841284?permalink_comment_id=3994613#gistcomment-3994613
    completionInit = ''
      autoload -Uz compinit
      for dump in ${"ZDOTDIR:-$HOME"}/.zcompdump(N.mh+24); do
        echo "Run compinit. Wait for a while."
        compinit
      done
      compinit -C
    '';
    autocd = true;
    autosuggestion.enable = true;
    historySubstringSearch = {
      enable = true;
      searchDownKey = "^N";
      searchUpKey = "^P";
    };
    history = {
      append = true;
      ignoreAllDups = true;
      # ignoreDups = true; ignoreAllDupsがあれば不要
      ignoreSpace = true;
      share = true;
    };
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
      }
      {
        name = "zeno.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "yuki-yano";
          repo = "zeno.zsh";
          rev = "06087e64eddee79f88994c74fbe01d7d2ae4f2ae";
          sha256 = "1xzs4g4vja377hfmb9kbywg49rv8yrkgc59r9m8jy7cvgpgkh01s";
        };
        file = "zeno.zsh";
      }
    ];
    zsh-abbr = {
      enable = true;
      abbreviations = {
        "-" = "cd -";
        "bun list" = "bun pm ls";
        cala = "cage claude";
        cld = "caffeinate -i claude";
        d = "docker";
        dp = "docker compose";
        "docker p" = "docker compose";
        "docker compose u" = "docker compose up";
        "docker compose d" = "docker compose down";
        g = "git";
        "git -" = "git switch -";
        "git d" = "git dead";
        "git f" = "git fuse";
        "git n" = "git new";
        gco = "git checkout";
        js = "just --choose";
        ld = "lazydocker";
        prit = "difit HEAD origin/main";
      };
      globalAbbreviations = {
        # # `|&` is shorthand for `2>&1 |`, this connects not only stdout, but also stderr.
        G = "| rg";
        L = "| less";
        CP = "|& tee >(pbcopy)";
        EG = "|& rg";
        EL = "|& less";
        ECP = "| tee >(pbcopy)";
        NE = "2> /dev/null";
        NL = "> /dev/null 2>&1";
        "/dn" = "/dev/null 2>&1";
      };
    };
    # evaluation warning: `programs.zsh.initExtra` is deprecated, use `programs.zsh.initContent` instead.
    initContent = ''
      source ~/dotfiles/.zshrc

      # Disable space key in zsh-autopair to avoid conflict with zeno.zsh
      unset 'AUTOPAIR_PAIRS[ ]'

      # zeno.zsh key bindings
      if [[ -n $ZENO_LOADED ]]; then
        bindkey ' '      zeno-auto-snippet
        bindkey '^m'     zeno-auto-snippet-and-accept-line
        bindkey '^i'     zeno-completion
        bindkey '^x '    zeno-insert-space
        bindkey '^x^m'   accept-line
        bindkey '^x^z'   zeno-toggle-auto-snippet

        # Optional: additional zeno.zsh features
        bindkey '^r'     zeno-history-selection
        bindkey '^x^s'   zeno-insert-snippet
        bindkey '^x^f'   zeno-ghq-cd
      fi
    '';
  };

}
