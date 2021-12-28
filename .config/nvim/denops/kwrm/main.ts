import { Denops } from "https://deno.land/x/denops_std@v2.2.0/mod.ts";
import { execute } from "https://deno.land/x/denops_std@v2.2.0/helper/mod.ts";
import { ensureString } from "https://deno.land/x/unknownutil@v1.1.4/mod.ts";

export async function main(denops: Denops): Promise<void> {
  denops.dispatcher = {
    async denopsEcho(text: unknown): Promise<unknown> {
      ensureString(text);
      return await Promise.resolve(`denops_echo: ${text}`);
    },
    async denopsEncodeURI(text: unknown): Promise<unknown> {
      ensureString(text);
      return await Promise.resolve(encodeURI(text));
    },
    async denopsDecodeURI(text: unknown): Promise<unknown> {
      ensureString(text);
      return await Promise.resolve(decodeURI(text));
    },
  };

  await execute(
    denops,
    `command! -nargs=1 DenopsEcho echomsg denops#request('${denops.name}', 'denopsEcho', [<q-args>])`,
  );
  await execute(denops, [
    `function! EncodeURI(arg)`,
    `return denops#request('${denops.name}', 'denopsEncodeURI', [a:arg])`,
    `endfunction`,
  ]);
  await execute(denops, [
    `function! DecodeURI(arg)`,
    `return denops#request('${denops.name}', 'denopsDecodeURI', [a:arg])`,
    `endfunction`,
  ]);
}
