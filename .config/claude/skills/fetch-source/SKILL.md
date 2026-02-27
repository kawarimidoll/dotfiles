---
name: fetch-source
description: >
  GitHub リポジトリのソースコードをローカルに取得して調査する。
  ライブラリの実装を直接読みたいとき、内部動作を調査したいときに使用する。
argument-hint: <owner/repo> [@tag | #branch]
user-invocable: false
allowed-tools: Bash(git *), Read, Grep, Glob
---

# fetch-source

GitHub リポジトリのソースコードを `/tmp` にダウンロードし、実装の詳細を直接読んで調査する。

## 引数の解析

`$ARGUMENTS` から以下を抽出する：

| 入力パターン | 意味 | 例 |
|---|---|---|
| `owner/repo` | デフォルトブランチ | `vercel/next.js` |
| `owner/repo@tag` | 特定のタグ | `vercel/next.js@v15.0.0` |
| `owner/repo#branch` | 特定のブランチ | `vercel/next.js#canary` |

引数が `owner/repo` 形式でない場合はエラーとして正しい形式を案内する。

## 処理手順

### 1. 保存先の確認

保存先: `/tmp/fetch-source/<repo>/`

同名ディレクトリが既に存在する場合は、そのまま再利用するか削除して再取得するか確認する。

### 2. ソースコードの取得

```bash
# ref 指定あり（@tag または #branch）
git clone --depth 1 --branch <ref> "https://github.com/<owner>/<repo>.git" "/tmp/fetch-source/<repo>"

# ref 指定なし（デフォルトブランチ）
git clone --depth 1 "https://github.com/<owner>/<repo>.git" "/tmp/fetch-source/<repo>"
```

### 3. タグ解決のリトライ

タグ指定で clone に失敗した場合、`v` プレフィックスの有無を切り替えて再試行する：
- `7.1.0` → `v7.1.0`
- `v7.1.0` → `7.1.0`

それでも失敗なら利用可能なタグを `git ls-remote --tags` で案内する。

### 4. 完了報告

取得完了後、以下を報告する：

- リポジトリ名、取得した ref（タグ/ブランチ/デフォルト）
- 保存先の絶対パス
- ディレクトリ構造の概要（トップレベルの `ls` 結果）