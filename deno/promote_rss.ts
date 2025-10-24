import AtprotoAPI, { AppBskyFeedPost } from "npm:@atproto/api";
import { parseFeed } from "https://deno.land/x/rss/mod.ts";
import { convertMdLink, getAgent } from "./bsky_post.ts";
import { TextDB } from "https://pax.deno.dev/kawarimidoll/deno-textdb/textdb.ts";

const { RichText } = AtprotoAPI;

if (!import.meta.main || Deno.args.length !== 1) {
  throw "use in CLI with one argument";
}

const dbId = Deno.env.get("TEXTDB_ENDPOINT");
if (!dbId) {
  throw "TEXTDB_ENDPOINT must be set";
}
const db = new TextDB(dbId);
const loadDB = async () => {
  try {
    return JSON.parse(await db.get() || "{}");
  } catch (_) {
    return {};
  }
};
const getDB = async (key: string) => {
  const data = await loadDB();
  return data[key];
};
const putDB = async (key: string, val: string) => {
  const data = await loadDB();
  data[key] = val;
  await db.put(JSON.stringify(data));
};

const fetchLatestArticle = async (site: string) => {
  const [feedURL, name] = {
    zenn: ["https://zenn.dev/kawarimidoll/feed", "Zenn"],
    sizu: ["https://sizu.me/kawarimidoll/rss", "しずかなインターネット"],
  }[site];

  if (!feedURL) {
    console.log("need site name");
    return {};
  }

  const response = await fetch(feedURL);
  const xml = await response.text();

  const { entries } = await parseFeed(xml);

  const { id, title: { value: title }, published, attachments } = entries[0];

  const text = `${name}に記事を公開しました

[${title}](${id})`;

  return { id, title, name, published, text, image: attachments.at(0) };
};

const downloadImage = async (url: string) => {
  const response = await fetch(url);
  const blob = await response.blob();
  const arrayBuffer = await blob.arrayBuffer();
  // Get MIME type from response header or blob
  const mimeType = response.headers.get("content-type") || blob.type || "image/png";
  return { data: new Uint8Array(arrayBuffer), mimeType };
};

const uploadImage = async (
  { image, encoding }: { image: Uint8Array; encoding: string },
) => {
  const agent = getAgent();
  const response = await agent.uploadBlob(image, { encoding });

  return {
    $type: "blob",
    ref: { $link: response.data.blob.ref.toString() },
    mimeType: response.data.blob.mimeType,
    size: response.data.blob.size,
  };
};

const doPost = async (
  { text, embed, facets }: {
    text: string;
    embed?: AppBskyFeedPost.Record["embed"];
    facets?: Facet[];
  },
): Promise<void> => {
  const rt = new RichText({ text, facets: facets || [] });

  const postParams: AppBskyFeedPost.Record = {
    $type: "app.bsky.feed.post",
    ...rt.text,
    createdAt: new Date().toISOString(),
    embed: embed,
  };
  console.log(postParams);
  const agent = getAgent();
  return await agent.post(postParams);
};

const promote = async (siteKey: string) => {
  const { id, title, name, published, text, image } = await fetchLatestArticle(
    siteKey,
  );
  console.log({ id, title, name, published, text, image });

  const latestCache = await getDB(name);
  if (id === latestCache) {
    console.log("this article is already promoted");
    return null;
  }

  let embed = undefined;
  if (image?.url) {
    const { data: img, mimeType } = await downloadImage(image.url);
    const thumb = await uploadImage({
      image: img,
      encoding: mimeType,
    });
    embed = {
      $type: "app.bsky.embed.external",
      external: { uri: id, thumb, title, description: name },
    };
  }

  const convertedText = convertMdLink(text);

  const result = await doPost({ text: convertedText, embed });
  await putDB(name, id);
  return result;
};

const result = await promote(Deno.args.at(0));
console.log(result);
