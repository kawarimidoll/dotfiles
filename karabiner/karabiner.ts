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

// const LUNAKEY_PICO = {
//   product_id: 3,
//   vendor_id: 22868,
//   is_keyboard: true,
// } as const satisfies k.DeviceIdentifier;

const APPLE_INTERNAL_KEYBOARD = {
  is_keyboard: true,
} as const satisfies k.DeviceIdentifier;

type RaycastWindowAction =
  | "maximize"
  | "almost-maximize"
  | "reasonable-size"
  | "next-display"
  | "previous-display";

function raycastWindowAction(name: RaycastWindowAction) {
  return {
    "shell_command":
      `open -g raycast://extensions/raycast/window-management/${name}`,
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

const profileName = "Karabiner-TS";

// k.writeToProfile("Default profile", [
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

  k.rule("Hyper+↑ to cycle window size using Raycast").manipulators([
    // to run this, allow permission to use external call in Raycast
    (() => {
      const varName = "var_window_cycle";
      return [
        k.map("↑", HYPER)
          .to(raycastWindowAction("reasonable-size"))
          .condition(k.ifVar(varName, 1))
          .toAfterKeyUp(k.toSetVar(varName, 2)),
        k.map("↑", HYPER)
          .to(raycastWindowAction("almost-maximize"))
          .condition(k.ifVar(varName, 2))
          .toAfterKeyUp(k.toSetVar(varName, 0)),
        // fallback: value 0 or any unexpected value → maximize
        k.map("↑", HYPER)
          .to(raycastWindowAction("maximize"))
          .toAfterKeyUp(k.toSetVar(varName, 1)),
      ];
    })(),
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

const json = JSON.stringify(config, null, 2);
Deno.writeTextFile(fn, json).catch(exitWithError);

console.log(`✓ Profile ${profileName} simple_modifications updated.`);
