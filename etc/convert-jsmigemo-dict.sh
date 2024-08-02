#!/bin/bash

set -e

# generate no-abbrev-compact-dict for jsmigemo
# required: `rg` and `sponge`
# 1. clone https://github.com/oguna/jsmigemo
# 2. `cd` to root of the repository
# 3. `pnpm install` to generate 'dist' directory
# 4. run this script

rm -rf ./no-abbrev-migemo-dict
rm -rf ./no-abbrev-compact-dict

rg --no-line-number --invert-match '^[a-zA-Z0-9]' ./migemo-dict > ./no-abbrev-migemo-dict

# remove middle alnum
rg --no-line-number --passthru '\t[ a-zA-Z0-9]+(\t)' --replace '$1' ./no-abbrev-migemo-dict | sponge ./no-abbrev-migemo-dict
rg --no-line-number --passthru '\t[ a-zA-Z0-9]+(\t)' --replace '$1' ./no-abbrev-migemo-dict | sponge ./no-abbrev-migemo-dict
rg --no-line-number --passthru '\t[ a-zA-Z0-9]+(\t)' --replace '$1' ./no-abbrev-migemo-dict | sponge ./no-abbrev-migemo-dict

# remove trailing alnum
rg --no-line-number --passthru '\t[ a-zA-Z0-9]+$' --replace '' ./no-abbrev-migemo-dict | sponge ./no-abbrev-migemo-dict

# remove non-sense line
rg --no-line-number --invert-match '^\S+$' ./no-abbrev-migemo-dict | sponge ./no-abbrev-migemo-dict

node bin/jsmigemo-dict.mjs ./no-abbrev-migemo-dict ./no-abbrev-compact-dict

mkdir -p ~/.local/share/jsmigemo
mv ./no-abbrev-compact-dict ~/.local/share/jsmigemo
