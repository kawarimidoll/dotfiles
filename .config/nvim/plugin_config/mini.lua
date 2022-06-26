require('mini.bufremove').setup({})

require('mini.comment').setup({})

require('mini.cursorword').setup({})

require('mini.indentscope').setup({})

require('mini.jump2d').setup({
  hooks = { after_jump = function() vim.cmd('syntax on') end },
  mappings = { start_jumping = '' },
})
vim.cmd('highlight MiniJump2dSpot ctermfg=209 ctermbg=NONE cterm=underline,bold guifg=#E27878 guibg=NONE gui=underline,bold')

require('mini.surround').setup({})

require('mini.statusline').setup({
  set_vim_settings = false,
})
vim.cmd('highlight link MiniStatuslineDevinfo String')

require('mini.trailspace').setup({})
vim.cmd([[command! Trim lua MiniTrailspace.trim()]])

require('mini.tabline').setup({})

require('mini.pairs').setup({})

require('mini.misc').setup({ make_global = { 'put', 'put_text', 'zoom' } })

-- require('mini.completion').setup({})
-- vim.api.nvim_set_keymap('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { noremap = true, expr = true })
-- vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })
-- _G.cr_action = function()
--  if vim.fn.pumvisible() == 0 then
--    -- If popup is not visible, use `<CR>` in 'mini.pairs'.
--    return require('mini.pairs').cr()
--  elseif vim.fn.complete_info()['selected'] ~= -1 then
--    -- If popup is visible and item is selected, confirm selected item
--    return vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
--  else
--    -- Add new line otherwise
--    return vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true)
--  end
-- end
-- vim.api.nvim_set_keymap('i', '<CR>', 'v:lua._G.cr_action()', { noremap = true, expr = true })
