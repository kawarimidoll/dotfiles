---
name: zmx
description: >
  シェルコマンドをローカルではなく zmx セッション経由で実行するモードに切り替える。
  ユーザーが同じセッションに attach してエージェントの操作をリアルタイムに観察・監査でき、
  リモート/コンテナ/Pod のシェルにコマンドを委譲することもできる。
  引数でセッション名を指定する (例: /zmx dev)。
  「zmx で作業」「セッション経由で実行」「<name> セッションで作業して」等で発火。
user-invocable: true
---

# zmx portal

このスキルが有効な間、**シェルコマンドをローカルで直接実行せず、すべて `zmx` セッション
経由で実行する**。目的はセッション共有: ユーザーは別ターミナルで `zmx attach <session>`
すると、エージェントが送ったコマンドと出力をそのまま見られ、`↑` で再実行もできる
(監査・ペア作業・リモート/コンテナ実行)。

出典: zmx 作者 (neurosnap) の記事 <https://bower.sh/zmx-ai-portal>

## セッション名

- 引数で渡された名前を `<session>` として使う。未指定ならユーザーに確認する。
- セッションが無ければ `zmx run` が自動作成する。事前作成は `zmx a <session>`。

## 実行ルール（重要）

- **コマンド実行は必ず `zmx run <session> <cmd...>`** を使う。
  - 同期実行: コマンド完了まで出力を tail し、送ったコマンドの exit code で終了する。
    → **終了しない長時間プロセス(dev サーバ・watcher 等)に素の `run` を使うと永久にブロックする**。必ず下記の `-d`。
  - コマンドは**クオートで包まず、そのまま**渡す。複数コマンドを並列送信しない(順次)。
  - stdin は /dev/null。データを渡すときはパイプする: `echo "data" | zmx run <session> cat`
  - 例:
    - `zmx run <session> ls -la`
    - `zmx run <session> git status`
    - `zmx run <session> npm test`
- **長時間プロセス(サーバ・watcher 等)**: 必ず `-d` を付けて非ブロッキング起動。
  終了しないので `wait` はせず、`zmx tail <session>` やユーザーの `zmx attach` で観察する。
    - `zmx run <session> -d pnpm run dev`
- **完了するが待ちたくないジョブ**: `zmx run <session> -d <cmd>` → `zmx wait <session>` で完了待ち。
- **ファイル転送**: `cat <local> | zmx write <session> <remote_path>` (base64+チャンク送信)。
- **監視のみ**: `zmx tail <session>` (read-only。`| tee log.txt` でログ保存)。

## やらないこと

- ローカルで直接コマンドを実行しない (このスキルの目的が失われる)。
- `zmx attach` はエージェントから使わない (対話 attach はユーザー専用)。

## 前提条件

- 対象シェルに `ls grep git base64 printf` と exit code (`$?`) が必要。
  scratch 等の最小コンテナでは動かない。

## 起動例（参考: ユーザー側の運用）

```sh
# 起動時から portal モード (推奨。session 省略時は cwd 由来名):
zmc dev
# あるいは起動済みの Claude Code を途中から portal 化:
#   /zmx dev
# 別ターミナルで観察: zmx attach dev
```

`zmc` は settings.sh のシェル関数で、`claude --append-system-prompt` に本ルールと
session 名を注入して起動する（`/zmx` を毎回叩かずに済む）。
