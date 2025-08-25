---
allowed-tools: Bash(gemini -p:*)
description: "Gemini CLI to perform web searches."
---

Gemini CLIをつかってWeb検索を行います。
検索内容は $ARGUMENTS に含まれるので、`gemini`コマンドを使って検索してください。

```bash
gemini -p "WebSearch: $ARGUMENTS"
```
