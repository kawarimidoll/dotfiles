# execute - タスク遂行コマンド

executeエージェントを使用して、プロジェクトの整理・統括を行い、サブエージェントに実作業を依頼してタスクを遂行する。

## 使用例

```
/execute ユーザー認証機能を実装する
/execute バグ修正と型エラーを解消する
/execute パフォーマンスを改善する
```

## 動作

`$ARGUMENTS`の内容をexecuteエージェントに委託して実行する。

---

executeエージェント（.config/claude/agents/execute.md）を使用して、以下のタスクを遂行する：

$ARGUMENTS
