import { Context, Denops, ensureString, execute } from "../deps.ts";

export async function main(denops: Denops): Promise<void> {
  function dxecute(script: string | string[], ctx?: Context) {
    return execute(denops, script, ctx);
  }
  function dequest(name: string, arg: string) {
    return `denops#request('${denops.name}', '${name}', [${arg}])`;
  }

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

  await dxecute(
    `command! -nargs=1 DenopsEcho echomsg ${dequest("denopsEcho", "<q-args>")}`,
  );
  await dxecute([
    `function! EncodeURI(arg)`,
    `return ${dequest("denopsEncodeURI", "a:arg")}`,
    `endfunction`,
  ]);
  await dxecute([
    `function! DecodeURI(arg)`,
    `return ${dequest("denopsDecodeURI", "a:arg")}`,
    `endfunction`,
  ]);
}
