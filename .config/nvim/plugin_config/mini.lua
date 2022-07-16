require('mini.bufremove').setup({})

require('mini.comment').setup({})

require('mini.cursorword').setup({})

require('mini.indentscope').setup({})

require('mini.jump2d').setup({
  hooks = { after_jump = function() vim.cmd('syntax on') end },
  mappings = { start_jumping = '' },
})
vim.cmd('highlight MiniJump2dSpot ctermfg=209 ctermbg=NONE cterm=underline,bold guifg=#E27878 guibg=NONE gui=underline,bold')
vim.g.minijump2d_disable = true

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

-- https://github.com/chriskempson/base16/blob/master/styling.md
local palettes = {
  -- https://github.com/sainnhe/sonokai/blob/master/alacritty/README.md shusia
  shusia = {
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
  },
  -- https://github.com/KeitaNakamura/neodark.vim/blob/master/colors/neodark.vim
  neodark = {
    base00 = "#1F2F38", -- Default Background
    base01 = "#263A45", -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = "#475C69", -- Selection Background
    base03 = "#658595", -- Comments, Invisible, Line Highlighting
    base04 = "#D4AE58", -- Dark Foreground (Used for status bars)
    base05 = "#AABBC4", -- Default Foreground, Caret, Delimiters, Operators
    base06 = "#C99720", -- Light Foreground (Not often used)
    base07 = "#72C7D1", -- Light Background (Not often used)
    base08 = "#4BB1A7", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "#DC657D", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "#B888E2", -- Classes, Markup Bold, Search Text Background
    base0B = "#E18254", -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "#E69CA0", -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "#639EE4", -- Functions, Methods, Attribute IDs, Headings
    base0E = "#84B97C", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "#AE8785", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  -- https://base16-project.github.io/base16-gallery/
  kanagawa = {
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
  },
  materia = {
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
  },
  everforest = {
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
  },
  atlas = {
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
  },
  ayu_mirage = {
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
  },
  darcula = {
    base00 = "#2b2b2b", -- Default Background
    base01 = "#323232", -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = "#323232", -- Selection Background
    base03 = "#606366", -- Comments, Invisible, Line Highlighting
    base04 = "#a4a3a3", -- Dark Foreground (Used for status bars)
    base05 = "#a9b7c6", -- Default Foreground, Caret, Delimiters, Operators
    base06 = "#ffc66d", -- Light Foreground (Not often used)
    base07 = "#ffffff", -- Light Background (Not often used)
    base08 = "#4eade5", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "#689757", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "#bbb529", -- Classes, Markup Bold, Search Text Background
    base0B = "#6a8759", -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "#629755", -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "#9876aa", -- Functions, Methods, Attribute IDs, Headings
    base0E = "#cc7832", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "#808080", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  atelier_dune = {
    base00 = "#20201d", -- Default Background
    base01 = "#292824", -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = "#6e6b5e", -- Selection Background
    base03 = "#7d7a68", -- Comments, Invisible, Line Highlighting
    base04 = "#999580", -- Dark Foreground (Used for status bars)
    base05 = "#a6a28c", -- Default Foreground, Caret, Delimiters, Operators
    base06 = "#e8e4cf", -- Light Foreground (Not often used)
    base07 = "#fefbec", -- Light Background (Not often used)
    base08 = "#d73737", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "#b65611", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "#ae9513", -- Classes, Markup Bold, Search Text Background
    base0B = "#60ac39", -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "#1fad83", -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "#6684e1", -- Functions, Methods, Attribute IDs, Headings
    base0E = "#b854d4", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "#d43552", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  catppuccin = {
    base00 = "#1E1E28", -- Default Background
    base01 = "#1A1826", -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = "#302D41", -- Selection Background
    base03 = "#575268", -- Comments, Invisible, Line Highlighting
    base04 = "#6E6C7C", -- Dark Foreground (Used for status bars)
    base05 = "#D7DAE0", -- Default Foreground, Caret, Delimiters, Operators
    base06 = "#F5E0DC", -- Light Foreground (Not often used)
    base07 = "#C9CBFF", -- Light Background (Not often used)
    base08 = "#F28FAD", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "#F8BD96", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "#FAE3B0", -- Classes, Markup Bold, Search Text Background
    base0B = "#ABE9B3", -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "#B5E8E0", -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "#96CDFB", -- Functions, Methods, Attribute IDs, Headings
    base0E = "#DDB6F2", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "#F2CDCD", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  eighties = {
    base00 = "#2d2d2d", -- Default Background
    base01 = "#393939", -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = "#515151", -- Selection Background
    base03 = "#747369", -- Comments, Invisible, Line Highlighting
    base04 = "#a09f93", -- Dark Foreground (Used for status bars)
    base05 = "#d3d0c8", -- Default Foreground, Caret, Delimiters, Operators
    base06 = "#e8e6df", -- Light Foreground (Not often used)
    base07 = "#f2f0ec", -- Light Background (Not often used)
    base08 = "#f2777a", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "#f99157", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "#ffcc66", -- Classes, Markup Bold, Search Text Background
    base0B = "#99cc99", -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "#66cccc", -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "#6699cc", -- Functions, Methods, Attribute IDs, Headings
    base0E = "#cc99cc", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "#d27b53", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  tokyo_city_terminal_dark = {
    base00 = "#171D23", -- Default Background
    base01 = "#1D252C", -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = "#28323A", -- Selection Background
    base03 = "#526270", -- Comments, Invisible, Line Highlighting
    base04 = "#B7C5D3", -- Dark Foreground (Used for status bars)
    base05 = "#D8E2EC", -- Default Foreground, Caret, Delimiters, Operators
    base06 = "#F6F6F8", -- Light Foreground (Not often used)
    base07 = "#FBFBFD", -- Light Background (Not often used)
    base08 = "#D95468", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "#FF9E64", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "#EBBF83", -- Classes, Markup Bold, Search Text Background
    base0B = "#8BD49C", -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "#70E1E8", -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "#539AFC", -- Functions, Methods, Attribute IDs, Headings
    base0E = "#B62D65", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "#DD9D82", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  woodland = {
    base00 = "#231e18", -- Default Background
    base01 = "#302b25", -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = "#48413a", -- Selection Background
    base03 = "#9d8b70", -- Comments, Invisible, Line Highlighting
    base04 = "#b4a490", -- Dark Foreground (Used for status bars)
    base05 = "#cabcb1", -- Default Foreground, Caret, Delimiters, Operators
    base06 = "#d7c8bc", -- Light Foreground (Not often used)
    base07 = "#e4d4c8", -- Light Background (Not often used)
    base08 = "#d35c5c", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = "#ca7f32", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = "#e0ac16", -- Classes, Markup Bold, Search Text Background
    base0B = "#b7ba53", -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = "#6eb958", -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = "#88a4d3", -- Functions, Methods, Attribute IDs, Headings
    base0E = "#bb90e2", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = "#b49368", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  -- :h minischeme
  mini_default = require('mini.base16').mini_palette('#112641', '#e2e98f', 75),
  -- green is from icon, gray is from icon but brightness down
  kawarimidoll = require('mini.base16').mini_palette('#1f1d24', '#8fecd9', 75),
  harukawarimi = require('mini.base16').mini_palette('#1f1d24', '#e68be7', 85),
}

local color_names = {}
local n = 0
for k, _ in pairs(palettes) do
  n = n + 1
  color_names[n] = k
end
table.sort(color_names)

vim.api.nvim_create_user_command(
  'MiniScheme',
  function(opts)
    local palette = palettes[ opts.fargs[1] ]
    if palette then
      vim.g.scheme_name = opts.fargs[1]
    else
      math.randomseed(os.time())
      vim.g.scheme_name = color_names[math.random(#color_names)]
      palette = palettes[vim.g.scheme_name]
    end
    require('mini.base16').setup({
      palette = palette,
      use_cterm = true,
    })
  end,
  {
    nargs = '?',
    complete = function(arg_lead, _, _)
      local out = {}
      for _, c in ipairs(color_names) do
        if vim.startswith(c, arg_lead) then
          table.insert(out, c)
        end
      end
      return out
    end
  }
)
vim.api.nvim_cmd({ cmd = 'MiniScheme' }, {})

-- require('mini.completion').setup({})
-- vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
-- vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
-- _G.cr_action = function()
--   if vim.fn.pumvisible() == 0 then
--     -- If popup is not visible, use `<CR>` in 'mini.pairs'.
--     return require('mini.pairs').cr()
--   elseif vim.fn.complete_info()['selected'] ~= -1 then
--     -- If popup is visible and item is selected, confirm selected item
--     return vim.api.nvim_replace_termcodes('<C-y>', true, true, true)
--   else
--     -- Add new line otherwise
--     return vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true)
--   end
-- end
-- vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })
