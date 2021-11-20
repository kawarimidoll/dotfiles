#!/bin/bash

if ! type cargo >/dev/null 2>&1; then
  echo 'cargo is required.'
  exit 1
fi

cargo install felix
