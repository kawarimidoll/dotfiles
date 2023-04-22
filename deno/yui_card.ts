import AtprotoAPI from "npm:@atproto/api";
const { BskyAgent, RichText } = AtprotoAPI;
// import "https://deno.land/std@0.183.0/dotenv/load.ts";

const service = "https://bsky.social";
const agent = new BskyAgent({ service });

const identifier = Deno.env.get("BLUESKY_IDENTIFIER");
const password = Deno.env.get("BLUESKY_PASSWORD");
await agent.login({ identifier, password });

const richPost = async (text: string) => {
  const rt = new RichText({ text });
  // automatically detects mentions and links
  await rt.detectFacets(agent);
  await agent.post({
    $type: "app.bsky.feed.post",
    text: rt.text,
    facets: rt.facets,
  });
};

await richPost("@yui.bsky.social /card");
await richPost("@yui.bsky.social /card -b");
