local function skip_hit_enter(fn, opts)
  opts = opts or {}
  local args = opts.args or {}
  local wait = opts.wait or 0
  local save_mopt = vim.opt.messagesopt:get()
  vim.opt.messagesopt:append('wait:' .. wait)
  vim.opt.messagesopt:remove('hit-enter')
  fn(unpack(args))
  vim.schedule(function()
    vim.opt.messagesopt = save_mopt
  end)
end

vim.api.nvim_create_user_command(
  'LspHealth',
  function()
    skip_hit_enter(
      function()
        vim.cmd.checkhealth('vim.lsp')
      end,
      { wait = 0 }
    )
  end,
  { desc = 'LSP health check' })

vim.diagnostic.config({
  virtual_text = true
})

-- augroup for this config file
local augroup = vim.api.nvim_create_augroup('lsp/init.lua', {})

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/definition') then
      vim.keymap.set('n', 'grd', function()
        vim.lsp.buf.definition()
      end, { buffer = args.buf, desc = 'vim.lsp.buf.definition()' })
    end

    if client:supports_method('textDocument/formatting') then
      vim.keymap.set('n', '<space>i', function()
        vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
      end, { buffer = args.buf, desc = 'Format buffer' })
    end
  end,
})

vim.lsp.config('*', {
  root_markers = { '.git' },
  capabilities = require('mini.completion').get_lsp_capabilities(),
})

local lsp_names = { 'lua_ls' }
vim.notify('Loaded ' .. table.concat(lsp_names, '\n'), vim.log.levels.INFO)
vim.lsp.enable(lsp_names)
