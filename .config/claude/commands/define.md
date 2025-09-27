---
argument-hint: [message]
description: 要件定義専用コマンド
---

# define - 要件定義コマンド

defineエージェントを使用して、プロジェクトの新機能や改修について詳細な要件定義を行う。

## 使用例

```
/define ユーザー認証機能を追加したい
/define データベースのパフォーマンス改善
/define APIの新エンドポイント設計
```

## 動作

`$ARGUMENTS`の内容をdefineエージェントに委託して実行する。

---

defineエージェント（.config/claude/agents/define.md）を使用して、以下の要件定義を行う：

$ARGUMENTS
