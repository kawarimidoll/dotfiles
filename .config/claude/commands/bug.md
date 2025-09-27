---
argument-hint: [error-message]
description: エラー・挙動不良等、問題の原因を特定するための調査専用コマンド
---

# bug - 原因調査コマンド

bugエージェントを使用して、エラーや挙動不良の原因を特定し、事実に基づく分析結果を提供する。

## 使用例

```
/bug TypeError: Cannot read property 'name' of undefined
/bug アプリが起動時にクラッシュする
/bug データが保存されない問題
```

## 動作

`$ARGUMENTS`の内容をbugエージェントに委託して実行する。

---

bugエージェント（.config/claude/agents/bug.md）を使用して、以下のエラー・問題を調査・分析する：

$ARGUMENTS
