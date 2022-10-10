local mapping = require('jam').mapping

local open_hint_win = function()
  local buf = vim.api.nvim_create_buf(false, true)
  if buf < 1 then
    return 0
  end

  local hints = {
    '<Space> = { complete / insert_next }',
    '<C-6> = convert_hira',
    '<C-7> = convert_zen_kata',
    '<C-8> = convert_han_kata',
    '<C-9> = convert_zen_eisuu',
    '<C-0> = convert_han_eisuu',
    '<CR> <C-m> = confirm',
    '<BS> <C-h> = { backspace / cancel }',
    '<C-q> <Esc> = { exit / cancel }',
    '<C-n> <Tab> = { complete / insert_next }',
    '<C-p> <S-Tab> = insert_prev',
    '<C-b> <Left> = goto_prev',
    '<C-f> <Right> = goto_next',
    '<C-a> <C-Left> = goto_head',
    '<C-e> <C-Right> = goto_tail',
    '<C-j> <S-Left> = shorten',
    '<C-k> <S-Right> = extend',
    '<C-CR> = zenkaku_space',
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, hints)

  local max_length = 0
  for i, x in pairs(hints) do
    local marker = string.find(x, '=')
    vim.api.nvim_buf_add_highlight(buf, -1, 'Macro', i - 1, 0, marker - 1)
    if #x > max_length then
      max_length = #x
    end
  end

  local opts = {
    relative = 'editor',
    width = max_length,
    height = #hints,
    col = vim.api.nvim_get_option('columns'),
    row = 3,
    anchor = 'NE',
    style = 'minimal',
    noautocmd = true,
    focusable = false,
    border = 'rounded',
  }
  vim.g.jam_cheat_sheet_win = vim.api.nvim_open_win(buf, false, opts)
end
local close_hint_win = function()
  if vim.g.jam_cheat_sheet_win and vim.g.jam_cheat_sheet_win > 0 then
    vim.api.nvim_win_close(vim.g.jam_cheat_sheet_win, true)
    vim.g.jam_cheat_sheet_win = nil
  end
end

local jam_in = function()
  vim.g.minicompletion_disable = true
  open_hint_win()
  -- vim.api.nvim_create_autocmd({ 'ModeChanged' }, { once = true, callback = close_hint_win })
  mapping.start()
end
local jam_out = function()
  vim.g.minicompletion_disable = false
  close_hint_win()
  mapping.exit()
end

require('jam').setup({
  mappings = {
    ['<C-6>'] = mapping(mapping.convert_hira, { 'Input', 'Complete', 'Convert' }),
    ['<C-7>'] = mapping(mapping.convert_zen_kata, { 'Input', 'Complete', 'Convert' }),
    ['<C-8>'] = mapping(mapping.convert_han_kata, { 'Input', 'Complete', 'Convert' }),
    ['<C-9>'] = mapping(mapping.convert_zen_eisuu, { 'Input', 'Complete', 'Convert' }),
    ['<C-0>'] = mapping(mapping.convert_han_eisuu, { 'Input', 'Complete', 'Convert' }),
    ['<Esc>'] = {
      PreInput = jam_out,
      Input = jam_out,
      Complete = mapping.cancel,
      Convert = mapping.cancel,
    },
    ['<C-q>'] = { PreInput = jam_out, Input = jam_out },
    ['<C-CR>'] = { PreInput = mapping.zenkaku_space },
  },
})

vim.keymap.set('i', '<C-q>', jam_in, {})
