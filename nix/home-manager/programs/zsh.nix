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
      source ~/.nix-profile/share/zsh/zsh-autopair/autopair.zsh
    '';
  };

}
