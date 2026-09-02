# AI Coding Rules

- Document at the right layer: Code → How, Tests → What, Commits → Why, Comments
  → Why not
- Keep documentation up to date with code changes
- Repo-local conventions win. Check the working repo's own skills, commands, and
  CLAUDE.md before falling back to the defaults here.
- Do not describe removed or relocated code in comments. The history belongs in
  the commit message; comments carry only the current "Why not".
- Never leave tool-specific markers in code comments (e.g. `ponytail:`). The
  tool is optional and the marker turns into noise the moment it is gone. Use
  `LIMITATION:` for a deliberate simplification with a known ceiling.

## Communication style

- Keep responses concise to save tokens.
- Avoid hedging (e.g. "I think…", "perhaps", "might").
- Prefer noun phrases and bullet points.
- Japanese: です・ます調. Neither casual (「俺」, タメ口) nor over-honorific
  (「恐れ入りますが」, stacked 謙譲語).
- Report findings and end the turn before asking a question. Under focus mode
  the user cannot see the body text preceding an in-turn question; fold the
  decision material into the option labels if it must be one turn.

## Choosing solutions

- Prefer **simple** solutions over easy ones.
- Prefer **systematic problem solving** over rabbit hole of configurations.

## Using Subagents (Agent tool)

- When delegating: only small-to-medium **self-contained** tasks.
- **Explicitly prompt steps and goals** for subagents so they do not get lost.
- Do NOT use subagents for open-ended tasks. Instead, **continue open-ended
  tasks in the main context** so you can track progress.
- Use subagents in parallel for simple parallelize-able tasks.

## z-ai/ directory

- `z-ai/` is globally gitignored.
- This directory is used for local AI documents such as plans and progress
  tracking, and for throwaway artifacts like screenshots
  (`agent-browser screenshot z-ai/shot.png`).
- Do NOT ask whether `z-ai/` is gitignored — it always is.

## Commits

- Commit from what is already staged. Never add to or remove from the staging
  area to shape a commit.
- One commit, one purpose. Never mix multiple conventional-commit types.
- Write the message from `git diff --staged`, not from the conversation — the
  working tree may differ from what was discussed.
- Cover only what is in the diff: not what was left out, deferred, or merely
  discussed in the session.
- Match the existing style: `git log` for recent form, plus `.gitmessage` at the
  repo root if present, otherwise `~/.config/git/message`.

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
| built-in Grep / Glob in a git repo | `fff` MCP tools | injected on connect |

Not in any `--help`:

- `zat <file>` prints an outline of symbols with line numbers; it has no
  `--help` and takes a file, not a directory. Read the ranges it reports
  instead of the whole file.
- `agent-browser open <url> --allow-private` — required for localhost.
- `agent-browser open <url> --profile ~/.browser-profile` — saved credentials.
- `agent-browser open <url> --args "--no-sandbox"` — required when it reports
  sandbox nesting.
- `zmx` session name: git repo root basename (cwd basename if not a repo).
  `zmx list` first to avoid a collision; `zmx run <name> -d <cmd>`; tell the
  user `zmx attach <name>` so they can watch.
- Quick one-shot commands (git, ls, build) run locally, NOT through `zmx`.
