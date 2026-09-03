# magiwa

間際 — the **間** (gap) between tiled windows and the **際** (edge) you drag them to.

Window placement for macOS, in two modes sharing one gap model
([`placement.swift`](placement.swift)):

- **CLI** — cycle the frontmost window through placements. Driven by the
  Hyper+arrow rules in [`../karabiner`](../karabiner).
- **daemon** — two things the system does differently:
  - The green button maximizes with a gap on the current desktop instead of
    moving the window to its own Space. Click it again to restore. The resize
    eases over ~0.18s; since each frame is a synchronous AX write, an app that
    relayouts slowly will drop frames. Set `animationDuration` in `main.swift`
    to 0 for a single instant write.
  - Dragging a window by its title bar to a screen edge snaps it there with the
    same gap: sides give halves, corners give quarters, the menu bar gives fill.
    This replaces the built-in edge tiling, which `nix/nix-darwin/default.nix`
    turns off so both do not fire at once.

The gap accounts for [JankyBorders](https://github.com/FelixKratz/JankyBorders)
drawing a border astride each window frame, so the seam between two tiled
windows *looks* the same width as the gap at the screen edge. Both magiwa and
`services.jankyborders` read that width from `nix/magiwa.nix`, so the two
cannot drift apart.

## Build

```bash
./build.sh   # → Magiwa.app (gitignored), runs the self-test, restarts the agent
```

## Permission

Both modes need Accessibility. Add **Magiwa.app** in System Settings → Privacy
& Security → Accessibility. The daemon polls every 2s, so it picks the grant up
without a restart — it never prompts and never exits while waiting, because a
launchd agent that exits on a missing grant gets restarted straight back into
the same state, and each restart pops another focus-stealing dialog.

**Magiwa is only ad-hoc signed, so every rebuild changes its cdhash and can
invalidate the existing TCC record.** The symptom is unmistakable: System
Settings still shows the checkbox on, but the daemon is denied anyway. Clear
the stale record and add it again:

```bash
tccutil reset Accessibility com.kawarimidoll.magiwa
```

Signing with an Apple Development certificate instead would key the grant to
Team ID + Bundle ID and survive rebuilds — `security find-identity -v -p codesigning`
lists what is available.

The CLI is spawned by Karabiner-Elements, which TCC likely treats as the
responsible process, so `karabiner_console_user_server`'s existing grant should
cover it. If the Hyper+arrow shortcuts stop working, approve Magiwa there too.

## Tuning

Values are read from `~/.config/magiwa/config.json` at startup. home-manager
generates that file from `nix/magiwa.nix`; a missing file, an unreadable one,
or an absent key each fall back to the default compiled in.

| key | default | meaning |
|---|---|---|
| `gap` | 8 | margin at the screen edges |
| `borderWidth` | 8 | JankyBorders border width — shared with `services.jankyborders.width` |
| `snapEdge` | 12 | how close to an edge a drag has to end to snap |
| `snapCorner` | 0.25 | top/bottom band that snaps to a quarter, as a height fraction |
| `dragSlop` | 6 | pointer travel before a press counts as a drag |
| `titleBarHeight` | 30 | band at the top of a window treated as its title bar |
| `animationDuration` | 0.18 | seconds the green button takes to resize, 0 for instant |
| `previewAlpha` | 0.7 | snap preview opacity, lower shows more of what is behind |

Changing one takes a `home-manager switch` and a `launchctl kickstart -k`, but
no rebuild — so the Accessibility grant is never disturbed. The daemon logs the
values it ended up with on startup.

## Usage

```bash
bin=Magiwa.app/Contents/MacOS/magiwa
$bin "left,0.5,1;left,0.62,1"   # cycle the frontmost window
$bin                            # run the daemon in the foreground
$bin --selftest                 # check the gap math
```

The daemon normally runs from the launchd agent declared in
`nix/home-manager/default.nix`, logging to `~/Library/Logs/magiwa.log`.
`build.sh` restarts it, but after `launchctl bootout` it needs a bootstrap:

```bash
launchctl bootstrap gui/$UID ~/Library/LaunchAgents/org.nix-community.home.magiwa.plist
launchctl kickstart -k gui/$UID/org.nix-community.home.magiwa   # just to restart
```

Placement syntax: `<anchor>,<wRatio>,<hRatio>[,<maxW>,<maxH>];...` where anchor
is a hyphen-joined set of edges (`left`, `right`, `top`, `bottom`, `center`, and
combinations like `top-left`), and the optional pair caps the size in pixels. An
axis with no edge named stays centered, so `left` means a full-height half.
