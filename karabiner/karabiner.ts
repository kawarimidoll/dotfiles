import * as k from "karabiner_ts";

type SimpleModification = {
  from: { key_code: string };
  to: Array<{ key_code: string }>;
};

function simpleModifications(
  params: {
    from: Parameters<typeof k.getKeyWithAlias>[0];
    to: Parameters<typeof k.getKeyWithAlias>[0];
  }[],
): SimpleModification[] {
  return params.map((p) => {
    const from = k.getKeyWithAlias(p.from);
    const to = k.getKeyWithAlias(p.to);
    return { from: { key_code: from }, to: [{ key_code: to }] };
  });
}

type DeviceWithSimpleModifications = {
  identifiers: k.DeviceIdentifier;
  simple_modifications: SimpleModification[];
};

type ExtendedProfile = k.KarabinerProfile & {
  devices?: DeviceWithSimpleModifications[];
  // global simple_modifications
  simple_modifications?: SimpleModification[];
};

function applySimpleModifications(
  profile: ExtendedProfile,
  identifiers: k.DeviceIdentifier,
  simple_modifications: SimpleModification[],
) {
  const targetDevice = profile.devices?.find((d) =>
    d.identifiers.is_keyboard &&
    d.identifiers.vendor_id === identifiers.vendor_id &&
    d.identifiers.product_id === identifiers.product_id
  );
  if (targetDevice) {
    targetDevice.simple_modifications = simple_modifications;
  } else {
    profile.devices = [
      ...(profile.devices || []),
      { identifiers, simple_modifications },
    ];
  }
}

function exitWithError(err: unknown): never {
  if (err) {
    if (typeof err == "string") {
      console.error(err);
    } else {
      console.error((err as Error).message || err);
    }
  }
  Deno.exit(1);
}

const REALFORCE_HYBRID_US_FULL = {
  product_id: 769,
  vendor_id: 2131,
  is_keyboard: true,
} as const satisfies k.DeviceIdentifier;

const ROYUAN_GAMING_KEYBOARD = {
  product_id: 16405,
  vendor_id: 12625,
  is_keyboard: true,
} as const satisfies k.DeviceIdentifier;

// 8BitDo Zero 2 gamepad (No manufacturer name) in keyboard mode.
// vendor 0x2dc8 / product 0x3230. Each button emits a hardware-fixed letter:
//   A:g B:j X:h Y:i R:m L:k ↑:c ↓:d ←:e →:f Start:o Select:n
const EIGHT_BITDO_ZERO2 = {
  product_id: 12848,
  vendor_id: 11720,
  is_keyboard: true,
} as const satisfies k.DeviceIdentifier;

// 8BitDo Micro (No manufacturer name) in keyboard mode.
// vendor 0x2dc8 / product 0x9021. Each button emits a hardware-fixed letter:
//   A:g B:j X:h Y:i R1:m L1:k R2:r L2:l ↑:c ↓:d ←:e →:f Plus:o Minus:n Star:s
const EIGHT_BITDO_MICRO = {
  product_id: 36897,
  vendor_id: 11720,
  is_keyboard: true,
} as const satisfies k.DeviceIdentifier;

// const LUNAKEY_PICO = {
//   product_id: 3,
//   vendor_id: 22868,
//   is_keyboard: true,
// } as const satisfies k.DeviceIdentifier;

const APPLE_INTERNAL_KEYBOARD = {
  is_keyboard: true,
} as const satisfies k.DeviceIdentifier;

// Cycle the frontmost window through placements via the compiled CLI in this
// repo (build: deno task build-resizer). It matches the window's current
// frame against the placement rects to pick the next one, so a newly targeted
// window always starts the cycle from placements[0] — no cycle state is kept
// in karabiner variables.
// Requires Accessibility permission for karabiner_console_user_server.
type WindowAnchor = "left" | "center" | "right";
// [anchor, w, h] ratios, optionally capped at [maxW, maxH] pixels
type WindowPlacement =
  | [WindowAnchor, number, number]
  | [WindowAnchor, number, number, number, number];

function windowCycle(placements: WindowPlacement[]): k.ToEvent {
  const bin = "$HOME/dotfiles/karabiner/window-resize";
  const spec = placements
    .map(([anchor, w, h, maxW, maxH]) =>
      [
        anchor,
        w.toFixed(3),
        h.toFixed(3),
        ...(maxW !== undefined ? [maxW, maxH] : []),
      ].join(",")
    )
    .join(";");
  return {
    shell_command: `${bin} "${spec}"`,
  };
}

const EISUU: k.ToEvent = { key_code: "japanese_eisuu" };
const EISUU_ESCAPE: k.ToEvent[] = [
  EISUU,
  { key_code: "escape" },
];

const HYPER = "⌘⌥⌃⇧";

const TO_IF_MILLISECONDS =
  "basic.to_if_held_down_threshold_milliseconds" as const;

// Build manipulators that remap a gamepad's emitted letter to a target key.
// A plain string is a key (alias); a tuple adds modifiers, e.g. ["⇥", "l⌃"].
type ToSpec = k.ToKeyParam | [k.ToKeyParam, k.ModifierParam];
function gamepadMap(map: Record<string, ToSpec>) {
  return Object.entries(map).map(([from, spec]) => {
    const m = k.map(from as k.FromKeyParam);
    return Array.isArray(spec) ? m.to(spec[0], spec[1]) : m.to(spec);
  });
}

const profileName = "Default profile";

k.writeToProfile(profileName, [
  k.rule(`Caps Lock to Hyper Key (${HYPER}), escape if alone`).manipulators([
    k.map("⇪")
      .toHyper()
      .toIfAlone(EISUU_ESCAPE),
  ]),

  k.rule("cmd to Kana/Eisuu only if alone").manipulators([
    k.withMapper(
      {
        "left_command": "japanese_eisuu",
        "right_command": "japanese_kana",
      } as const,
    )((cmd, lang) =>
      k.map(cmd, "??")
        .to({ key_code: cmd, lazy: true })
        .toIfAlone({ key_code: lang })
        .description(`${cmd} alone to switch to ${lang}`)
        .parameters({ [TO_IF_MILLISECONDS]: 100 })
    ),
  ]),

  k.rule("Quote key to Option when held, Quote when alone").manipulators([
    k.map("'")
      .to("l⌥", {}, { lazy: true })
      .toIfAlone("'")
      .parameters({ [TO_IF_MILLISECONDS]: 200 }),
  ]),

  k.rule("⎋, ⌃[, ⌃⌫ -> japanese_eisuu + ⎋").manipulators([
    k.map("⎋").to(EISUU_ESCAPE),
    k.map("[", "⌃").to(EISUU_ESCAPE),
    k.map("⌫", "⌃").to(EISUU_ESCAPE),
  ]),

  k.rule("⌃m -> ⏎").manipulators([
    k.map("m", "⌃").to("⏎"),
  ]),

  k.rule("Quit application by holding ⌘q").manipulators([
    k.map("q", "⌘", "⇪").toIfHeldDown("q", "l⌘", { repeat: false })
      .parameters({ [TO_IF_MILLISECONDS]: 300 }),
  ]),

  k.rule(
    "Multiple actions chaining in Ghostty",
    k.ifApp("^com\\.mitchellh\\.ghostty$"),
  ).manipulators([
    // toPaste(" vim ") はtoAfterKeyUpよりあとになることがあるので採用を断念
    // k.map("a", "⌘⇧")
    //   .to(EISUU)
    //   .to("q", "l⌥")
    //   .to("␣")
    //   .to("v")
    //   .to("i")
    //   .to("m")
    //   .to("␣")
    //   .toAfterKeyUp("a", "⌘⇧")
    //   .toAfterKeyUp("⏎")
    //   .description("⌘⇧A → ' vim ' + ⌘⇧A + ⏎"),

    // k.map("y", "⌘⇧")
    //   .to(EISUU)
    //   .to("y", "⌘⇧")
    //   .toAfterKeyUp("y", "⌘")
    //   .description("⌘⇧y → ⌘⇧y then ⌘y"),

    k.map("[", "⌘⇧")
      .to(EISUU)
      .to("[", "⌘")
      .toAfterKeyUp("⏎", "⌘⇧")
      .description("⌘{ → ⌘[ then ⌘⇧⏎"),

    k.map("]", "⌘⇧")
      .to(EISUU)
      .to("]", "⌘")
      .toAfterKeyUp("⏎", "⌘⇧")
      .description("⌘} → ⌘] then ⌘⇧⏎"),
  ]),

  k.rule(
    "⌘z/⌘⇧z to undo/redo in terminal apps",
    k.ifApp(["^com\\.mitchellh\\.ghostty$"]),
  ).manipulators([
    // undo ⌃_
    k.map("z", "⌘").to("-", "⌃⇧"),
    // redo ⌃=
    k.map("z", "⌘⇧").to("=", "⌃"),
  ]),

  k.rule("Hyper+arrows to cycle window placement").manipulators([
    k.map("↑", HYPER).to(windowCycle([
      ["center", 1, 1], // maximize
      ["center", 0.6, 0.6, 1024, 900], // reasonable-size
      ["center", 0.9, 0.9], // almost-maximize
    ])),
    k.map("←", HYPER).to(windowCycle([
      ["left", 1 / 2, 1],
      ["left", 2 / 3, 1],
      ["left", 1 / 3, 1],
    ])),
    k.map("↓", HYPER).to(windowCycle([
      ["center", 1 / 2, 1],
      ["center", 2 / 3, 1],
      ["center", 1 / 3, 1],
    ])),
    k.map("→", HYPER).to(windowCycle([
      ["right", 1 / 2, 1],
      ["right", 2 / 3, 1],
      ["right", 1 / 3, 1],
    ])),
  ]),

  k.rule(
    "⌘. to open current Finder directory in Ghostty",
    k.ifApp("^com\\.apple\\.finder$"),
  ).manipulators([
    k.map(".", "⌘").to({
      shell_command:
        "osascript -e 'tell application \"Finder\" to set cwd to POSIX path of (target of front window as alias)' -e 'tell application \"Ghostty\"' -e 'activate' -e 'set conf to new surface configuration' -e 'set initial working directory of conf to cwd' -e 'new window with configuration conf' -e 'end tell'",
    }),
  ]),

  k.rule(
    "Emacs-like ctrl key settings for Slack, Notion and Figma",
    k.ifApp([
      "^com\.tinyspeck\.slackmacgap$",
      "^notion\.id$",
      "^com\.figma\.Desktop$",
    ]),
  )
    .manipulators(
      (Object.entries(
        {
          n: "↓",
          p: "↑",
          b: "←",
          f: "→",
          // a: "↖",
          // e: "↘",
          h: "⌫",
          d: "⌦",
          m: "⏎",
          i: "⇥",
        } as const,
      )).map(([fromKey, toKey]) =>
        k.map(fromKey as k.FromKeyParam, "l⌃", "any")
          .to(toKey)
      ),
    ),

  // 8BitDo Zero 2: app-specific overrides come BEFORE the base rule so they
  // win (first matching manipulator wins); unlisted buttons fall back to base.
  k.rule(
    "8BitDo Zero 2 in Anki",
    // Anki's frontmost bundle id varies by version (classic vs. launcher);
    // match both. Confirm via Karabiner EventViewer if it ever stops matching.
    k.ifApp(["^net\\.ankiweb\\.dtop$", "^net\\.ankiweb\\.launcher$"]),
    k.ifDevice(EIGHT_BITDO_ZERO2),
  ).manipulators(
    gamepadMap({
      g: "⏎", // A
      j: "2", // B
      h: "1", // X
      i: "d", // Y
      m: "u", // R
      k: "y", // L
      o: "s", // Start
    }),
  ),

  k.rule(
    "8BitDo Zero 2 in Ghostty",
    k.ifApp("^com\\.mitchellh\\.ghostty$"),
    k.ifDevice(EIGHT_BITDO_ZERO2),
  ).manipulators(
    gamepadMap({
      g: "⏎", // A
      j: "⎋", // B
      h: "⌫", // X → backspace
      m: ["⇥", "l⌃"], // R → ⌃⇥
      k: ["⇥", "l⌃⇧"], // L → ⌃⇧⇥
      o: ["-", "l⌃⇧"], // Start → ⌃⇧-
      n: ["v", "l⌘⌥⌃⇧"], // Select → ⌘⌃⌥⇧v
    }),
  ),

  // Base mapping: each button emits the key printed on it.
  k.rule(
    "8BitDo Zero 2 buttons to printed labels",
    k.ifDevice(EIGHT_BITDO_ZERO2),
  ).manipulators(
    gamepadMap({
      g: "a", // A
      j: "b", // B
      h: "x", // X
      i: "y", // Y
      m: "r", // R
      k: "l", // L
      c: "↑",
      d: "↓",
      e: "←",
      f: "→",
      o: "home", // Start
      n: "end", // Select
    }),
  ),

  // 8BitDo Micro: same letter-emitting layout as the Zero 2 plus R2(r), L2(l)
  // and Star(s). App-specific overrides come BEFORE the base rule so they win;
  // unlisted buttons fall back to base.
  k.rule(
    "8BitDo Micro in Anki",
    k.ifApp(["^net\\.ankiweb\\.dtop$", "^net\\.ankiweb\\.launcher$"]),
    k.ifDevice(EIGHT_BITDO_MICRO),
  ).manipulators(
    gamepadMap({
      g: "⏎", // A
      j: "2", // B
      h: "1", // X
      i: "d", // Y
      m: "u", // R1
      k: "y", // L1
      o: "s", // Plus
    }),
  ),

  k.rule(
    "8BitDo Micro in Ghostty",
    k.ifApp("^com\\.mitchellh\\.ghostty$"),
    k.ifDevice(EIGHT_BITDO_MICRO),
  ).manipulators(
    gamepadMap({
      g: "⏎", // A
      j: "⎋", // B
      h: "⌫", // X → backspace
      m: ["⇥", "l⌃"], // R1 → ⌃⇥
      k: ["⇥", "l⌃⇧"], // L1 → ⌃⇧⇥
      o: ["-", "l⌃⇧"], // Plus → ⌃⇧-
      n: ["v", "l⌘⌥⌃⇧"], // Minus → ⌘⌃⌥⇧v
    }),
  ),

  // Base mapping: each button emits the key printed on it.
  k.rule(
    "8BitDo Micro buttons to printed labels",
    k.ifDevice(EIGHT_BITDO_MICRO),
  ).manipulators(
    gamepadMap({
      g: "a", // A
      j: "b", // B
      h: "x", // X
      i: "y", // Y
      m: "r", // R1
      k: "l", // L1
      r: "v", // R2
      l: "w", // L2
      c: "↑",
      d: "↓",
      e: "←",
      f: "→",
      o: ["=", "⇧"], // Plus → +
      n: "-", // Minus → -
      s: "s", // Star
    }),
  ),
]);

// ここからはsimple_modificationsの設定 独自追加

const swapCapsCtrl = simpleModifications([
  { from: "⇪", to: "l⌃" },
  { from: "l⌃", to: "⇪" },
]);
const swapCmdOpt = simpleModifications([
  { from: "l⌘", to: "l⌥" },
  { from: "l⌥", to: "l⌘" },
  { from: "r⌘", to: "r⌥" },
  { from: "r⌥", to: "r⌘" },
]);

const fn = [Deno.env.get("HOME")!, ".config", "karabiner", "karabiner.json"]
  .join("/");

const config = JSON.parse(Deno.readTextFileSync(fn)) as k.KarabinerConfig;

// karabiner.tsのほうで存在判定されているのでこの段階で落ちることは無いはず
const profile = config?.profiles.find((v) =>
  v.name == profileName
)! as ExtendedProfile;

applySimpleModifications(
  profile,
  APPLE_INTERNAL_KEYBOARD,
  swapCapsCtrl,
);
applySimpleModifications(
  profile,
  ROYUAN_GAMING_KEYBOARD,
  swapCapsCtrl,
);
applySimpleModifications(
  profile,
  REALFORCE_HYBRID_US_FULL,
  [...swapCapsCtrl, ...swapCmdOpt],
);
// 8BitDo Zero 2 is fully handled by the complex modifications above; clear any
// device-level simple_modifications (e.g. left over from Karabiner GUI setup)
// so they don't double-map or conflict with the complex rules.
applySimpleModifications(
  profile,
  EIGHT_BITDO_ZERO2,
  [],
);
// 8BitDo Micro is likewise fully handled by the complex modifications above;
// clear any device-level simple_modifications so they don't conflict.
applySimpleModifications(
  profile,
  EIGHT_BITDO_MICRO,
  [],
);

const json = JSON.stringify(config, null, 2);
Deno.writeTextFile(fn, json).catch(exitWithError);

console.log(`✓ Profile ${profileName} simple_modifications updated.`);
