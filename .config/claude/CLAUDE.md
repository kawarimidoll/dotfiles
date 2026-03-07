# AI Coding Rules

**Always respect the contents of this file.**

- Document at the right layer: Code → How, Tests → What, Commits → Why, Comments
  → Why not
- Keep documentation up to date with code changes

## Choosing solutions

- Prefer **simple** solutions over easy ones.
- Prefer **systematic problem solving** over rabbit hole of configurations.

## Using Subagents (Task tool)

- Use subagents for small-to-medium **self-contained** tasks.
- **Explicitly prompt steps and goals** for subagents so they do not get lost.
- Do NOT use subagents for open-ended tasks. Instead, **continue open-ended
  tasks in the main context** so you can track progress.
- Use subagents in parallel for simple parallelize-able tasks.

## z-ai/ directory

- `z-ai/` is globally gitignored.
- This directory is used for local AI documents such as plans and progress
  tracking.
- Do NOT ask whether `z-ai/` is gitignored — it always is.

## Browser Automation (agent-browser)

`agent-browser` is available to check on the browser.

```bash
# 1. Open page (`--allow-private` is required to open localhost)
agent-browser open <url> --allow-private

# 2. Get element reference
agent-browser snapshot -i

# 3. Operate
agent-browser click @e<N>
agent-browser fill @e<N> "テキスト"

# 4. Save screenshot
agent-browser screenshot z-ai/screenshot.png

# ex. save credentials

agent-browser open <url> --profile ~/.browser-profile --allow-private
```

## RTK - Rust Token Killer

`rtk` is token-optimized CLI proxy for AI coding agents.

### Hook-Based Usage

All general commands are automatically rewritten by the Claude Code hook.

Example: `git status` → `rtk git status` (transparent, 0 tokens overhead)

### Meta Commands (always use rtk directly)

```bash
rtk gain              # Show token savings analytics
rtk discover          # Analyze Claude Code history for missed opportunities
rtk proxy <cmd>       # Execute raw command without filtering (for debugging)
rtk --version         # Verify rtk is installed
```
