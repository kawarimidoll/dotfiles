#!/bin/bash

if ! type deno >/dev/null 2>&1; then
  echo 'deno is required.'
  exit 1
fi

deno install -Aqfn vr https://deno.land/x/velociraptor/cli.ts
deno install -Aqfn udd https://deno.land/x/udd/main.ts
deno install --allow-read --allow-write --allow-run --reload -qfn dex https://pax.deno.dev/kawarimidoll/deno-dex/main.ts
