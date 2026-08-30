---
aliases: [pr, pull-request]
description: "プルリクエストを作成する"
---

# /pr - プルリクエスト作成コマンド

## 使用方法

`/pr [draft]`

## 手順

1. push 状態を確認する。未 push なら `git push -u origin <branch>` の実行を
   ユーザーに依頼して終了する。リモートブランチの作成と push は行わない
2. ベースブランチを特定して fetch し、差分とコミットログを確認する
3. 本文を作成する
   - `.github/pull_request_template.md` があればそれに従う
   - なければ 概要 / 変更内容 / 関連 Issue の3節
4. タイトルと本文をユーザーに提示し、承認を得てから `gh pr create` を実行する
5. 作成後、PR の URL を報告する

未コミット変更・gh 認証・権限・コンフリクト等のエラーはそのまま報告する。
コミットや push で自動的に解決しようとしない。
