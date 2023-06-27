local cmp = require('cmp')
local lspkind = require('lspkind')

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.keycode(key), mode, true)
end

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
require("copilot_cmp").setup()

local copilot_common_sources = {
  { name = 'copilot' },
  { name = 'nvim_lsp' },
  { name = 'vsnip' },
  { name = 'cmp_tabnine' },
  { name = 'treesitter' },
  { name = 'buffer' },
  { name = 'nvim_lua' },
  { name = 'rg' },
  -- { name = 'spell' },
  -- { name = 'look', keyword_length = 2, option = { convert_case = true, loud = true } },
}

cmp.setup({
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      max_width = 50,
      symbol_map = { Copilot = "" }
    })
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available'](1) == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources(copilot_common_sources)
})

CmpSetSkkeleton = function()
  vim.notify('cmp skk')
  cmp.setup.buffer({
    sources = cmp.config.sources({
      { name = 'skkeleton' }
    })
  })
end

CmpSetCommon = function()
  vim.notify('cmp common')
  cmp.setup.buffer({
    sources = cmp.config.sources(copilot_common_sources)
  })
end

-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'nvim_lsp_document_symbol' }
--   }, {
--     { name = 'buffer' }
--   }),
-- })
--
-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' },
--     { name = 'cmdline' },
--   }),
-- })
