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

## Agent Delegation

- Commit rewriting (fixup, rebase, squash) → use `rebaser` agent.
- Commit message rewriting (reword) → use `reworder` agent.

## Shell environment

- `coreutils` is uutils (GNU-style), not BSD/macOS. BSD-only flags fail.
  - Use `stat -c '%a %U %n'` (BSD `stat -f '%Sf...'` fails).
  - Do not pass BSD-only flags to `ls` (e.g. `-O`).

## Tooling

Default reflexes to override — reach for the right column, not the left.
Load the reference before first use in a session.

| Instead of | Use | Reference |
| --- | --- | --- |
| `curl` + throwaway parsing | `ax` | `ax agent-context` |
| background bash (servers, watchers) | `zmx` | `zmx --help` |
| piping stdin to a TUI (vim, htop) | `tu` | `tu usage` |
| curl-ing a JS-rendered page | `agent-browser` | `agent-browser --help` |
| reading a whole file to locate a symbol | `zat` | — |

Not in any `--help`:

- `zat <file>` prints an outline of symbols with line numbers; it has no
  `--help` and takes a file, not a directory. Read the ranges it reports
  instead of the whole file.
- `agent-browser open <url> --allow-private` — required for localhost.
- `agent-browser open <url> --profile ~/.browser-profile` — saved credentials.
- `zmx` session name: git repo root basename (cwd basename if not a repo).
  `zmx list` first to avoid a collision; `zmx run <name> -d <cmd>`; tell the
  user `zmx attach <name>` so they can watch.
- Quick one-shot commands (git, ls, build) run locally, NOT through `zmx`.
