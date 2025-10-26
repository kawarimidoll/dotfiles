---
allowed-tools: Bash(git commit:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*)
description: "Stagingされた変更をコミット"
---

commit-maker エージェントを用いてStaging済みの変更をコミットします。
作業内容はcommit-makerエージェントが認識しているため、完全に作業を委譲し、勝手にコンテキストを与えません。

## Rules

- 禁止: Stagingエリアの内容を変更する
  - 既にStaging済みの変更からcommitを作成することが目的であり、Stagingの追加や削除を行ってはいけない

- 禁止: 関係ない変更を単一のコミットに含める
  - conventional commitの複数のタイプを一つのコミットに収めてはいけない

- 必須: 各コミットは一つの明確な目的を達成している必要がある

- 必須: 実際の差分を元にコミットメッセージを作成する
  - 過去の変更とコミットメッセージの傾向を`git log`を用いて確認する
  - 実際の差分を`git diff --staged`を用いて確認し、コミットメッセージを考える
  - 会話とは異なる変更がされている可能性があるため、会話履歴だけからコミットメッセージを作ってはいけない
