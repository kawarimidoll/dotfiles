import {
  DOMParser,
  Element,
} from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";

const response = await fetch(
  "https://www.accuweather.com/en/jp/tokyo/226396/current-weather/226396",
);

const html = await response.text();
const doc = new DOMParser().parseFromString(html, "text/html")!;

const extractNumber = (str) => str.match(/\d+(\.\d+)?/)?.at(0) || "";

const keyMap = {
  // "Max UV Index": "uv",
  Wind: "wind",
  "Wind Gusts": "gusts",
  "Probability of Precipitation": "pop",
  "Probability of Thunderstorms": "pot",
  Precipitation: "prec",
  "Cloud Cover": "cloud",
};

const winDir = (dir) => {
  if (dir === "N") return "↑";
  if (dir === "S") return "↓";
  if (dir === "E") return "→";
  if (dir === "W") return "←";
  if (/NE/.test(dir)) return "↗";
  if (/NW/.test(dir)) return "↖";
  if (/SE/.test(dir)) return "↘";
  return "↙";
};

const dateString = () => {
  const d = new Date();
  const mm = (d.getMonth() + 1).toString();
  const dd = (d.getDate()).toString();
  const wd = ["日", "月", "火", "水", "木", "金", "土"][d.getDay()];
  return `${mm.padStart(2, "0")}/${dd.padStart(2, "0")} ${wd}`;
};

const nameMap = {
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
const aaTable = {
  Unknown: [
    "    .-.      ",
    "     __)     ",
    "    (        ",
    "     `-᾿     ",
    "      •      ",
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
    "  ‚ʻ‚ʻ‚ʻ‚ʻ   ",
    "  ‚ʻ‚ʻ‚ʻ‚ʻ   ",
  ],
  HeavyShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "   ‚ʻ‚ʻ‚ʻ‚ʻ  ",
    "   ‚ʻ‚ʻ‚ʻ‚ʻ  ",
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
    "    ʻ ʻ ʻ ʻ  ",
    "   ʻ ʻ ʻ ʻ   ",
  ],
  LightShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "     ʻ ʻ ʻ ʻ ",
    "    ʻ ʻ ʻ ʻ  ",
  ],
  LightSleet: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "    ʻ * ʻ *  ",
    "   * ʻ * ʻ   ",
  ],
  LightSleetShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "     ʻ * ʻ * ",
    "    * ʻ * ʻ  ",
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
    "  ‒ (   ) ‒  ",
    "   . `-᾿ .   ",
    "    / ' \\    ",
  ],
  Thunder: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "    ϟ  ϟ     ",
    "      ϟ      ",
  ],
  LightThunder: [
    "   \\__/      ",
    " __/  .-.    ",
    "   \\_(   ).  ",
    "   /(___(__) ",
    "     ϟ  ϟ    ",
  ],
  ThunderyHeavyRain: [
    "     .-.     ",
    "    (   ).   ",
    "   (___(__)  ",
    "  ‚ʻϟʻ‚ϟ‚ʻ   ",
    "  ‚ʻ‚ʻϟʻ‚ʻ   ",
  ],
  ThunderyShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "    ϟʻ ʻϟʻ ʻ ",
    "    ʻ ʻ ʻ ʻ  ",
  ],
  ThunderySnowShowers: [
    ' _`/"".-.    ',
    "  ,\\_(   ).  ",
    "   /(___(__) ",
    "     *ϟ *ϟ * ",
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

// Unknown:             "✨",
// Cloudy:              "☁️",
// Fog:                 "🌫",
// HeavyRain:           "🌧",
// HeavyShowers:        "🌧",
// HeavySnow:           "❄️",
// HeavySnowShowers:    "❄️",
// LightRain:           "🌦",
// LightShowers:        "🌦",
// LightSleet:          "🌧",
// LightSleetShowers:   "🌧",
// LightSnow:           "🌨",
// LightSnowShowers:    "🌨",
// PartlyCloudy:        "⛅️",
// Sunny:               "☀️",
// ThunderyHeavyRain:   "🌩",
// ThunderyShowers:     "⛈",
// ThunderySnowShowers: "⛈",
// VeryCloudy:          "☁️",

const cards = doc.querySelectorAll(".half-day-card")!;
const summary = {};

for (const card of cards) {
  const title = card.querySelector(".title")!.textContent;

  const temp = card.querySelector(".temperature")!
    .firstChild.textContent;

  const icon = card.querySelector(".icon")!;
  const src = icon.dataset?.src || "";
  const data = { icon: extractNumber(src), temp: extractNumber(temp) };

  const panelItems = card.querySelectorAll(".panel-item")!;
  for (const item of panelItems) {
    const k = keyMap[item.firstChild.textContent];
    if (!k) {
      continue;
    }
    data[k] = extractNumber(item.lastChild.textContent);
    if (k === "wind") {
      data.dir = item.lastChild.textContent.replace(/ .*/, "");
    }
  }

  data.winDir = winDir(data.dir);

  data.name = nameMap[data.icon];
  const aa = aaTable[data.name] || aaTable.Unknown;
  data.aa = aa;

  summary[title] = data;
}

// console.log(summary);

const template = `
                        ┌─────────────┐
┌───────────────────────┤   01/01-曜  ├───────────────────────┐
│             Day       └──────┬──────┘      Night            │
├──────────────────────────────┼──────────────────────────────┤
│0qqqqqqqqqqqq nameaaaaaaaaaa  │0qqqqqqqqqqqq nameaaaaaaaaaa  │
│1qqqqqqqqqqqq tp °C           │1qqqqqqqqqqqq tp °C           │
│2qqqqqqqqqqqq d ww3 km/h (gu) │2qqqqqqqqqqqq d ww3 km/h (gu) │
│3qqqqqqqqqqqq cloud cov%      │3qqqqqqqqqqqq cloud cov%      │
│4qqqqqqqqqqqq pre mm | pp3%   │4qqqqqqqqqqqq pre mm | pp3 %  │
└──────────────────────────────┴──────────────────────────────┘
`;

if (summary.Day && summary.Night) {
  const result = template
    .replace("01/01-曜", dateString())
    .replace("d", summary.Day.winDir)
    .replace("d", summary.Night.winDir)
    .replace("ww3", summary.Day.wind.padStart(3, " "))
    .replace("ww3", summary.Night.wind.padStart(3, " "))
    .replace("gu", summary.Day.gusts)
    .replace("gu", summary.Night.gusts)
    .replace("cov", summary.Day.cloud.padStart(3, " "))
    .replace("cov", summary.Night.cloud.padStart(3, " "))
    .replace("pre", summary.Day.prec)
    .replace("pre", summary.Night.prec)
    .replace("pp3", summary.Day.pop.padStart(3, " "))
    .replace("pp3", summary.Night.pop.padStart(3, " "))
    .replace("tp", summary.Day.temp)
    .replace("tp", summary.Night.temp)
    .replace(/namea+/, summary.Day.name.padEnd(14, " "))
    .replace(/namea+/, summary.Night.name.padEnd(14, " "))
    .replace(/0q+/, summary.Day.aa[0])
    .replace(/1q+/, summary.Day.aa[1])
    .replace(/2q+/, summary.Day.aa[2])
    .replace(/3q+/, summary.Day.aa[3])
    .replace(/4q+/, summary.Day.aa[4])
    .replace(/0q+/, summary.Night.aa[0])
    .replace(/1q+/, summary.Night.aa[1])
    .replace(/2q+/, summary.Night.aa[2])
    .replace(/3q+/, summary.Night.aa[3])
    .replace(/4q+/, summary.Night.aa[4]);
  console.log(result);
}

// Wind: "W 15 km/h",
// "Wind Gusts": "30 km/h",
// "Probability of Precipitation": "1%",
// "Probability of Thunderstorms": "0%",
// Precipitation: "0.0 mm",
// "Cloud Cover": "77%"
