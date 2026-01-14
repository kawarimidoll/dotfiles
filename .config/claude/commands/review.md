---
aliases: [review, code-review, cr]
description: "コードレビューを実行し、改善提案を提供する"
agent: reviewer
---

# /review - コードレビューコマンド

`reviewer`エージェントを使用して、PRまたはローカル変更のコードレビューを実行します。
品質、セキュリティ、パフォーマンスの観点から分析し、建設的な改善提案を提供します。

## 使用方法

```
/review [対象]
```

### 対象の指定
- 引数なし: 現在のローカル変更（staged + unstaged）をレビュー
- `<pr-number>`: 指定したPR番号をレビュー
- `staged`: ステージング済みの変更のみをレビュー
- `<commit-hash>`: 特定のコミットをレビュー
- `<branch-name>`: 指定ブランチとベースブランチの差分をレビュー
