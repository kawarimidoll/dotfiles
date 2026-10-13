#!/usr/bin/env bun
// Claude Code statusline script (Bun)

const ICON = {
  robo: "\u{F06A9}",
  folder: "\u{F4D3}",
  folderChanged: "\u{F0252}",
  gitBranch: "\u{E725}",
  battery: [
    // index 0 = lowest, 9 = highest
    "\u{F008E}", // 0-14%
    "\u{F007A}", // 15-24%
    "\u{F007B}", // 25-34%
    "\u{F007C}", // 35-44%
    "\u{F007D}", // 45-54%
    "\u{F007F}", // 55-64%
    "\u{F0080}", // 65-74%
    "\u{F0081}", // 75-84%
    "\u{F0082}", // 85-94%
    "\u{F0083}", // 95-100%
  ],
} as const;

const COLOR = {
  red: "\x1b[31m",
  yellow: "\x1b[33m",
  green: "\x1b[32m",
  reset: "\x1b[0m",
} as const;

function colorByPct(pct: number): string {
  if (pct >= 90) return COLOR.red;
  if (pct >= 70) return COLOR.yellow;
  return COLOR.green;
}

function symbolByPct(pct: number): string {
  const idx = pct >= 95 ? 9 : Math.max(0, Math.floor(pct / 10));
  return ICON.battery[idx];
}

function formatRemaining(resetAt: number | null): string {
  if (resetAt == null) return "-";
  const remaining = resetAt - Math.floor(Date.now() / 1000);
  if (remaining <= 0) return "0";
  if (remaining < 3600) return `${Math.floor(remaining / 60)}m`;
  if (remaining < 86400) return `${Math.floor(remaining / 3600)}h`;
  return `${Math.floor(remaining / 86400)}d`;
}

function git(args: string[], cwd?: string) {
  const { success, stdout } = Bun.spawnSync(["git", ...args], { cwd, stderr: "ignore" });
  return { success, out: stdout.toString().trim() };
}

function getGitBranch(cwd?: string): string {
  try {
    if (!git(["rev-parse", "--git-dir"], cwd).success) return "";

    const branch = git(["branch", "--show-current"], cwd).out;
    if (branch) return ` | ${ICON.gitBranch} ${branch}`;

    const hash = git(["rev-parse", "--short", "HEAD"], cwd).out;
    if (hash) return ` | ${ICON.gitBranch} HEAD (${hash})`;
  } catch {
    // cwd missing or git not found
  }
  return "";
}

const input = await Bun.stdin.json();

const model = (input.model?.display_name ?? "").replace(
  /\s*\(1M context\)/,
  " 1M",
);
const effort = input.effort?.level ?? "";
const modelDisplay = effort ? `${model} ${effort}` : model;
const currentDir = input.workspace?.current_dir ?? "";
const projectDir = input.workspace?.project_dir ?? "";
const ctxPct = Math.floor(input.context_window?.used_percentage ?? 0);
const fivePct = Math.floor(input.rate_limits?.five_hour?.used_percentage ?? 0);
const weekPct = Math.floor(input.rate_limits?.seven_day?.used_percentage ?? 0);
const weekReset = input.rate_limits?.seven_day?.resets_at ?? null;

const dirName = currentDir.split("/").pop() ?? "";
const dirSymbol = currentDir !== projectDir ? ICON.folderChanged : ICON.folder;

const gitBranch = getGitBranch(currentDir || undefined);
const weekResetDisplay = formatRemaining(weekReset);

const R = COLOR.reset;
const segments = [
  `${ICON.robo} ${modelDisplay}`,
  `${dirSymbol} ${dirName}${gitBranch}`,
  `ctx ${colorByPct(ctxPct)}${symbolByPct(ctxPct)} ${ctxPct}%${R}`,
  `5h ${colorByPct(fivePct)}${symbolByPct(fivePct)} ${fivePct}%${R}`,
  `7d ${colorByPct(weekPct)}${symbolByPct(weekPct)} ${weekPct}%${R} (~${weekResetDisplay})`,
];

console.log(segments.join(" | "));
