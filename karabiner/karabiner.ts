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
        .parameters({ "basic.to_if_held_down_threshold_milliseconds": 100 })
    ),
  ]),

  k.rule("⎋, ⌃[, ⌃⌫ -> japanese_eisuu + ⎋").manipulators([
    k.map("⎋").to(EISUU_ESCAPE),
    k.map("[", "⌃").to(EISUU_ESCAPE),
    k.map("⌫", "⌃").to(EISUU_ESCAPE),
  ]),

  k.rule("Quit application by holding ⌘q").manipulators([
    k.map("q", "⌘", "⇪").toIfHeldDown("q", "l⌘", { repeat: false }),
  ]),

  k.rule(
    "Multiple actions chaining in Ghostty",
    k.ifApp("^com\\.mitchellh\\.ghostty$"),
  ).manipulators([
    // toPaste(" vim ") はtoAfterKeyUpよりあとになることがあるので採用を断念
    k.map("a", "⌘⇧")
      .to(EISUU)
      .to("␣")
      .to("v")
      .to("i")
      .to("m")
      .to("␣")
      .toAfterKeyUp("a", "⌘⇧")
      .toAfterKeyUp("⏎")
      .description("⌘⇧A → ' vim ' + ⌘⇧A + ⏎"),

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
    "⌘z to ⌃_ in terminal apps",
    k.ifApp("^com\\.mitchellh\\.ghostty$"),
  ).manipulators([
    k.map("z", "⌘").to("-", "⌃⇧"),
  ]),

  k.rule("Hyper+↑ to cicle window size using Raycast").manipulators([
    // to run this, allow permission to use external call in Raycast
    (() => {
      const varName = "var_window_cycle";
      const windowActions = [
        "maximize",
        "reasonable-size",
        "almost-maximize",
      ] as const;
      return k.withMapper(windowActions)((action, index) => {
        const nextIndex = (index + 1) % windowActions.length;
        return k.map("↑", HYPER)
          .to(raycastWindowAction(action))
          .condition(k.ifVar(varName, index))
          .toAfterKeyUp(k.toSetVar(varName, nextIndex));
      });
    })(),
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
  REALFORCE_HYBRID_US_FULL,
  [...swapCapsCtrl, ...swapCmdOpt],
);

const json = JSON.stringify(config, null, 2);
Deno.writeTextFile(fn, json).catch(exitWithError);

console.log(`✓ Profile ${profileName} simple_modifications updated.`);
