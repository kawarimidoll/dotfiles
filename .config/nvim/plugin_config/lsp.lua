local nvim_lsp = require('lspconfig')

-- vim.keymap.set('n', '<space>p', vim.lsp.buf.format, { silent = true })
local bun_bin = '/Users/kawarimidoll/dotfiles/.config/nvim/node_servers/node_modules/.bin'
vim.env.PATH = bun_bin .. ':' .. vim.env.PATH

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

-- https://eiji.page/blog/neovim-diagnostic-config/
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
  -- virtual_lines = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

-- https://www.reddit.com/r/neovim/comments/10n795v/disable_tsserver_in_deno_projects/
local is_node_dir = function()
  return nvim_lsp.util.root_pattern('package.json')(vim.fn.getcwd())
end

-- gleam
nvim_lsp.gleam.setup(default_opts())

-- vtsls
local ts_opts = default_opts()
ts_opts.on_attach = function(client)
  if not is_node_dir() then
    client.stop(true)
  end
end

local vt_opts = vim.deepcopy(ts_opts)
-- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
vt_opts.settings = { typescript = { validate = { enable = false } } }
nvim_lsp.vtsls.setup(vt_opts)

-- eslint
nvim_lsp.eslint.setup(ts_opts)

-- svelte
local svelte_opts = vim.deepcopy(ts_opts)
-- https://github.com/sveltejs/language-tools/tree/master/packages/language-server
svelte_opts.settings = { svelte = { plugin = { svelte = { format = { enable = false } } } } }
nvim_lsp.svelte.setup(svelte_opts)

-- unocss
nvim_lsp.unocss.setup(ts_opts)

-- deno
vim.g.markdown_fenced_languages = {
  'ts=typescript',
  'js=javascript',
  'tsx=typescriptreact',
  'jsx=javascriptreact',
}

local deno_opts = default_opts()
deno_opts.on_attach = function(client)
  if is_node_dir() then
    client.stop(true)
  end
end

nvim_lsp.denols.setup(deno_opts)

-- lua_ls
local lua_opts = default_opts()
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
-- https://zenn.dev/uga_rosa/articles/afe384341fc2e1
lua_opts.on_init = function(client)
  if client.workspace_folders then
    local path = client.workspace_folders[1].name
    ---@diagnostic disable-next-line: undefined-field
    if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
      return
    end
  end

  client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
    runtime = { version = 'LuaJIT' },
    workspace = {
      checkThirdParty = 'Disable',
      library = vim.list_extend(vim.api.nvim_get_runtime_file('lua', true), {
        '${3rd}/luv/library',
        '${3rd}/busted/library',
        '${3rd}/luassert/library',
      }),
    }
  })
end
lua_opts.settings = { Lua = {} }
nvim_lsp.lua_ls.setup(lua_opts)

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

-- superhtml
vim.api.nvim_create_autocmd("Filetype", {
  pattern = { "html", "shtml", "htm" },
  callback = function()
    vim.lsp.start({
      name = "superhtml",
      cmd = { "superhtml", "lsp" },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1])
    })
  end
})
