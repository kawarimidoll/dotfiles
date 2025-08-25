# Claude設定

## ステータスライン

`statusline.sh` によって表示される

## スラッシュコマンド

以下のコマンドがある

- `/implement <要件>`: オーケストレーターとして要件分析から実装まで完全サイクルを管理
- `/commit`: Stagingされた変更をコミット
- `/pr`: プルリクエストを作成
- `/search <クエリ>`: Gemini CLIでWeb検索を実行

## サブエージェント

```
https://docs.anthropic.com/ja/docs/claude-code/sub-agents のサブエージェントを作りたいです。
@.config/claude/agents/に以下のエージェントの定義を作ってください

- requirement-analyzer: ユーザーとインタラクティブに会話し、タスクの規模判定と開発アプローチの提案を行う
- task-decomposer: 開発アプローチ確定後、全体のタスクを適切な粒度（1コミットに適したサイズ）に分割し、具体的な手順書を作成する
- task-executor: 作業計画書の手順を着実に実装する 作業内容に応じて並列で活動する
- quality-fixer: 型エラー検証、lint、フォーマット、テストを行い、失敗箇所を修正する
- commit-maker: /commitコマンドのルールに従ってコミットを行う この際、確実にquality-fixerが成功していることを確かめる
```

```
完了しました！☆ ☆
5つのサブエージェント定義ファイルを `.config/claude/agents/` ディレクトリに作成しました☆

各エージェントの役割：
- **requirement-analyzer.md** - ユーザーとの対話でタスク要求を分析
- **task-decomposer.md** - タスクを1コミット単位に分割して計画書作成
- **task-executor.md** - 計画に従って並列実装を実行
- **quality-fixer.md** - lint/型チェック/テストで品質保証
- **commit-maker.md** - 品質確認後に適切なコミットを実行

これらのエージェントは連携して動作し、効率的な開発フローを実現します☆ ☆ ☆
```

## 参考

- [AI コーディングプロジェクト ボイラープレート](https://github.com/shinpr/ai-coding-project-boilerplate/blob/main/README.ja.md)
- [Claude CodeのSub agentsでコンテキスト枯渇問題をサクッと解決できたはなし](https://zenn.dev/tacoms/articles/552140c84aaefa)
- [設計書駆動で品質を保証する「Agentic Coding」実践ガイド #LLM - Qiita](https://qiita.com/shinpr/items/98771c2b8d2e15cafcd5)
