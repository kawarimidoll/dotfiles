import * as k from "karabiner_ts";

// ⌘⌥↵⌫⇧⌃⎋

const EUSUU: k.ToEvent = { key_code: "japanese_eisuu" };
const EUSUU_ESCAPE: k.ToEvent[] = [
  EUSUU,
  { key_code: "escape" },
];
const CMD_SHIFT_ENTER: k.ToEvent[] = [
  {
    key_code: "return_or_enter",
    modifiers: ["command", "shift"],
  },
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
    k.map({ key_code: "caps_lock", modifiers: { optional: ["any"] } }).to({
      key_code: "left_control",
    }),
    // k.map({ key_code: "left_control", modifiers: { optional: ["any"] } }).to({
    //   key_code: "caps_lock",
    // }),
  ]),

  k.rule("Left Control to Hyper Key (⌘⌥⇧⌃)").manipulators([
    k.map({ key_code: "left_control" })
      // k.rule("Caps Lock to Hyper Key (⌘⌥⇧⌃)").manipulators([
      //   k.map({ key_code: "caps_lock" })
      .to({
        key_code: "left_shift",
        modifiers: ["left_command", "left_control", "left_option"],
      })
      .toIfAlone(EUSUU_ESCAPE),
  ]),

  k.rule("cmd to Kana/Eisuu only if alone").manipulators([
    k.withMapper(
      {
        "left_command": "japanese_eisuu",
        "right_command": "japanese_kana",
      } as const,
    )((cmd, lang) =>
      k.map({ key_code: cmd, modifiers: { optional: ["any"] } })
        .to({ key_code: cmd, lazy: true })
        .toIfAlone({ key_code: lang })
        .description(`${cmd} alone to switch to ${lang}`)
        .parameters({ "basic.to_if_held_down_threshold_milliseconds": 100 })
    ),
  ]),

  k.rule("⎋, ⌃[, ⌃⌫ -> japanese_eisuu + ⎋").manipulators([
    k.map("escape").to(EUSUU_ESCAPE),
    k.map("open_bracket", "control").to(EUSUU_ESCAPE),
    k.map("delete_or_backspace", "control").to(EUSUU_ESCAPE),
  ]),

  k.rule("Quit application by holding ⌘q").manipulators([
    k.map({
      key_code: "q",
      modifiers: { mandatory: ["command"], optional: ["caps_lock"] },
    })
      .toIfHeldDown({
        key_code: "q",
        modifiers: ["left_command"],
        repeat: false,
      }),
  ]),

  k.rule(
    "Multiple actions chaining in Ghostty",
    k.ifApp({ bundle_identifiers: ["^com\\.mitchellh\\.ghostty$"] }),
  ).manipulators([
    k.map({
      key_code: "a",
      modifiers: { mandatory: ["command", "shift"] },
    })
      .to([
        EUSUU,
        { key_code: "spacebar" },
        { key_code: "v" },
        { key_code: "i" },
        { key_code: "m" },
        { key_code: "spacebar" },
      ])
      .toAfterKeyUp([
        {
          key_code: "a",
          modifiers: ["command", "shift"],
        },
        { key_code: "return_or_enter" },
      ])
      .description("⌘⇧A → ' vim ' + ⌘⇧A + ↵"),

    k.map({
      key_code: "open_bracket",
      modifiers: { mandatory: ["command", "shift"] },
    })
      .to([
        EUSUU,
        {
          key_code: "open_bracket",
          modifiers: ["command"],
        },
      ])
      .toAfterKeyUp(CMD_SHIFT_ENTER)
      .description("⌘{ → ⌘[ then ⌘⇧↵"),

    k.map({
      key_code: "close_bracket",
      modifiers: { mandatory: ["command", "shift"] },
    })
      .to([
        EUSUU,
        {
          key_code: "close_bracket",
          modifiers: ["command"],
        },
      ])
      .toAfterKeyUp(CMD_SHIFT_ENTER)
      .description("⌘} → ⌘] then ⌘⇧↵"),
  ]),

  k.rule("Toggle between Hyper+5 and Hyper+6 (for Raycast)").manipulators([
    k.map({
      key_code: "up_arrow",
      modifiers: { mandatory: HYPER },
    })
      .to([
        {
          key_code: "5",
          modifiers: HYPER,
        },
      ])
      .condition(k.ifVar("var_hyper", 0))
      .toAfterKeyUp([k.toSetVar("var_hyper", 1)]),

    k.map({
      key_code: "up_arrow",
      modifiers: { mandatory: HYPER },
    })
      .to([
        {
          key_code: "6",
          modifiers: HYPER,
        },
      ])
      .condition(k.ifVar("var_hyper", 1))
      .toAfterKeyUp([k.toSetVar("var_hyper", 0)]),
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
