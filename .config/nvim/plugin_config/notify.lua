local notify = require("notify")

notify.setup({
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { focusable = false })
  end,
})

vim.notify = notify
