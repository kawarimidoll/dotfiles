#!/bin/bash

plugins_dir="$HOME/Library/Application Support/xbar/plugins"
for f in $(find * -not -path '*.DS_Store' -path '*.*.*' -print)
do
  if [ -L "$plugins_dir/$f" ]; then
    ln -sfv "$PWD/$f" "$plugins_dir/$f"
  else
    ln -sniv "$PWD/$f" "$plugins_dir/$f"
  fi
done
