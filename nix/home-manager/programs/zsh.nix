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
    setOptions = [
      "auto_list" # 補完候補を一覧表示に
      "auto_menu" # 補完候補をtabで選択
      "bsd_echo" # echoをbash互換にする なおデフォルトはecho -eに相当
      "correct" # コマンドのスペルミスを指摘
      "hist_reduce_blanks" # historyに保存するときに余分なスペースを削除する
      "hist_verify" # historyを使用時に編集
      "interactive_comments" # コンソールでも#をコメントと解釈
      "nonomatch" # 引数の#とかをファイル名として認識するのを防止
      "print_eight_bit" # 日本語ファイル名を表示する
      "globdots" # 補完時にドットファイルも候補に表示
      # setopt ksh_arrays # 配列の添字を0から開始 むしろなんでzshは1から始まる設定なの…
    ];
    autosuggestion.enable = true;
    historySubstringSearch = {
      enable = true;
      searchDownKey = "^N";
      searchUpKey = "^P";
    };
    history = {
      path = "${config.xdg.dataHome}/zsh/zsh_history";
      append = true; # セッションごとに履歴を作り直すのではなく追記する
      ignoreAllDups = true; # 同じコマンドをhistoryに残さない
      # ignoreDups = true; 直前と同じコマンドをhistoryに残さない ignoreAllDupsがあれば不要
      ignorePatterns = [ "history*" ]; # historyコマンドをhistoryに残さない
      ignoreSpace = true; # スペースから始まるコマンドをhistoryに残さない
      saveNoDups = true; # 同じコマンドをhistoryファイルに書き込まない
      share = true; # 同時に起動しているzshの間でhistoryを共有する
    };
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
      {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
        file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
      }
    ];
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
