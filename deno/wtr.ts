import { DOMParser, Element } from "jsr:@b-fuze/deno-dom";

// --- Types ---

type TimeOfDay = "Day" | "Night";

type WeatherData = {
  icon: string;
  temp: string;
  wind: string;
  gusts: string;
  pop: string;
  pot: string;
  prec: string;
  cloud: string;
  dir: string;
  winDir: string;
  name: string;
  aa: string[];
  rain: string;
};

type WeatherSummary = Record<TimeOfDay, WeatherData>;

// --- Constants ---

const ACCUWEATHER_URL =
  "https://www.accuweather.com/en/jp/tokyo/226396/weather-tomorrow/226396";

const USER_AGENT =
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36";

const RETRY_COUNT = 3;
const RETRY_DELAY_SEC = 5;

const PANEL_KEY_MAP: Record<string, keyof WeatherData> = {
  Wind: "wind",
  "Wind Gusts": "gusts",
  "Probability of Precipitation": "pop",
  "Probability of Thunderstorms": "pot",
  Precipitation: "prec",
  "Cloud Cover": "cloud",
};

const WIND_DIR_MAP: Record<string, string> = {
  N: "\u2191",
  S: "\u2193",
  E: "\u2192",
  W: "\u2190",
};

const ICON_TO_NAME: Record<string, string> = {
  "1": "Sunny",
  "2": "PartlyCloudy",
  "3": "PartlyCloudy",
  "4": "PartlyCloudy",
  "5": "PartlyCloudy",
  "6": "PartlyCloudy",
  "7": "Cloudy",
  "8": "Cloudy",
  "11": "Cloudy",
  "12": "LightRain",
  "13": "LightShowers",
  "14": "LightShowers",
  "15": "Thunder",
  "16": "LightThunder",
  "17": "LightThunder",
  "18": "HeavyRain",
  "19": "LightSnow",
  "20": "LightSnowShowers",
  "21": "LightSnowShowers",
  "22": "HeavySnow",
  "23": "HeavySnowShowers",
  "24": "LightSleet",
  "25": "LightSleet",
  "26": "LightSleet",
  "29": "LightSleet",
  "30": "HighTemp",
  "31": "LowTemp",
  "32": "Windy",
  "33": "Sunny",
  "34": "PartlyCloudy",
  "35": "PartlyCloudy",
  "36": "PartlyCloudy",
  "37": "PartlyCloudy",
  "38": "PartlyCloudy",
  "39": "LightRain",
  "40": "LightRain",
  "41": "LightThunder",
  "42": "LightThunder",
  "43": "LightSnowShowers",
  "44": "HeavySnowShowers",
};

// https://github.com/schachmat/wego/blob/master/frontends/ascii-art-table.go
const AA_TABLE: Record<string, string[]> = {
  Unknown: [
    "    .-.      ",
    "     __)     ",
    "    (        ",
    "     `-\u1FBF     ",
    "      \u2022      ",
  ],
  Cloudy: [
    "             ",
    "     .--.    ",
    "  .-(    ).  ",
    " (___.__)__) ",
    "             ",
  ],
  Fog: [
    "             ",
    " _ - _ - _ - ",
    "  _ - _ - _  ",
    " _ - _ - _ - ",
    "             ",
  ],
  HeavyRain: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "  \u201A\u02BB\u201A\u02BB\u201A\u02BB\u201A\u02BB   ",
    "  \u201A\u02BB\u201A\u02BB\u201A\u02BB\u201A\u02BB   ",
  ],
  HeavyShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "   \u201A\u02BB\u201A\u02BB\u201A\u02BB\u201A\u02BB  ",
    "   \u201A\u02BB\u201A\u02BB\u201A\u02BB\u201A\u02BB  ",
  ],
  HeavySnow: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "   * * * *   ",
    "  * * * *    ",
  ],
  HeavySnowShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "    * * * *  ",
    "   * * * *   ",
  ],
  LightRain: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "    \u02BB \u02BB \u02BB \u02BB  ",
    "   \u02BB \u02BB \u02BB \u02BB   ",
  ],
  LightShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "     \u02BB \u02BB \u02BB \u02BB ",
    "    \u02BB \u02BB \u02BB \u02BB  ",
  ],
  LightSleet: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "    \u02BB * \u02BB *  ",
    "   * \u02BB * \u02BB   ",
  ],
  LightSleetShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "     \u02BB * \u02BB * ",
    "    * \u02BB * \u02BB  ",
  ],
  LightSnow: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "    *  *  *  ",
    "   *  *  *   ",
  ],
  LightSnowShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "     *  *  * ",
    "    *  *  *  ",
  ],
  PartlyCloudy: [
    "   \\__/      ",
    " __/  .-.    ",
    "   \\_(   ).  ",
    "   /(___(__) ",
    "             ",
  ],
  Sunny: [
    "    \\ . /    ",
    "   - .-. -   ",
    "  \u2012 (   ) \u2012  ",
    "   . `-\u1FBF .   ",
    "    / ' \\    ",
  ],
  Thunder: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "    \u03DF  \u03DF     ",
    "      \u03DF      ",
  ],
  LightThunder: [
    "   \\__/      ",
    " __/  .-.    ",
    "   \\_(   ).  ",
    "   /(___(__) ",
    "     \u03DF  \u03DF    ",
  ],
  ThunderyHeavyRain: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "  \u201A\u02BB\u03DF\u02BB\u201A\u03DF\u201A\u02BB   ",
    "  \u201A\u02BB\u201A\u02BB\u03DF\u02BB\u201A\u02BB   ",
  ],
  ThunderyShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "    \u03DF\u02BB \u02BB\u03DF\u02BB \u02BB ",
    "    \u02BB \u02BB \u02BB \u02BB  ",
  ],
  ThunderySnowShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "     *\u03DF *\u03DF * ",
    "    *  *  *  ",
  ],
  Windy: [
    "             ",
    " ____)       ",
    "  ______)    ",
    " __________) ",
    "             ",
  ],
  HighTemp: [
    "     .-.     ",
    "     |*|     ",
    "     |*|     ",
    "     |*|     ",
    "    (___)    ",
  ],
  LowTemp: [
    "     .-.     ",
    "     | |     ",
    "     | |     ",
    "     |*|     ",
    "    (___)    ",
  ],
};

// --- Helper functions ---

function sleep(seconds: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, seconds * 1000));
}

function extractNumber(str: string): string {
  return str.match(/\d+(\.\d+)?/)?.at(0) || "";
}

function toWindArrow(dir: string): string {
  if (WIND_DIR_MAP[dir]) return WIND_DIR_MAP[dir];
  if (/NE/.test(dir)) return "\u2197";
  if (/NW/.test(dir)) return "\u2196";
  if (/SE/.test(dir)) return "\u2198";
  return "\u2199";
}

function getTomorrow(): Date {
  const d = new Date();
  d.setDate(d.getDate() + 1);
  return d;
}

function formatDate(date: Date): { mm: string; dd: string; www: string; dateStr: string } {
  const mm = (date.getMonth() + 1).toString().padStart(2, "0");
  const dd = date.getDate().toString().padStart(2, "0");
  const www = date.toLocaleDateString("en-US", { weekday: "short" });
  const dateStr = `${date.getFullYear()}-${mm}-${dd}`;
  return { mm, dd, www, dateStr };
}

// --- Core functions ---

async function fetchWeatherPage(): Promise<string> {
  for (let i = 0; i <= RETRY_COUNT; i++) {
    try {
      const response = await fetch(ACCUWEATHER_URL, {
        headers: { "User-Agent": USER_AGENT },
      });
      return await response.text();
    } catch (error) {
      console.error(error);
      if (i < RETRY_COUNT) {
        console.log(`Retry ${i + 1}/${RETRY_COUNT} after ${RETRY_DELAY_SEC} seconds...`);
        await sleep(RETRY_DELAY_SEC);
      }
    }
  }
  throw new Error("Failed to fetch weather page");
}

function parseWeatherCard(card: Element): [string, WeatherData] {
  const title = card.querySelector(".title")!.textContent as TimeOfDay;
  const temp = extractNumber(card.querySelector(".temperature")!.firstChild!.textContent);
  const iconSrc = (card.querySelector(".icon") as Element)?.dataset?.src || "";
  const icon = extractNumber(iconSrc);
  const name = ICON_TO_NAME[icon] || "Unknown";

  const partial: Record<string, string> = {};
  for (const item of card.querySelectorAll(".panel-item")) {
    const key = PANEL_KEY_MAP[(item as Element).firstChild!.textContent];
    if (key) {
      partial[key] = extractNumber((item as Element).lastChild!.textContent);
      if (key === "wind") {
        partial.dir = (item as Element).lastChild!.textContent.replace(/ .*/, "");
      }
    }
  }

  const dir = partial.dir || "";
  const data: WeatherData = {
    icon,
    temp,
    wind: partial.wind || "",
    gusts: partial.gusts || "",
    pop: partial.pop || "",
    pot: partial.pot || "",
    prec: partial.prec || "",
    cloud: partial.cloud || "",
    dir,
    winDir: toWindArrow(dir),
    name,
    aa: AA_TABLE[name] || AA_TABLE.Unknown,
    rain: `${partial.prec || "0"} mm | ${partial.pop || "0"} %`.padEnd(15, " "),
  };

  return [title, data];
}

function parseWeatherPage(html: string): WeatherSummary {
  const doc = new DOMParser().parseFromString(html, "text/html")!;
  const cards = doc.querySelectorAll(".half-day-card");
  const summary: Partial<WeatherSummary> = {};

  for (const card of cards) {
    const [title, data] = parseWeatherCard(card as Element);
    if (title === "Day" || title === "Night") {
      summary[title] = data;
    }
  }

  if (!summary.Day || !summary.Night) {
    throw new Error("Day or Night data not found");
  }

  return summary as WeatherSummary;
}

function renderHalfDay(data: WeatherData): string[] {
  return [
    `${data.aa[0]} ${data.name.padEnd(15, " ")}`,
    `${data.aa[1]} ${`${data.temp} \u00B0C`.padEnd(11, " ")}`,
    `${data.aa[2]} ${data.winDir} ${data.wind.padStart(3, " ")} km/h (${data.gusts.padStart(2, " ")})`,
    `${data.aa[3]} cloud ${data.cloud.padStart(3, " ")}%`,
    `${data.aa[4]} ${data.rain}`,
  ];
}

function renderWeather(summary: WeatherSummary, tomorrow: Date): string {
  const { mm, dd, www } = formatDate(tomorrow);
  const day = renderHalfDay(summary.Day);
  const night = renderHalfDay(summary.Night);

  const header = [
    `                        \u250C\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510`,
    `\u250C\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2524  ${mm}/${dd} ${www}  \u251C\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510`,
    `\u2502             Day       \u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2534\u2500\u2500\u2500\u2500\u2500\u2500\u2518      Night            \u2502`,
    `\u251C\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u253C\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2524`,
  ];
  const body = day.map((line, i) =>
    `\u2502${line} \u2502${night[i]} \u2502`
  );
  const footer = `\u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2534\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518`;

  return [...header, ...body, footer].join("\n");
}

function writeToObsidian(result: string, tomorrow: Date): void {
  const { dateStr } = formatDate(tomorrow);
  const obsidianHome = `${Deno.env.get("HOME")}/Dropbox/Obsidian`;
  const filename = `${obsidianHome}/daily/${dateStr}.md`;
  const logname = `${obsidianHome}/scripts/weather.log`;
  const timestamp = new Date().toISOString();

  try {
    const contents = Deno.readTextFileSync(filename);
    const placeholder = "{{weather}}";
    if (contents.includes(placeholder)) {
      Deno.writeTextFileSync(filename, contents.replace(placeholder, result));
      console.log(`Weather written to the file ${filename}`);
      Deno.writeTextFileSync(logname, `${timestamp}\nWeather written to the file`);
    } else {
      console.log(`Weather is ALREADY written to the file ${filename}`);
    }
  } catch (error) {
    console.error(error);
    try {
      Deno.writeTextFileSync(logname, `${timestamp}\n${error}`);
    } catch {
      // write permission may not be available
    }
  }
}

// --- Main ---

async function main(): Promise<void> {
  const html = await fetchWeatherPage();
  const summary = parseWeatherPage(html);
  const tomorrow = getTomorrow();
  const result = renderWeather(summary, tomorrow);

  console.log(result);
  writeToObsidian(result, tomorrow);
}

await main();
