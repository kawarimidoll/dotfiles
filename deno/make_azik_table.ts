// deno run --allow-write make_azik_table.ts
// https://zenn.dev/vim_jp/articles/neo-azik-for-you

const rows = {
  "-": ["あ", "い", "う", "え", "お"],
  "k": ["か", "き", "く", "け", "こ"],
  "ky": ["きゃ", "き", "きゅ", "きぇ", "きょ"],
  "g": ["が", "ぎ", "ぐ", "げ", "ご"],
  "gy": ["ぎゃ", "ぎ", "ぎゅ", "ぎぇ", "ぎょ"],
  "s": ["さ", "し", "す", "せ", "そ"],
  "sy": ["しゃ", "し", "しゅ", "しぇ", "しょ"],
  "z": ["ざ", "じ", "ず", "ぜ", "ぞ"],
  "zy": ["じゃ", "じ", "じゅ", "じぇ", "じょ"],
  "t": ["た", "ち", "つ", "て", "と"],
  "ts": ["つぁ", "つぃ", "つ", "つぇ", "つぉ"],
  "ty": ["ちゃ", "ち", "ちゅ", "ちぇ", "ちょ"],
  "th": ["てゃ", "てぃ", "てゅ", "てぇ", "てょ"],
  "d": ["だ", "ぢ", "づ", "で", "ど"],
  "dy": ["ぢゃ", "ぢ", "ぢゅ", "ぢぇ", "ぢょ"],
  "dh": ["でゃ", "でぃ", "でゅ", "でぇ", "でょ"],
  "n": ["な", "に", "ぬ", "ね", "の"],
  "ny": ["にゃ", "に", "にゅ", "にぇ", "にょ"],
  "h": ["は", "ひ", "ふ", "へ", "ほ"],
  "hy": ["ひゃ", "ひ", "ひゅ", "ひぇ", "ひょ"],
  "f": ["ふぁ", "ふぃ", "ふ", "ふぇ", "ふぉ"],
  "b": ["ば", "び", "ぶ", "べ", "ぼ"],
  "by": ["びゃ", "び", "びゅ", "びぇ", "びょ"],
  "v": ["ゔぁ", "ゔぃ", "ゔ", "ゔぇ", "ゔぉ"],
  "p": ["ぱ", "ぴ", "ぷ", "ぺ", "ぽ"],
  "py": ["ぴゃ", "ぴ", "ぴゅ", "ぴぇ", "ぴょ"],
  "m": ["ま", "み", "む", "め", "も"],
  "my": ["みゃ", "み", "みゅ", "みぇ", "みょ"],
  "y": ["や", "い", "ゆ", "いぇ", "よ"],
  "r": ["ら", "り", "る", "れ", "ろ"],
  "ry": ["りゃ", "り", "りゅ", "りぇ", "りょ"],
  "w": ["わ", "うぃ", "う", "うぇ", "を"],
  "wh": ["うぁ", "うぃ", "う", "うぇ", "うぉ"],
  "l": ["ぁ", "ぃ", "ぅ", "ぇ", "ぉ"],
  "ly": ["ゃ", "ゐ", "ゅ", "ゑ", "ょ"],
};

const vowelsOrder = {
  "a": 0,
  "i": 1,
  "u": 2,
  "e": 3,
  "o": 4,
};

const vowels = {
  "a": "a",
  "i": "i",
  "u": "u",
  "e": "e",
  "o": "o",
  "q": "aい",
  "h": "uう",
  "w": "eい",
  "p": "oう",
  "z": "aん",
  "k": "iん",
  "j": "uん",
  "d": "eん",
  "l": "oん",
};

const consonants = {
  // normal
  "k": "k",
  "g": "g",
  "s": "s",
  "z": "z",
  "t": "t",
  "d": "d",
  "n": "n",
  "h": "h",
  "b": "b",
  "p": "p",
  "m": "m",
  "y": "y",
  "r": "r",
  "w": "w",
  "f": "f",
  "l": "-",

  // y sound
  "q": "ky",
  "v": "gy",
  "x": "sy",
  "c": "ty",
  "j": "zy",

  // use g
  "wg": "wh",
  "pg": "py",
  "zg": "ts",
  "mg": "my",
  "dg": "dy",
  "bg": "by",
  "tg": "ty",
  "vg": "v",
  "ng": "ny",
  "rg": "ry",
  "xg": "l",
  "yg": "ly",
};

const directKeys = {
  "a": "あ",
  "i": "い",
  "u": "う",
  "e": "え",
  "o": "お",
  "la": "ぁ",
  "li": "ぃ",
  "lu": "ぅ",
  "le": "ぇ",
  "lo": "ぉ",
  ",": "、",
  ".": "。",
  "-": "ー",
  "[": "「",
  "]": "」",
  "/": "・",
  "~": "〜",
};

function generateKanaConversionTable(
  rows: { [key: string]: string[] },
  vowels: { [key: string]: string },
  consonants: { [key: string]: string },
): [string, string][] {
  const result: { [key: string]: string } = {};

  for (const [typeKey1, inputConsonant] of Object.entries(consonants)) {
    const row = rows[inputConsonant];
    if (!row) {
      console.warn(`No row found for ${inputConsonant} in rows`);
      continue;
    }
    for (const [typeKey2, inputVowel] of Object.entries(vowels)) {
      const splitVowels = [...inputVowel];
      const inputKana = [];
      for (const v of splitVowels) {
        if (Object.hasOwn(vowelsOrder, v)) {
          inputKana.push(row[vowelsOrder[v]]);
        } else {
          inputKana.push(v);
        }
      }
      result[typeKey1 + typeKey2] = inputKana.join("");
    }
  }

  return result;
}

const result = {
  ...generateKanaConversionTable(rows, vowels, consonants),
  ...directKeys,
};

for (const c of "bcdfghjklmnpqrstvwxyz".split("")) {
  result[`;${c}`] = `っ\t${c}`;
}
result[";e"] = "←";
result[";u"] = "↓";
result[";i"] = "↑";
result[";o"] = "→";
result[";a"] = "…";
result[";;"] = "っ";

// for (const [k, j] of Object.entries(result)) {
//   console.log(`${k}\t${j}`);
// }

await Deno.writeTextFile(
  "romtable.txt",
  Object.entries(result).map(([k, j]) => `${k}\t${j}`).join("\n"),
);
