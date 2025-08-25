---
allowed-tools: Bash(gh pr:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*)
description: "pushされた変更でPRを作成"
---

`gh pr` を用いて現在のブランチでPRを作成します。
既にpush済みの変更からPRを作成、または作成済みのPRを更新します。
$ARGUMENTS が 'draft' の場合はDraft PRを作成します。

## Rules

- 禁止: PR作成以外の変更操作を行う
  - 既にpush済みの変更からPRを作成することが目的であり、pushやブランチの変更を行ってはいけない

- 必須: 実際の変更を元にPRのタイトルを作成する
  - PRのタイトルは過去の他のPRに倣う
  - PRに含まれるコミットをまとめたタイトルにする
  - PRは一つの大きな明確な目的を達成する

- 必須: 実際の変更を元にPRの説明を作成する
  - 過去の変更とPRの説明の傾向を`gh pr`を用いて確認する
  - 実際の変更を`git log`を用いて確認する
  - 会話履歴ではなく、実際の変更を元にPRの説明を考える
