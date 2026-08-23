# AI Coding Rules

**Always respect the contents of this file.**

- Document at the right layer: Code → How, Tests → What, Commits → Why, Comments
  → Why not
- Keep documentation up to date with code changes
- Never leave tool-specific markers in code comments (e.g. `ponytail:`). The
  tool is optional and the marker turns into noise the moment it is gone. Use
  `LIMITATION:` for a deliberate simplification with a known ceiling.

## Communication style

- Keep responses concise to save tokens.
- Avoid verbose honorifics and hedging (e.g. "I think…", "perhaps", "might").
- Prefer noun phrases and bullet points.
- Focus mode is enabled: intermediate tool calls, results, and progress updates
  are NOT visible to the user.
- Consolidate all information the user needs (results, decisions, follow-ups)
  into the final message of the turn. Do not assume earlier text was seen.

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

# q. sandbox-nesting is detected
# a. use `--args "--no-sandbox"`
agent-browser open <url> --args "--no-sandbox"
```

## Agent Delegation

- Commit rewriting (fixup, rebase, squash) → use `rebaser` agent.
- Commit message rewriting (reword) → use `reworder` agent.

## Shell environment

- `coreutils` is uutils (GNU-style), not BSD/macOS. BSD-only flags fail.
  - Use `stat -c '%a %U %n'` (BSD `stat -f '%Sf...'` fails).
  - Do not pass BSD-only flags to `ls` (e.g. `-O`).

## Long-running processes (zmx)

- Run long-running processes (dev servers, watchers, port-forwards) through
  `zmx`, not native background bash, so they persist and the user can attach to
  observe them. Only when `zmx` is on PATH; otherwise fall back to background
  bash.
- Session name: git repo root basename (cwd basename if not a repo). Run
  `zmx list` first and pick a non-colliding name. Start detached with
  `zmx run <name> -d <cmd>`; follow output via `zmx tail <name>`.
- Tell the user the session name and `zmx attach <name>` so they can watch.
- Quick/one-shot commands (git, ls, build) run locally — do NOT route them
  through zmx.

## File Search

We have `fff-mcp`, a fast and token-efficient search server.
For any file search or grep in the current git-indexed directory, use fff tools.
For details, run `fff-mcp --help`.
