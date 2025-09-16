import * as k from "karabiner_ts";

// ⌘⌥↵⌫⇧⌃⎋

const EISUU: k.ToEvent = { key_code: "japanese_eisuu" };
const EISUU_ESCAPE: k.ToEvent[] = [
  EISUU,
  { key_code: "escape" },
];
const HYPER: k.Modifier[] = ["command", "shift", "option", "control"];

const emacsLikeApps = k.ifApp([
  "^com\.tinyspeck\.slackmacgap$",
  "^notion\.id$",
  "^com\.figma\.Desktop$",
]);

const emacsLikeKeymappings = {
  n: "down_arrow",
  p: "up_arrow",
  b: "left_arrow",
  f: "right_arrow",
  // a: "home",
  // e: "end",
  h: "delete_or_backspace",
  d: "delete_forward",
  m: "return_or_enter",
  i: "tab",
} as const;

// k.writeToProfile("Default profile", [
k.writeToProfile("Karabiner-TS", [
  k.rule("Change caps_lock to left_control").manipulators([
    k.map("⇪", "??").to("l⌃"),
    // k.map("l⌃", "??").to("⇪"),
  ]),

  k.rule("Left Control to Hyper Key (⌘⌥⇧⌃)").manipulators([
    // k.rule("Caps Lock to Hyper Key (⌘⌥⇧⌃)").manipulators([
    k.map("l⌃")
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

  k.rule("Toggle between Hyper+5 and Hyper+6 (for Raycast)").manipulators([
    k.map("↑", HYPER)
      .to("5", HYPER)
      .condition(k.ifVar("var_hyper", 0))
      .toAfterKeyUp(k.toSetVar("var_hyper", 1)),

    k.map("↑", HYPER)
      .to("6", HYPER)
      .condition(k.ifVar("var_hyper", 1))
      .toAfterKeyUp(k.toSetVar("var_hyper", 0)),
  ]),

  k.rule(
    "Emacs-like ctrl key settings for Slack, Notion and Figma",
    emacsLikeApps,
  )
    .manipulators(
      (Object.keys(
        emacsLikeKeymappings,
      ) as (keyof typeof emacsLikeKeymappings)[]).map((fromKey) =>
        k.map({
          key_code: fromKey,
          modifiers: { mandatory: ["left_control"], optional: ["any"] },
        })
          .to({ key_code: emacsLikeKeymappings[fromKey] })
      ),
    ),
]);
