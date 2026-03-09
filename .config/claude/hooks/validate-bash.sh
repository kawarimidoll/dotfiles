#!/bin/bash
# Validate specific Bash commands usage

# Read JSON input from stdin
input=$(cat)

tool_name=$(echo "$input" | jq -r '.tool_name // ""')
command=$(echo "$input" | jq -r '.tool_input.command // ""')

# Only validate Bash tool
if [[ "$tool_name" != "Bash" ]]; then
  exit 0
fi

# Deny with JSON hookSpecificOutput (same format as rtk-rewrite.sh)
deny() {
  jq -n --arg reason "$1" '{
    "hookSpecificOutput": {
      "hookEventName": "PreToolUse",
      "permissionDecision": "deny",
      "permissionDecisionReason": $reason
    }
  }'
  exit 0
}

# Check for forbidden commands
# Use word boundary matching to avoid false positives (e.g., "category" matching "cat")
if echo "$command" | grep -qE '\bawk\b'; then
  deny "Use of 'awk' is prohibited. Use 'perl' instead. Example: perl -lane 'print \$F[0]' file.txt"
fi

if echo "$command" | grep -qE '\bsed\b'; then
  deny "Use of 'sed' is prohibited. Use 'perl' instead. Example: perl -pi -e 's/old/new/g' file.txt"
fi

if echo "$command" | grep -qE '\bpush\b'; then
  deny "Do not execute 'git push'. Please ask the user to execute it."
fi

if echo "$command" | grep -qE '\bgit add (-A|--all|\.($|[ ;|&]))'; then
  deny "Do not git-add all files. Specify the file name(s) to add."
fi

if echo "$command" | grep -qE '\bgit checkout\b'; then
  deny "Use of 'git checkout' is prohibited. Use 'git switch' for branch switching and 'git restore' for file restoration instead."
fi

if echo "$command" | grep -qE '\bgit clean\b.*-[a-zA-Z]*f'; then
  deny "Use of 'git clean -f' is prohibited. It deletes untracked files irreversibly. Ask the user to execute it."
fi

if echo "$command" | grep -qE '\bgit branch\b.*\s-D\b'; then
  deny "Use of 'git branch -D' is prohibited. Use 'git branch -d' for safe deletion, or ask the user to force-delete."
fi

if echo "$command" | grep -qE '\bgit stash\b.*(drop|clear)\b'; then
  deny "Use of 'git stash drop/clear' is prohibited. Ask the user to execute it."
fi

if echo "$command" | grep -qiE '\bDROP\s+(TABLE|DATABASE)\b|\bTRUNCATE\b'; then
  deny "Destructive SQL (DROP/TRUNCATE) is prohibited. Ask the user to execute it."
fi

if echo "$command" | grep -qE '\b(env|printenv|export)\b'; then
  deny "Accessing environment variables is prohibited. Ask the user to check or set environment variables on your behalf."
fi

exit 0
