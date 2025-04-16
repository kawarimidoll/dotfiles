vim.api.nvim_create_user_command(
  'InitLua',
  function()
    vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua')
  end,
  { desc = 'Open init.lua' }
)
