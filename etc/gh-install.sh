#!/bin/bash

if ! type gh >/dev/null 2>&1; then
  echo 'gh is required.'
  exit 1
fi

gh extension install kawarimidoll/gh-graph
gh extension install kawarimidoll/gh-q
