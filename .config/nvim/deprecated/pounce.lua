local pounce_highlight = function(tbl)
  local default_tbl = {
    underline = true,
    bold = true,
    ctermfg = 'gray',
    ctermbg = 'gray',
    fg = '#555555',
    bg = '#555555',
  }
  return vim.tbl_extend('keep', tbl, default_tbl)
end

vim.api.nvim_set_hl(0, 'PounceGap', pounce_highlight({ ctermbg = 209, bg = '#E27878' }))
vim.api.nvim_set_hl(0, 'PounceMatch', pounce_highlight({ ctermbg = 214, bg = '#FFAF60' }))
vim.api.nvim_set_hl(0, 'PounceAccept', pounce_highlight({ ctermfg = 214, fg = '#FFAF60' }))
vim.api.nvim_set_hl(0, 'PounceAcceptBest', pounce_highlight({ ctermfg = 196, fg = '#EE2513' }))
vim.api.nvim_set_hl(0, 'PounceUnmatched', { ctermfg = 248, fg = '#777777' })
