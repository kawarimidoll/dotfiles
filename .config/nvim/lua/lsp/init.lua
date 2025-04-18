local function skip_hit_enter(fn, opts)
  opts = opts or {}
  if type(fn) ~= 'function' then
    error('fn must be a function')
  end
  local wait = opts.wait or 0
  if type(wait) ~= 'number' then
    error('wait must be a number')
  end
  return function(...)
    local save_mopt = vim.opt.messagesopt:get()
    vim.opt.messagesopt:append('wait:' .. wait)
    vim.opt.messagesopt:remove('hit-enter')
    fn(...)
    vim.schedule(function()
      vim.opt.messagesopt = save_mopt
    end)
  end
end

local node_bin = '/Users/kawarimidoll/dotfiles/.config/nvim/node_servers/node_modules/.bin'
if vim.fn.has('vim_starting') == 1 then
  vim.env.PATH = node_bin .. ':' .. vim.env.PATH

  vim.cmd.checkhealth = skip_hit_enter(vim.cmd.checkhealth)
end

vim.api.nvim_create_user_command('LspHealth', function()
  vim.cmd.checkhealth('vim.lsp')
end, { desc = 'LSP health check' })

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
