import OpenAI from "https://deno.land/x/openai@v4.47.1/mod.ts";

const openai = new OpenAI();

const systemPrompt = [
  "You are an outstanding Japanese-English translator.",
  "Please translate Japanese sentences into English and English sentences into Japanese.",
  "Please handle line breaks that may occur in the middle of sentences or words appropriately.",
  "Please ensure that the sentence structure, such as paragraph breaks and bullets, is not lost in the translation.",
  "Only the resulting translated sentences should be returned; other sentences should not be returned.",
].join(" ");

const testString = `
これはテスト用の文章です。
引数がない場合に使われ、以下の検証を行います。
- 日本語から英語への翻訳
- 文章構造の保存
`;

async function readStdin() {
  if (Deno.stdin.isTerminal()) {
    return "";
  }
  const lines = [];
  const decoder = new TextDecoder();
  for await (const chunk of Deno.stdin.readable) {
    lines.push(decoder.decode(chunk));
  }
  return lines.join("\n");
}

function readArgs() {
  return Deno.args.join("\n");
}

async function main() {
  const userContent = await readStdin() || readArgs() || testString;
  const completion = await openai.chat.completions.create({
    messages: [
      { role: "system", content: systemPrompt },
      { role: "user", content: userContent },
    ],
    model: "gpt-4o-mini",
  });

  console.log(userContent);
  console.log("------");
  console.log(completion.choices[0]?.message.content);
}

main();
