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
local shusia = {
  base00 = "#2d2a2e", -- Default Background
  base01 = "#37343a", -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = "#423f46", -- Selection Background
  base03 = "#848089", -- Comments, Invisible, Line Highlighting
  base04 = "#66d9ef", -- Dark Foreground (Used for status bars)
  base05 = "#e3e1e4", -- Default Foreground, Caret, Delimiters, Operators
  base06 = "#a1efe4", -- Light Foreground (Not often used)
  base07 = "#f8f8f2", -- Light Background (Not often used)
  base08 = "#f85e84", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#ef9062", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#a6e22e", -- Classes, Markup Bold, Search Text Background
  base0B = "#e5c463", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#66d9ef", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#9ecd6f", -- Functions, Methods, Attribute IDs, Headings
  base0E = "#a1efe4", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#f9f8f5", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}
-- https://base16-project.github.io/base16-gallery/
local kanagawa = {
  base00 = "#1F1F28", -- Default Background
  base01 = "#16161D", -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = "#223249", -- Selection Background
  base03 = "#54546D", -- Comments, Invisible, Line Highlighting
  base04 = "#727169", -- Dark Foreground (Used for status bars)
  base05 = "#DCD7BA", -- Default Foreground, Caret, Delimiters, Operators
  base06 = "#C8C093", -- Light Foreground (Not often used)
  base07 = "#717C7C", -- Light Background (Not often used)
  base08 = "#C34043", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#FFA066", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#C0A36E", -- Classes, Markup Bold, Search Text Background
  base0B = "#76946A", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#6A9589", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#7E9CD8", -- Functions, Methods, Attribute IDs, Headings
  base0E = "#957FB8", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#D27E99", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}
local materia = {
  base00 = "#263238", -- Default Background
  base01 = "#2C393F", -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = "#37474F", -- Selection Background
  base03 = "#707880", -- Comments, Invisible, Line Highlighting
  base04 = "#C9CCD3", -- Dark Foreground (Used for status bars)
  base05 = "#CDD3DE", -- Default Foreground, Caret, Delimiters, Operators
  base06 = "#D5DBE5", -- Light Foreground (Not often used)
  base07 = "#FFFFFF", -- Light Background (Not often used)
  base08 = "#EC5F67", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#EA9560", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#FFCC00", -- Classes, Markup Bold, Search Text Background
  base0B = "#8BD649", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#80CBC4", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#89DDFF", -- Functions, Methods, Attribute IDs, Headings
  base0E = "#82AAFF", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#EC5F67", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}
local everforest = {
  base00 = "#2b3339", -- Default Background
  base01 = "#323c41", -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = "#3a4248", -- Selection Background
  base03 = "#868d80", -- Comments, Invisible, Line Highlighting
  base04 = "#a59572", -- Dark Foreground (Used for status bars)
  base05 = "#d3c6aa", -- Default Foreground, Caret, Delimiters, Operators
  base06 = "#e9e8d2", -- Light Foreground (Not often used)
  base07 = "#fff9e8", -- Light Background (Not often used)
  base08 = "#7fbbb3", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#d699b6", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#83c092", -- Classes, Markup Bold, Search Text Background
  base0B = "#dbbc7f", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#e69875", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#a7c080", -- Functions, Methods, Attribute IDs, Headings
  base0E = "#e67e80", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#d699b6", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}
local atlas = {
  base00 = "#002635", -- Default Background
  base01 = "#00384d", -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = "#517F8D", -- Selection Background
  base03 = "#6C8B91", -- Comments, Invisible, Line Highlighting
  base04 = "#869696", -- Dark Foreground (Used for status bars)
  base05 = "#a1a19a", -- Default Foreground, Caret, Delimiters, Operators
  base06 = "#e6e6dc", -- Light Foreground (Not often used)
  base07 = "#fafaf8", -- Light Background (Not often used)
  base08 = "#ff5a67", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#f08e48", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#ffcc1b", -- Classes, Markup Bold, Search Text Background
  base0B = "#7fc06e", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#5dd7b9", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#14747e", -- Functions, Methods, Attribute IDs, Headings
  base0E = "#9a70a4", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#c43060", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}
local ayu_mirage = {
  base00 = "#171B24", -- Default Background
  base01 = "#1F2430", -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = "#242936", -- Selection Background
  base03 = "#707A8C", -- Comments, Invisible, Line Highlighting
  base04 = "#8A9199", -- Dark Foreground (Used for status bars)
  base05 = "#CCCAC2", -- Default Foreground, Caret, Delimiters, Operators
  base06 = "#D9D7CE", -- Light Foreground (Not often used)
  base07 = "#F3F4F5", -- Light Background (Not often used)
  base08 = "#F28779", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#FFAD66", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#FFD173", -- Classes, Markup Bold, Search Text Background
  base0B = "#D5FF80", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#95E6CB", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#5CCFE6", -- Functions, Methods, Attribute IDs, Headings
  base0E = "#D4BFFF", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#F29E74", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

require('mini.base16').setup({
  palette = ayu_mirage,
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
