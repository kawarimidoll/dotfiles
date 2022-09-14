local mapping = require("jam").mapping
local jam_in = function()
  vim.b.minicompletion_disable = true
  mapping.start()
end
local jam_out = function()
  vim.b.minicompletion_disable = false
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
