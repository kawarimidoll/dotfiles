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

# Check for forbidden commands
# Use word boundary matching to avoid false positives (e.g., "category" matching "cat")
if echo "$command" | grep -qE '\bawk\b'; then
  echo "Use of 'awk' is prohibited. Use 'perl' instead." >&2
  echo "Example: perl -lane 'print \$F[0]' file.txt" >&2
  exit 2
fi

if echo "$command" | grep -qE '\bsed\b'; then
  echo "Use of 'sed' is prohibited. Use 'perl' instead." >&2
  echo "Example: perl -pi -e 's/old/new/g' file.txt" >&2
  exit 2
fi

if echo "$command" | grep -qE '\bcat\b'; then
  echo "Use of 'cat' is prohibited. Use the Read tool to read files." >&2
  exit 2
fi

exit 0
