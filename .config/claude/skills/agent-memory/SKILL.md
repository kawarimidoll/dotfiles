---
name: agent-memory
description: |
  Save and restore working memory across conversations.
  Triggers: "remember", "save this", "recall", "continue from last time".
  Store research findings, decisions, problem solutions, and work state.
user-invocable: false
---

# Agent Memory

会話をまたいで知識を保存する記憶システム。

## 保存場所

`~/.local/share/claude/memories/`

## 保存すべき内容

- 調査で得た知見
- アーキテクチャの決定とその理由
- 問題解決のアプローチ
- 作業の中断時の状態と次のステップ

## ファイル形式

```markdown
---
summary: "簡潔な要約（検索用）"
created: YYYY-MM-DDTHH:MM:SS+09:00
tags: [tag1, tag2]
---

# タイトル

内容...
```

## 検索方法

```bash
# カテゴリ一覧
ls ~/.local/share/claude/memories/

# summary で検索
rg "summary:" ~/.local/share/claude/memories/

# キーワード検索
rg "検索語" ~/.local/share/claude/memories/
```

## 操作

- **保存**: カテゴリフォルダを作成し、markdown ファイルを保存
- **更新**: frontmatter に `updated: YYYY-MM-DD` を追加
- **削除**: 不要になったファイルを削除
- **統合**: 関連する記憶を1つにまとめる

## 原則

- summary は検索で内容を判断できる程度に具体的に
- 再開時に必要な情報を全て含める（自己完結）
- 決定事項とその理由を記録する
