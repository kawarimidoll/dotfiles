local mapping = require("jam").mapping
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
  return vim.api.nvim_open_win(buf, false, opts)
end

local jam_in = function()
  vim.b.minicompletion_disable = true
  local win = open_hint_win()
  if win > 0 then
    vim.b.jam_cheat_sheet = win
  end
  mapping.start()
end
local jam_out = function()
  vim.b.minicompletion_disable = false
  if vim.b.jam_cheat_sheet > 0 then
    vim.api.nvim_win_close(vim.b.jam_cheat_sheet, true)
    vim.b.jam_cheat_sheet = nil
  end
  mapping.exit()
end

require("jam").setup({
  mappings = {
    ["<Space>"] = {
      Input = mapping.complete,
      Complete = mapping.insert_next_item,
      Convert = mapping.complete,
    },
    ["<C-6>"] = mapping(mapping.convert_hira, { "Input", "Complete", "Convert" }),
    ["<C-7>"] = mapping(mapping.convert_zen_kata, { "Input", "Complete", "Convert" }),
    ["<C-8>"] = mapping(mapping.convert_han_kata, { "Input", "Complete", "Convert" }),
    ["<C-9>"] = mapping(mapping.convert_zen_eisuu, { "Input", "Complete", "Convert" }),
    ["<C-0>"] = mapping(mapping.convert_han_eisuu, { "Input", "Complete", "Convert" }),
    ["<CR>"] = mapping(mapping.confirm, { "Input", "Complete", "Convert" }),
    ["<C-m>"] = mapping(mapping.confirm, { "Input", "Complete", "Convert" }),
    ["<C-CR>"] = mapping(mapping.confirm, { "Input", "Complete", "Convert" }),
    ["<BS>"] = {
      Input = mapping.backspace,
      Complete = mapping.cancel,
      Convert = mapping.cancel,
    },
    ["<C-h>"] = {
      Input = mapping.backspace,
      Complete = mapping.cancel,
      Convert = mapping.cancel,
    },
    ["<Esc>"] = {
      PreInput = jam_out,
      Input = jam_out,
      Complete = mapping.cancel,
      Convert = mapping.cancel,
    },
    ["<C-n>"] = {
      Input = mapping.complete,
      Complete = mapping.insert_next_item,
    },
    ["<Tab>"] = {
      Input = mapping.complete,
      Complete = mapping.insert_next_item,
    },
    ["<C-p>"] = mapping(mapping.insert_prev_item, "Complete"),
    ["<S-Tab>"] = mapping(mapping.insert_prev_item, "Complete"),
    ["<C-b>"] = mapping(mapping.goto_prev, { "Input", "Complete", "Convert" }),
    ["<Left>"] = mapping(mapping.goto_prev, { "Input", "Complete", "Convert" }),
    ["<C-f>"] = mapping(mapping.goto_next, { "Input", "Complete", "Convert" }),
    ["<Right>"] = mapping(mapping.goto_next, { "Input", "Complete", "Convert" }),
    ["<C-a>"] = mapping(mapping.goto_head, { "Input", "Complete", "Convert" }),
    ["<C-Left>"] = mapping(mapping.goto_head, { "Input", "Complete", "Convert" }),
    ["<Home>"] = mapping(mapping.goto_head, { "Input", "Complete", "Convert" }),
    ["<C-e>"] = mapping(mapping.goto_tail, { "Input", "Complete", "Convert" }),
    ["<C-Right>"] = mapping(mapping.goto_tail, { "Input", "Complete", "Convert" }),
    ["<End>"] = mapping(mapping.goto_tail, { "Input", "Complete", "Convert" }),
    ["<C-j>"] = mapping(mapping.shorten, "Complete"),
    ["<S-Left>"] = mapping(mapping.shorten, "Complete"),
    ["<C-k>"] = mapping(mapping.extend, "Complete"),
    ["<S-Right>"] = mapping(mapping.extend, "Complete"),
    ["<S-Space>"] = mapping(mapping.zenkaku_space, "PreInput"),
  },
})

vim.keymap.set('i', '<C-q>', jam_in, {})
