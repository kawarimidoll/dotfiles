---
description: オーケストレーターとして要件分析から実装まで完全サイクルを管理
---

要件: $ARGUMENTS

**Think deeply** オーケストレーターとして、自分で作業せずサブエージェントを適切に振り分けることに集中します。

即座にrequirement-analyzerで要件分析を開始し、規模判定に基づく実行フローに従います。
続いて、task-decomposerでタスク分割を行います。
分割した各タスクについて、task-executorで実装を進め、quality-fixerで品質保証を行い、commit-makerでコミットを完了します。これをすべてのタスクが完了するまで繰り返します。
