#!/usr/bin/env -S deno run --allow-run --allow-read --allow-write=/tmp --allow-env=CLAUDE_CONFIG_DIR,HOME
// Claude Code statusline script (Deno)
// --allow-run (not --allow-run=git): nix develop injects LD_* env vars,
// which Deno blocks when spawning subprocesses with restricted --allow-run=<cmd>.

const ICON = {
  emotion: {
    happy: "\u{F16A3}",
    sad: "\u{F16A1}",
    neutral: "\u{F06A9}",
  },
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

const EMOTION_PROMPT = `Classify the emotional tone of the user's message into exactly one emotion and an intensity score.
Emotions: happy, sad, neutral.
Happy: explicit praise, gratitude, celebration, strong positive expressions.
Sad: frustration, anger, insults, complaints, feeling stuck, disappointment, strong negative expressions.
Neutral: instructions, requests, task descriptions, questions, enthusiasm about work, factual statements. Urgency about a task does NOT make it happy — only genuine positive sentiment toward the AI or outcome does.
Default to neutral when unsure. Most coding instructions are neutral regardless of tone. Short exclamations of excitement or satisfaction should be classified as happy.
Intensity: 0.0 (barely noticeable) to 1.0 (very strong). ALL CAPS or repeated punctuation indicates stronger emotion — increase intensity by 0.2-0.3.
Reply with ONLY valid JSON: {"emotion": "...", "intensity": ...}`;

const CACHE_PATH = "/tmp/claude-emotion-cache.json";

type Emotion = "happy" | "sad" | "neutral";

function getConfigDir(): string {
  return Deno.env.get("CLAUDE_CONFIG_DIR") ??
    `${Deno.env.get("HOME")}/.claude`;
}

function getLastUserPrompt(projectDir: string): string | null {
  const configDir = getConfigDir();
  const encoded = projectDir.replace(/\//g, "-");
  const sessionsDir = `${configDir}/projects/${encoded}`;

  let latestFile = "";
  let latestMtime = 0;
  try {
    for (const entry of Deno.readDirSync(sessionsDir)) {
      if (!entry.name.endsWith(".jsonl")) continue;
      const path = `${sessionsDir}/${entry.name}`;
      const stat = Deno.statSync(path);
      const mtime = stat.mtime?.getTime() ?? 0;
      if (mtime > latestMtime) {
        latestMtime = mtime;
        latestFile = path;
      }
    }
  } catch {
    return null;
  }
  if (!latestFile) return null;

  let lastText: string | null = null;
  try {
    const text = Deno.readTextFileSync(latestFile);
    for (const line of text.split("\n")) {
      if (!line.trim()) continue;
      const d = JSON.parse(line);
      const msg = d?.message;
      if (msg?.role !== "user") continue;
      const content = msg.content;
      if (Array.isArray(content)) {
        for (const c of content) {
          if (c?.type === "text" && c.text?.trim()) lastText = c.text;
        }
      } else if (typeof content === "string" && content.trim()) {
        lastText = content;
      }
    }
  } catch {
    return null;
  }
  return lastText;
}

interface EmotionCache {
  promptHash: string;
  emotion: Emotion;
}

function hashPrompt(prompt: string): string {
  let h = 0;
  for (let i = 0; i < prompt.length; i++) {
    h = ((h << 5) - h + prompt.charCodeAt(i)) | 0;
  }
  return h.toString(36);
}

function readCache(): EmotionCache | null {
  try {
    return JSON.parse(Deno.readTextFileSync(CACHE_PATH));
  } catch {
    return null;
  }
}

function writeCache(cache: EmotionCache): void {
  try {
    Deno.writeTextFileSync(CACHE_PATH, JSON.stringify(cache));
  } catch { /* best effort */ }
}

async function analyzeEmotion(prompt: string): Promise<Emotion> {
  const hash = hashPrompt(prompt);
  const cache = readCache();
  if (cache?.promptHash === hash) return cache.emotion;

  try {
    const proc = new Deno.Command("claude", {
      args: [
        "-p",
        "--model", "haiku",
        "--max-turns", "1",
        "--system-prompt", EMOTION_PROMPT,
        prompt,
      ],
      stdin: "null",
      stdout: "piped",
      stderr: "null",
    });
    const { stdout } = await proc.output();
    const raw = new TextDecoder().decode(stdout).trim();
    // extract JSON from response
    const match = raw.match(/\{[^}]+\}/);
    if (match) {
      const parsed = JSON.parse(match[0]);
      const emotion: Emotion =
        ["happy", "sad", "neutral"].includes(parsed.emotion)
          ? parsed.emotion
          : "neutral";
      writeCache({ promptHash: hash, emotion });
      return emotion;
    }
  } catch { /* fallback */ }
  return "neutral";
}

async function getGitBranch(cwd?: string): Promise<string> {
  const opts = { stderr: "null" as const, stdout: "null" as const, ...(cwd && { cwd }) };
  try {
    const { success } = await new Deno.Command("git", {
      ...opts,
      args: ["rev-parse", "--git-dir"],
    }).output();
    if (!success) return "";

    const pipeOpts = { ...opts, stdout: "piped" as const };

    const branch = new TextDecoder().decode(
      (await new Deno.Command("git", { ...pipeOpts, args: ["branch", "--show-current"] }).output()).stdout,
    ).trim();
    if (branch) return ` | ${ICON.gitBranch} ${branch}`;

    const hash = new TextDecoder().decode(
      (await new Deno.Command("git", { ...pipeOpts, args: ["rev-parse", "--short", "HEAD"] }).output()).stdout,
    ).trim();
    if (hash) return ` | ${ICON.gitBranch} HEAD (${hash})`;
  } catch {
    // not a git repo
  }
  return "";
}

const buf = new Uint8Array(1024 * 64);
const n = await Deno.stdin.read(buf);
const input = JSON.parse(new TextDecoder().decode(buf.subarray(0, n ?? 0)));

const model = input.model?.display_name ?? "";
const currentDir = input.workspace?.current_dir ?? "";
const projectDir = input.workspace?.project_dir ?? "";
const ctxPct = Math.floor(input.context_window?.used_percentage ?? 0);
const fivePct = Math.floor(input.rate_limits?.five_hour?.used_percentage ?? 0);
const weekPct = Math.floor(input.rate_limits?.seven_day?.used_percentage ?? 0);
const weekReset = input.rate_limits?.seven_day?.resets_at ?? null;

const dirName = currentDir.split("/").pop() ?? "";
const dirSymbol = currentDir !== projectDir ? ICON.folderChanged : ICON.folder;

const [gitBranch, emotion] = await Promise.all([
  getGitBranch(currentDir || undefined),
  (async (): Promise<Emotion> => {
    if (!projectDir) return "neutral";
    const prompt = getLastUserPrompt(projectDir);
    if (!prompt) return "neutral";
    return await analyzeEmotion(prompt);
  })(),
]);
const weekResetDisplay = formatRemaining(weekReset);

const R = COLOR.reset;
const segments = [
  `${ICON.emotion[emotion]} ${model}`,
  `${dirSymbol} ${dirName}${gitBranch}`,
  `ctx ${colorByPct(ctxPct)}${symbolByPct(ctxPct)} ${ctxPct}%${R}`,
  `5h ${colorByPct(fivePct)}${symbolByPct(fivePct)} ${fivePct}%${R}`,
  `7d ${colorByPct(weekPct)}${symbolByPct(weekPct)} ${weekPct}%${R} (~${weekResetDisplay})`,
];

console.log(segments.join(" | "));
