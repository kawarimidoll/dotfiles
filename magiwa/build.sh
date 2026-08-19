#!/usr/bin/env bash
# Build Magiwa.app (gitignored).
# The bundle exists for one reason: TCC records the Accessibility grant under
# CFBundleIdentifier, so rebuilds keep it — a bare ad-hoc-signed binary loses
# the grant every time its cdhash changes.
set -euo pipefail
cd "$(dirname "$0")"

APP="Magiwa.app"
mkdir -p "$APP/Contents/MacOS"
cp Info.plist "$APP/Contents/Info.plist"
swiftc -O placement.swift main.swift -o "$APP/Contents/MacOS/magiwa"
# Ad-hoc signing defaults to a cdhash-only designated requirement, so TCC files
# every rebuild as a different app and silently drops the Accessibility grant.
# Pin the requirement to the bundle id so the grant survives.
codesign --sign - --force \
  --identifier com.kawarimidoll.magiwa \
  -r='designated => identifier "com.kawarimidoll.magiwa"' \
  "$APP"
"$APP/Contents/MacOS/magiwa" --selftest

# the launchd agent goes on running the old binary until it is restarted
launchctl kickstart -k "gui/$UID/org.nix-community.home.magiwa" 2>/dev/null || true
