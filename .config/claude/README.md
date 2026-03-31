# Claude Code Setup

## mcp settings

```sh
claude mcp add deepwiki --transport http --scope user https://mcp.deepwiki.com/mcp
claude mcp add time --transport http --scope user https://mcp.time.mcpcentral.io
```

## skill settings

```sh
bunx skills add vercel-labs/agent-browser --skill agent-browser
bunx skills add vercel-labs/agent-browser --skill dogfood
```
