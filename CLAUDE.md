# dotfiles

## Brewfile

`etc/mac/Brewfile` は `brew bundle dump` の自動生成物。手編集しない。

brew パッケージの追加・削除や nix への移行を行っても Brewfile には触れず、nix 側だけを
変更する。brew 側の整理はユーザーに委ねる（重複インストールになる場合はその旨だけ伝える）。

## zsh 設定

zsh の設定は `.config/zsh/`（sheldon + `eval_source` + zcompile + zsh-defer）に置く。
home-manager の `programs.zsh.enable` と各 `programs.*` の `enableZshIntegration` は
採用しない。

**Why not:** 起動速度は `eval_source` の出力キャッシュ・zcompile・zsh-defer の3点で
成立しており、home-manager に等価物が無い。HM は `source <(fzf --zsh)` のような
非キャッシュ eval を `.zshrc` に直接吐く。加えて zsh 一行の変更ごとに
`home-manager switch` が必要になりイテレーションが悪化する。

**使い分け:** ツール本体の設定と環境変数は nix（`programs.*` / `home.sessionVariables`）、
シェル統合の起動だけ `plugins.toml` に `eval_source <tool> init zsh` として置く。
direnv・starship・fzf がこの形。環境変数を nix 側に置くのは bash と共有するため
（`programs.bash.enable = true` なので `~/.bashrc` にも統合が入る）。

## git エイリアス

`.config/git/config` の `[alias]` にインラインで書くのは、シェルとして素直に読める
ものだけ。`f() { ...; }; f` のような関数ラップや、値全体のクォートと `\"` エスケープが
必要になった時点で `bin/git-__<name>` の独立スクリプトに置き、エイリアスからは名前で
委譲する。

**Why not:** git は `!` エイリアス本体の末尾に `"$@"` を必ず追記するため引数を使うなら
関数ラップが要り、git config では `;` `#` がコメント開始文字なのでクォートとエスケープが
連鎖する。読めなくなったものを設定ファイルに残す価値はない。

既存の `abort = __abort` / `age = __age` / `continue = __continue` と同じ委譲パターンに
揃えること。「1行に収まるから」はインライン化の理由にならない。

## claude-code の設定

`programs.claude-code` には `enable` / `package` / `mcpServers` だけを書く。settings や
agents 等を home-manager から設定しない。HM はそれらを `~/.claude/` に書き出すが、
`~/.config/claude/` は dotfiles からの symlink で管理しており衝突するため。

同じ理由で、他のツールが提供する `*.claude-code.enable` 系の home-manager オプションも
使わない（`programs.claude-code.rules` に書き込むものは全て `~/.claude/` 行きになる）。
エージェントへの指示は `.config/claude/CLAUDE.md` に直接書く。
