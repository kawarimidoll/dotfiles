vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  callback = require('mini.ai').setup,
  once = true,
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  callback = require('mini.bufremove').setup,
  once = true,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = '*',
  callback = function()
    local hooks = {}
    local exists, context_commentstring = pcall(require, 'ts_context_commentstring.internal')
    if exists then
      hooks.pre = function()
        context_commentstring.update_commentstring({})
      end
    end

    require('mini.comment').setup({ hooks = hooks })
  end,
  once = true,
})

vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  pattern = '*',
  callback = require('mini.cursorword').setup,
  once = true,
})

vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
  pattern = '*',
  callback = require('mini.misc').setup,
  once = true,
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  callback = require('mini.indentscope').setup,
  once = true,
})

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  callback = require('mini.surround').setup,
  once = true,
})

vim.opt.laststatus = 3
require('mini.statusline').setup({
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ trunc_width = 75 })
      local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
      local location = MiniStatusline.section_location({ trunc_width = 75 })
      local searchcount = MiniStatusline.section_searchcount({ trunc_width = 75 })
      if searchcount and searchcount ~= '' then
        searchcount = '[' .. searchcount .. ']'
      end

      local jp_mode = ''
      if vim.b.ime_mode and vim.b.ime_mode ~= '' then
        jp_mode = '韛'
      elseif vim.g['skkeleton#mode'] == 'hira' then
        jp_mode = 'あ'
      elseif vim.g['skkeleton#mode'] == 'kata' then
        jp_mode = 'ア'
      elseif vim.g['skkeleton#mode'] == 'hankata' then
        jp_mode = 'ｱ'
      elseif vim.g['skkeleton#mode'] == 'zenkaku' then
        jp_mode = 'Ａ'
      elseif vim.g['skkeleton#mode'] == 'abbrev' then
        jp_mode = 'a'
      end

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode, jp_mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { location, searchcount } },
      })
    end,
  },
  set_vim_settings = false,
})
vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { link = 'String' })

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  callback = function()
    require('mini.trailspace').setup({})
    vim.api.nvim_create_user_command('Trim', MiniTrailspace.trim, {})
  end,
  once = true,
})

require('mini.tabline').setup({})

vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
  pattern = '*',
  callback = require('mini.pairs').setup,
  once = true,
})

-- https://github.com/chriskempson/base16/blob/master/styling.md
local palettes = {
  -- https://github.com/sainnhe/sonokai/blob/master/alacritty/README.md shusia
  shusia = {
    base00 = '#2d2a2e', -- Default Background
    base01 = '#37343a', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#423f46', -- Selection Background
    base03 = '#848089', -- Comments, Invisible, Line Highlighting
    base04 = '#66d9ef', -- Dark Foreground (Used for status bars)
    base05 = '#e3e1e4', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#a1efe4', -- Light Foreground (Not often used)
    base07 = '#f8f8f2', -- Light Background (Not often used)
    base08 = '#f85e84', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#ef9062', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#a6e22e', -- Classes, Markup Bold, Search Text Background
    base0B = '#e5c463', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#66d9ef', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#9ecd6f', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#a1efe4', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#f9f8f5', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  -- https://github.com/KeitaNakamura/neodark.vim/blob/master/colors/neodark.vim
  neodark = {
    base00 = '#1F2F38', -- Default Background
    base01 = '#263A45', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#475C69', -- Selection Background
    base03 = '#658595', -- Comments, Invisible, Line Highlighting
    base04 = '#D4AE58', -- Dark Foreground (Used for status bars)
    base05 = '#AABBC4', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#C99720', -- Light Foreground (Not often used)
    base07 = '#72C7D1', -- Light Background (Not often used)
    base08 = '#4BB1A7', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#DC657D', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#B888E2', -- Classes, Markup Bold, Search Text Background
    base0B = '#E18254', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#E69CA0', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#639EE4', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#84B97C', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#AE8785', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  -- https://base16-project.github.io/base16-gallery/
  -- kanagawa = {
  --   base00 = "#1F1F28", -- Default Background
  --   base01 = "#16161D", -- Lighter Background (Used for status bars, line number and folding marks)
  --   base02 = "#223249", -- Selection Background
  --   base03 = "#54546D", -- Comments, Invisible, Line Highlighting
  --   base04 = "#727169", -- Dark Foreground (Used for status bars)
  --   base05 = "#DCD7BA", -- Default Foreground, Caret, Delimiters, Operators
  --   base06 = "#C8C093", -- Light Foreground (Not often used)
  --   base07 = "#717C7C", -- Light Background (Not often used)
  --   base08 = "#C34043", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  --   base09 = "#FFA066", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  --   base0A = "#C0A36E", -- Classes, Markup Bold, Search Text Background
  --   base0B = "#76946A", -- Strings, Inherited Class, Markup Code, Diff Inserted
  --   base0C = "#6A9589", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  --   base0D = "#7E9CD8", -- Functions, Methods, Attribute IDs, Headings
  --   base0E = "#957FB8", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  --   base0F = "#D27E99", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  -- },
  materia = {
    base00 = '#263238', -- Default Background
    base01 = '#2C393F', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#37474F', -- Selection Background
    base03 = '#707880', -- Comments, Invisible, Line Highlighting
    base04 = '#C9CCD3', -- Dark Foreground (Used for status bars)
    base05 = '#CDD3DE', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#D5DBE5', -- Light Foreground (Not often used)
    base07 = '#FFFFFF', -- Light Background (Not often used)
    base08 = '#EC5F67', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#EA9560', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#FFCC00', -- Classes, Markup Bold, Search Text Background
    base0B = '#8BD649', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#80CBC4', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#89DDFF', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#82AAFF', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#EC5F67', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  everforest = {
    base00 = '#2b3339', -- Default Background
    base01 = '#323c41', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#3a4248', -- Selection Background
    base03 = '#868d80', -- Comments, Invisible, Line Highlighting
    base04 = '#a59572', -- Dark Foreground (Used for status bars)
    base05 = '#d3c6aa', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#e9e8d2', -- Light Foreground (Not often used)
    base07 = '#fff9e8', -- Light Background (Not often used)
    base08 = '#7fbbb3', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#d699b6', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#83c092', -- Classes, Markup Bold, Search Text Background
    base0B = '#dbbc7f', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#e69875', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#a7c080', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#e67e80', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#d699b6', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  -- atlas = {
  --   base00 = "#002635", -- Default Background
  --   base01 = "#00384d", -- Lighter Background (Used for status bars, line number and folding marks)
  --   base02 = "#517F8D", -- Selection Background
  --   base03 = "#6C8B91", -- Comments, Invisible, Line Highlighting
  --   base04 = "#869696", -- Dark Foreground (Used for status bars)
  --   base05 = "#a1a19a", -- Default Foreground, Caret, Delimiters, Operators
  --   base06 = "#e6e6dc", -- Light Foreground (Not often used)
  --   base07 = "#fafaf8", -- Light Background (Not often used)
  --   base08 = "#ff5a67", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  --   base09 = "#f08e48", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  --   base0A = "#ffcc1b", -- Classes, Markup Bold, Search Text Background
  --   base0B = "#7fc06e", -- Strings, Inherited Class, Markup Code, Diff Inserted
  --   base0C = "#5dd7b9", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  --   base0D = "#14747e", -- Functions, Methods, Attribute IDs, Headings
  --   base0E = "#9a70a4", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  --   base0F = "#c43060", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  -- },
  ayu_mirage = {
    base00 = '#171B24', -- Default Background
    base01 = '#1F2430', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#242936', -- Selection Background
    base03 = '#707A8C', -- Comments, Invisible, Line Highlighting
    base04 = '#8A9199', -- Dark Foreground (Used for status bars)
    base05 = '#CCCAC2', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#D9D7CE', -- Light Foreground (Not often used)
    base07 = '#F3F4F5', -- Light Background (Not often used)
    base08 = '#F28779', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#FFAD66', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#FFD173', -- Classes, Markup Bold, Search Text Background
    base0B = '#D5FF80', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#95E6CB', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#5CCFE6', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#D4BFFF', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#F29E74', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  -- darcula = {
  --   base00 = "#2b2b2b", -- Default Background
  --   base01 = "#323232", -- Lighter Background (Used for status bars, line number and folding marks)
  --   base02 = "#323232", -- Selection Background
  --   base03 = "#606366", -- Comments, Invisible, Line Highlighting
  --   base04 = "#a4a3a3", -- Dark Foreground (Used for status bars)
  --   base05 = "#a9b7c6", -- Default Foreground, Caret, Delimiters, Operators
  --   base06 = "#ffc66d", -- Light Foreground (Not often used)
  --   base07 = "#ffffff", -- Light Background (Not often used)
  --   base08 = "#4eade5", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  --   base09 = "#689757", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  --   base0A = "#bbb529", -- Classes, Markup Bold, Search Text Background
  --   base0B = "#6a8759", -- Strings, Inherited Class, Markup Code, Diff Inserted
  --   base0C = "#629755", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  --   base0D = "#9876aa", -- Functions, Methods, Attribute IDs, Headings
  --   base0E = "#cc7832", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  --   base0F = "#808080", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  -- },
  -- atelier_dune = {
  --   base00 = "#20201d", -- Default Background
  --   base01 = "#292824", -- Lighter Background (Used for status bars, line number and folding marks)
  --   base02 = "#6e6b5e", -- Selection Background
  --   base03 = "#7d7a68", -- Comments, Invisible, Line Highlighting
  --   base04 = "#999580", -- Dark Foreground (Used for status bars)
  --   base05 = "#a6a28c", -- Default Foreground, Caret, Delimiters, Operators
  --   base06 = "#e8e4cf", -- Light Foreground (Not often used)
  --   base07 = "#fefbec", -- Light Background (Not often used)
  --   base08 = "#d73737", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  --   base09 = "#b65611", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  --   base0A = "#ae9513", -- Classes, Markup Bold, Search Text Background
  --   base0B = "#60ac39", -- Strings, Inherited Class, Markup Code, Diff Inserted
  --   base0C = "#1fad83", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  --   base0D = "#6684e1", -- Functions, Methods, Attribute IDs, Headings
  --   base0E = "#b854d4", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  --   base0F = "#d43552", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  -- },
  catppuccin = {
    base00 = '#1E1E28', -- Default Background
    base01 = '#1A1826', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#302D41', -- Selection Background
    base03 = '#575268', -- Comments, Invisible, Line Highlighting
    base04 = '#6E6C7C', -- Dark Foreground (Used for status bars)
    base05 = '#D7DAE0', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#F5E0DC', -- Light Foreground (Not often used)
    base07 = '#C9CBFF', -- Light Background (Not often used)
    base08 = '#F28FAD', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#F8BD96', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#FAE3B0', -- Classes, Markup Bold, Search Text Background
    base0B = '#ABE9B3', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#B5E8E0', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#96CDFB', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#DDB6F2', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#F2CDCD', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  eighties = {
    base00 = '#2d2d2d', -- Default Background
    base01 = '#393939', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#515151', -- Selection Background
    base03 = '#747369', -- Comments, Invisible, Line Highlighting
    base04 = '#a09f93', -- Dark Foreground (Used for status bars)
    base05 = '#d3d0c8', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#e8e6df', -- Light Foreground (Not often used)
    base07 = '#f2f0ec', -- Light Background (Not often used)
    base08 = '#f2777a', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#f99157', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#ffcc66', -- Classes, Markup Bold, Search Text Background
    base0B = '#99cc99', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#66cccc', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#6699cc', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#cc99cc', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#d27b53', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  tokyo_city_terminal_dark = {
    base00 = '#171D23', -- Default Background
    base01 = '#1D252C', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#28323A', -- Selection Background
    base03 = '#526270', -- Comments, Invisible, Line Highlighting
    base04 = '#B7C5D3', -- Dark Foreground (Used for status bars)
    base05 = '#D8E2EC', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#F6F6F8', -- Light Foreground (Not often used)
    base07 = '#FBFBFD', -- Light Background (Not often used)
    base08 = '#D95468', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#FF9E64', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#EBBF83', -- Classes, Markup Bold, Search Text Background
    base0B = '#8BD49C', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#70E1E8', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#539AFC', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#B62D65', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#DD9D82', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  woodland = {
    base00 = '#231e18', -- Default Background
    base01 = '#302b25', -- Lighter Background (Used for status bars, line number and folding marks)
    base02 = '#48413a', -- Selection Background
    base03 = '#9d8b70', -- Comments, Invisible, Line Highlighting
    base04 = '#b4a490', -- Dark Foreground (Used for status bars)
    base05 = '#cabcb1', -- Default Foreground, Caret, Delimiters, Operators
    base06 = '#d7c8bc', -- Light Foreground (Not often used)
    base07 = '#e4d4c8', -- Light Background (Not often used)
    base08 = '#d35c5c', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base09 = '#ca7f32', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base0A = '#e0ac16', -- Classes, Markup Bold, Search Text Background
    base0B = '#b7ba53', -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0C = '#6eb958', -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0D = '#88a4d3', -- Functions, Methods, Attribute IDs, Headings
    base0E = '#bb90e2', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0F = '#b49368', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
  },
  -- :h minischeme
  mini_default = require('mini.base16').mini_palette('#112641', '#e2e98f', 75),
  minicyan = require('mini.base16').mini_palette('#0A2A2A', '#D0D0D0', 50),
  -- green is from icon, gray is from icon but brightness down
  kawarimidoll = require('mini.base16').mini_palette('#1f1d24', '#8fecd9', 75),
  harukawarimi = require('mini.base16').mini_palette('#1f1d24', '#e68be7', 65),
}

local scheme_names = vim.tbl_keys(palettes)
vim.api.nvim_create_user_command('MiniScheme', function(opts)
  local key = opts.fargs[1]

  if vim.tbl_contains(scheme_names, key) then
    vim.g.scheme_name = key
  else
    math.randomseed(os.time())
    vim.g.scheme_name = scheme_names[math.random(#scheme_names)]
  end

  require('mini.base16').setup({
    palette = palettes[vim.g.scheme_name],
    use_cterm = true,
  })
  vim.api.nvim_exec_autocmds('ColorScheme', {})
  vim.api.nvim_set_hl(0, 'VertSplit', { ctermbg = 'NONE', bg = 'NONE' })
end, {
  nargs = '?',
  complete = function(arg_lead, _, _)
    return vim.tbl_filter(function(item)
      return vim.startswith(item, arg_lead)
    end, scheme_names)
  end,
})
if not vim.g.scheme_name then
  vim.cmd('MiniScheme')
end

---@param keys string
---@return string
local termcodes = function(keys)
  ---@diagnostic disable-next-line: return-type-mismatch
  return vim.api.nvim_replace_termcodes(keys, true, true, true)
end

vim.g.last_completion = '<C-x><C-o>'

local mini_completion_setup = function()
  require('mini.completion').setup({
    lsp_completion = {
      process_items = require('mini.fuzzy').process_lsp_items,
    },
    fallback_action = function()
      if
        vim.g.last_completion == '<C-x><C-o>'
        and vim.api.nvim_get_option_value('omnifunc', {}) == ''
      then
        vim.g.last_completion = '<C-x><C-k>'
      end
      vim.api.nvim_feedkeys(termcodes(vim.g.last_completion), 'n', false)
    end,
    mappings = {
      force_twostep = '<C-x><C-g>', -- Force two-step completion
      force_fallback = '<C-x><C-x>', -- Force fallback completion
    },
  })

  local keymap_amend = require('keymap-amend')
  local insert_amend = function(keys)
    keymap_amend('i', keys, function(original)
      vim.g.last_completion = keys
      original()
    end)
  end

  insert_amend('<C-x><C-f>')
  insert_amend('<C-x><C-i>')
  insert_amend('<C-x><C-k>')
  insert_amend('<C-x><C-n>')
  insert_amend('<C-x><C-o>')
  insert_amend('<C-x><C-u>')
  insert_amend('<C-x><C-v>')

  -- vim.keymap.set('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
  -- vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
  vim.keymap.set('i', '<CR>', function()
    if vim.fn.pumvisible() == 0 then
      -- If popup is not visible, use `<CR>` in 'mini.pairs'.
      return require('mini.pairs').cr()
    end

    local complete_info = vim.fn.complete_info({ 'selected', 'items' })

    if complete_info.selected == -1 then
      -- If popup is visible but item is NOT selected, add new line.
      return require('mini.pairs').cr()
    end

    -- If popup is visible and item is selected, get selected item.
    local selected = complete_info.items[complete_info.selected + 1]

    -- If menu of selected item starts with '[v]', expand by vsnip.
    if vim.startswith(selected.menu, '[v]') then
      return '<Plug>(vsnip-expand-or-jump)'
    end

    -- Confirm selected item otherwise
    return termcodes('<C-y>')
  end, { expr = true })
end
-- vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
--   pattern = '*',
--   callback = mini_completion_setup,
--   once = true,
-- })
