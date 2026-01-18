local node_servers_dir = '/Users/kawarimidoll/dotfiles/.config/nvim/node_servers'
local node_bin = node_servers_dir .. '/node_modules/.bin'
if vim.fn.has('vim_starting') == 1 then
  vim.env.PATH = node_bin .. ':' .. vim.env.PATH
end

local Methods = vim.lsp.protocol.Methods

vim.api.nvim_create_user_command('LspHealth', function()
  vim.cmd.checkhealth('vim.lsp')
end, { desc = 'LSP health check' })

vim.api.nvim_create_user_command('LsUpdate', function()
  local function on_exit(obj)
    -- bun updateの結果はstderrに出力される
    local msg = obj.stderr .. obj.stdout
    if obj.code ~= 0 then
      vim.notify('Failed to update language servers:\n' .. msg, vim.log.levels.ERROR)
    else
      vim.notify('Language servers updated!\n' .. msg)
    end
  end

  vim.notify('Updating language servers in ' .. node_servers_dir .. '...')
  vim.system({ 'bun', 'update' }, { text = true, cwd = node_servers_dir }, on_exit)
end, { desc = 'Update language servers with bun update' })

local function diagnostic_format(diagnostic)
  return string.format('%s (%s)', diagnostic.message, diagnostic.source)
end
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { format = diagnostic_format },
  float = { format = diagnostic_format },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
})

-- augroup for this config file
local augroup = vim.api.nvim_create_augroup('mi/lsp.lua', {})

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method(Methods.textDocument_definition) then
      vim.keymap.set('n', 'grd', function()
        vim.lsp.buf.definition()
      end, { buffer = args.buf, desc = 'vim.lsp.buf.definition()' })
    end

    if client:supports_method(Methods.textDocument_documentColor) then
      vim.lsp.document_color.enable(true, args.buf, { style = 'virtual' })
    end

    -- use conform.nvim instead of this
    -- if client:supports_method('textDocument/formatting') then
    --   vim.keymap.set('n', '<space>i', function()
    --     vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
    --   end, { buffer = args.buf, desc = 'Format buffer' })
    -- end
  end,
})

vim.lsp.config('*', {
  cmd = {},
  root_markers = { '.git' },
  capabilities = require('mini.completion').get_lsp_capabilities(),
})

vim.lsp.config('version_lsp', {
  cmd = { 'version-lsp' },
  filetypes = { 'json', 'jsonc', 'toml', 'gomod', 'yaml', 'yaml.github-actions' },
  root_markers = { '.git' },
  settings = {},
})

local lsp_names = {
  'bashls',
  'buf_ls',
  'copilot',
  'cssmodules_ls',
  'denols',
  'docker_compose_language_service',
  'dockerls',
  'emmylua_ls',
  'gh_actions_ls',
  'gleam',
  'glsl_analyzer',
  'gopls',
  'just',
  'nil_ls',
  'oxlint',
  'rust_analyzer',
  'sqlls',
  'superhtml',
  'tombi',
  'tsgo',
  'typos_lsp',
  'version_lsp',
  'yamlls',
  'zls',
  -- 'lua_ls',
  -- 'vtsls',
}

vim.lsp.enable(lsp_names)
-- vim.notify('Loaded ' .. table.concat(lsp_names, '\n'), vim.log.levels.INFO)

-- https://zenn.dev/helloyuki/scraps/ac9e70db8c2dbf
-- rust-analyzerが以下のエラーを出して止まったとき:
-- Unknown binary 'rust-analyzer' in official toolchain '1.82.0-aarch64-apple-darwin'.
-- 以下のコマンドを実行して、rust-analyzerを追加する:
-- rustup component add rust-analyzer
