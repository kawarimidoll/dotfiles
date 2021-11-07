#!/bin/bash

if ! type deno >/dev/null 2>&1; then
  echo 'deno is required.'
  exit 1
fi

deno install -Arfn vr https://deno.land/x/velociraptor/cli.ts
deno install -Arfn udd https://deno.land/x/udd/main.ts
