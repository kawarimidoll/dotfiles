local nvim_lsp = require('lspconfig')

-- vim.keymap.set('n', '<space>p', vim.lsp.buf.format, { silent = true })

local default_opts = function()
  local opts = {}

  -- ref: cmp_nvim_lsp.update_capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local completionItem = capabilities.textDocument.completion.completionItem
  completionItem.snippetSupport = true
  completionItem.preselectSupport = true
  completionItem.insertReplaceSupport = true
  completionItem.labelDetailsSupport = true
  completionItem.deprecatedSupport = true
  completionItem.commitCharactersSupport = true
  completionItem.tagSupport = { valueSet = { 1 } }
  completionItem.resolveSupport =
    { properties = { 'documentation', 'detail', 'additionalTextEdits' } }

  opts.capabilities = capabilities

  return opts
end

-- gleam
nvim_lsp.gleam.setup(default_opts())

-- ts_ls
local ts_opts = default_opts()
ts_opts.settings = {
  documentFormatting = false,
  javascript = { suggest = { completeFunctionCalls = true } },
  typescript = { suggest = { completeFunctionCalls = true } },
}

ts_opts.on_attach = function(client)
  if nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc')(vim.fn.getcwd()) then
    if client.name == 'ts_ls' then
      client.stop(true)
      return
    end
  end
end

nvim_lsp.ts_ls.setup(ts_opts)

-- lua_ls
local lua_opts = default_opts()
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
lua_opts.settings = {
  Lua = {
    runtime = {
      version = 'LuaJIT',
      path = { 'lua/?.lua', 'lua/?/init.lua' },
    },
    completion = { callSnippet = 'Both' },
    diagnostics = { globals = { 'vim' } },
    workspace = { library = vim.api.nvim_get_runtime_file('', true) },
    telemetry = { enable = false },
  },
}
nvim_lsp.lua_ls.setup(lua_opts)

-- deno
vim.g.markdown_fenced_languages = {
  'ts=typescript',
  'js=javascript',
  'tsx=typescriptreact',
  'jsx=javascriptreact',
}

local deno_opts = default_opts()
deno_opts.on_attach = function(client)
  if nvim_lsp.util.root_pattern('package.json')(vim.fn.getcwd()) then
    if client.name == 'denols' then
      vim.notify('deno lsp stop')
      client.stop(true)
      return
    end
  end
end

nvim_lsp.denols.setup(deno_opts)

-- rust-analyzer
local rust_opts = default_opts()
rust_opts.settings = {
  inlayHints = {
    typeHints = {
      enable = false,
    },
  },
}
nvim_lsp.rust_analyzer.setup(rust_opts)
