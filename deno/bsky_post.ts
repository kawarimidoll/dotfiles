import { chunk } from "https://deno.land/std@0.217.0/collections/chunk.ts";
import AtprotoAPI from "npm:@atproto/api";
import type { Facet } from "npm:@atproto/api";
const { BskyAgent, RichText } = AtprotoAPI;

if (!Deno.env.get("GITHUB_ACTIONS")) {
  await import("https://deno.land/std@0.217.0/dotenv/load.ts");
}

const service = "https://bsky.social";
const agent = new BskyAgent({ service });

const identifier = Deno.env.get("BLUESKY_IDENTIFIER");
const password = Deno.env.get("BLUESKY_PASSWORD");
if (!identifier || !password) {
  throw "BLUESKY_IDENTIFIER and BLUESKY_PASSWORD must be set";
}

await agent.login({ identifier, password });

export function getAgent() {
  return agent;
}

type ReplyRef = {
  root: { cid: string; uri: string };
  parent: { cid: string; uri: string };
};

const doRichPost = async (
  text: string,
  opts: { plain?: boolean; facets?: Facet[]; reply?: ReplyRef } = {},
) => {
  const rt = new RichText({ text, facets: opts.facets || [] });
  if (!opts.plain) {
    // automatically detects mentions and links
    await rt.detectFacets(agent);
  }
  // opts.facets is used if exists (overwrites detected facets)
  const facets = [...(rt.facets || []), ...(opts.facets || [])];
  return await agent.post({
    $type: "app.bsky.feed.post",
    text: rt.text,
    facets: facets,
    reply: opts.reply,
  });
};

export const richPost = async (
  text: string,
  opts: { plain?: boolean; facets?: Facet[]; reply?: ReplyRef } = {},
) => {
  if ([...text].length <= 300) {
    return await doRichPost(text, opts);
  }
  const threadMarker = "[🧵]";
  const chunks = chunk([...text], 297).map((c) => c.join(""));

  const first = await doRichPost(chunks[0] + threadMarker, opts);
  const reply = { root: opts.reply?.root || first, parent: first };
  for (const chunk of chunks.slice(1, -1)) {
    const parent = await doRichPost(chunk + threadMarker, { ...opts, reply });
    reply.parent = parent;
  }
  await doRichPost(chunks.at(-1)!, { ...opts, reply });
  return first;
};

export const convertMdLink = (src: string) => {
  const mdLinkRegex = /\[([^\]]+)\]\(([^)]+)\)/;
  const facets = [];
  let cnt = 0;
  while (true) {
    const links = src.match(mdLinkRegex);
    if (!links) {
      return { text: src, facets };
    }
    if (cnt++ > 50) {
      throw "too many loops";
    }
    const [matched, anchor, uri] = links;
    src = src.replace(matched, anchor);

    const byteStart =
      (new TextEncoder()).encode(src.substring(0, links.index)).byteLength;
    const byteEnd = byteStart + (new TextEncoder()).encode(anchor).byteLength;

    facets.push({
      index: { byteStart, byteEnd },
      features: [{ $type: "app.bsky.richtext.facet#link", uri }],
    });
  }
};

export const mdLinkPost = async (src: string) => {
  const { text, facets } = convertMdLink(src);
  return await richPost(text, { facets });
};
// const { text, facets } = convertMdLink(
//   `link test
//
// https://atproto.com/lexicons/com-atproto-moderation#comatprotomoderationdefs
//
// [lexicon](https://atproto.com/guides/lexicon)`,
// );

if (import.meta.main) {
  if (Deno.args.length > 0) {
    console.log(await mdLinkPost(Deno.args.join(" ")));
  } else {
    console.log("pass some args to post.");
  }
}
