#!/usr/bin/env bash

# Claude Code statusline script
# Uses official context_window and rate_limits fields from stdin JSON

input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PROJECT_DIR=$(echo "$input" | jq -r '.workspace.project_dir')
CTX_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
FIVE_PCT=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' | cut -d. -f1)
WEEK_PCT=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // 0' | cut -d. -f1)
WEEK_RESET=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at')

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

color_by_pct() {
  local pct=$1
  if [ "$pct" -ge 90 ]; then
    echo "\033[31m"
  elif [ "$pct" -ge 70 ]; then
    echo "\033[33m"
  else
    echo "\033[32m"
  fi
}

symbol_by_pct() {
  local pct=$1
  if [ "$pct" -ge 95 ]; then
    echo "󰂃 "
  elif [ "$pct" -ge 85 ]; then
    echo "󰂂 "
  elif [ "$pct" -ge 75 ]; then
    echo "󰂁 "
  elif [ "$pct" -ge 65 ]; then
    echo "󰂀 "
  elif [ "$pct" -ge 55 ]; then
    echo "󰁿 "
  elif [ "$pct" -ge 45 ]; then
    echo "󰁽 "
  elif [ "$pct" -ge 35 ]; then
    echo "󰁼 "
  elif [ "$pct" -ge 25 ]; then
    echo "󰁻 "
  elif [ "$pct" -ge 15 ]; then
    echo "󰁺 "
  else
    echo "󰂎 "
  fi
}

RST="\033[0m"
CTX_COLOR=$(color_by_pct "$CTX_PCT")
FIVE_COLOR=$(color_by_pct "$FIVE_PCT")
WEEK_COLOR=$(color_by_pct "$WEEK_PCT")
CTX_SYMBOL=$(symbol_by_pct "$CTX_PCT")
FIVE_SYMBOL=$(symbol_by_pct "$FIVE_PCT")
WEEK_SYMBOL=$(symbol_by_pct "$WEEK_PCT")

DIR_SYMBOL=" "
[ "$CURRENT_DIR" != "$PROJECT_DIR" ] && DIR_SYMBOL="󰉒 "

if [ "$WEEK_RESET" != "null" ] && [ -n "$WEEK_RESET" ]; then
  REMAINING=$(( WEEK_RESET - $(date +%s) ))
  if [ "$REMAINING" -le 0 ]; then
    WEEK_RESET_DISPLAY="0"
  elif [ "$REMAINING" -lt 3600 ]; then
    WEEK_RESET_DISPLAY="$((REMAINING / 60))m"
  elif [ "$REMAINING" -lt 86400 ]; then
    WEEK_RESET_DISPLAY="$((REMAINING / 3600))h"
  else
    WEEK_RESET_DISPLAY="$((REMAINING / 86400))d"
  fi
else
  WEEK_RESET_DISPLAY="-"
fi

echo -e "󰚩 ${MODEL_DISPLAY} | ${DIR_SYMBOL}${CURRENT_DIR##*/}${GIT_BRANCH} | ctx ${CTX_COLOR}${CTX_SYMBOL}${CTX_PCT}%${RST} | 5h ${FIVE_COLOR}${FIVE_SYMBOL}${FIVE_PCT}%${RST} | 7d ${WEEK_COLOR}${WEEK_SYMBOL}${WEEK_PCT}%${RST} (~${WEEK_RESET_DISPLAY})"
