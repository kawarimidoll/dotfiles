#!/usr/bin/env bash

# Claude Code statusline script
# Uses official context_window fields from stdin JSON

input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# git branch
GIT_BRANCH=""
if git rev-parse &>/dev/null; then
  BRANCH=$(git branch --show-current)
  if [ -n "$BRANCH" ]; then
    GIT_BRANCH=" |  $BRANCH"
  else
    COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null)
    if [ -n "$COMMIT_HASH" ]; then
      GIT_BRANCH=" |  HEAD ($COMMIT_HASH)"
    fi
  fi
fi

# color by usage percentage
if [ "$PCT" -ge 90 ]; then
  COLOR="\033[31m"  # Red
elif [ "$PCT" -ge 70 ]; then
  COLOR="\033[33m"  # Yellow
else
  COLOR="\033[32m"  # Green
fi

echo -e "󰚩 ${MODEL_DISPLAY} |  ${CURRENT_DIR##*/}${GIT_BRANCH} |  ${COLOR}${PCT}%\033[0m"
