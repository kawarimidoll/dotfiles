#!/usr/bin/env bash

# Read JSON input from stdin
input=$(cat)

MESSAGE=$(echo "$input" | jq -r '.message')

case "$MESSAGE" in
  'Claude is waiting for your input')
    # do nothing
    exit 0
    ;;
  'Claude Code login successful')
    NOTIFY_MSG="ログイン成功"
    ;;
  'Claude needs your permission to use '*)
    NOTIFY_MSG="${MESSAGE#Claude needs your permission to use }の許可が必要です"
    ;;
  *)
    NOTIFY_MSG="${MESSAGE}"
    ;;
esac

osascript -e "display notification \"${NOTIFY_MSG}\" with title \"Claude Code\" sound name \"Glass\""
