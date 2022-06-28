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

-- https://github.com/sainnhe/sonokai/blob/master/alacritty/README.md shusia
-- https://github.com/chriskempson/base16/blob/master/styling.md
require('mini.base16').setup({
  palette = {
    -- Default Background
    base00 = "#2d2a2e",
    -- Lighter Background (Used for status bars, line number and folding marks)
    base01 = "#37343a",
    -- Selection Background
    base02 = "#423f46",
    -- Comments, Invisible, Line Highlighting
    base03 = "#848089",
    -- Dark Foreground (Used for status bars)
    base04 = "#66d9ef",
    -- Default Foreground, Caret, Delimiters, Operators
    base05 = "#e3e1e4",
    -- Light Foreground (Not often used)
    base06 = "#a1efe4",
    -- Light Background (Not often used)
    base07 = "#f8f8f2",
    -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base08 = "#f85e84",
    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base09 = "#ef9062",
    -- Classes, Markup Bold, Search Text Background
    base0A = "#a6e22e",
    -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0B = "#e5c463",
    -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0C = "#66d9ef",
    -- Functions, Methods, Attribute IDs, Headings
    base0D = "#9ecd6f",
    -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0E = "#a1efe4",
    -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    base0F = "#f9f8f5",
  },
  use_cterm = true,
})

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
