local action = require("jam.action")
require("jam").setup({
  mappings = {
    { "<Space>", action.complete, "Input" },
    { { "<C-CR>", "<C-m>", "<CR>" }, action.confirm, { "Input", "Convert" } },
    {
      { "<C-h>", "<BS>" },
      {
        Input = action.backspace,
        Convert = action.cancel,
      },
    },
    {
      "<Esc>",
      {
        PreInput = action.exit,
        Input = function()
          action.exit()
          vim.api.nvim_command('stopinsert')
        end,
        Convert = action.cancel,
      },
    },
    { { "<C-n>", "<Tab>" }, action.insert_next_item, "Convert" },
    { { "<C-p>", "<S-Tab>" }, action.insert_prev_item, "Convert" },
    { { "<C-f>", "<Right>" }, action.goto_next, "Convert" },
    { { "<C-b>", "<Left>" }, action.goto_prev, "Convert" },
    { { "<C-e>", "<C-Right>", "<End>" }, action.goto_tail, "Convert" },
    { { "<C-a>", "<C-Left>", "<Home>" }, action.goto_head, "Convert" },
    { { "<C-k>", "<S-Right>" }, action.extend, "Convert" },
    { { "<C-j>", "<S-Left>" }, action.shorten, "Convert" },
  },
})
