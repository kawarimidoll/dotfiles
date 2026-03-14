---
paths:
  - .github/workflows/*.yml
  - .github/workflows/*.yaml
---

GitHub Actions workflowファイルを編集した場合、必ず以下のコマンドで検証を行うこと:

```bash
, actionlint
, zizmor -p .github/workflows/*
, ghalint run
```

- `,` は nix-comma によるコマンド呼び出し
- 検証コマンドが警告・エラーなしで通ることを確認してから完了とする
