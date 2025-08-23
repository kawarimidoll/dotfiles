-- ref: https://github.com/liangxianzhe/floating-input.nvim/blob/8480827466a51d7baac56ddec4ccfb355fcef43a/lua/floating-input.lua
-- ref: https://ryota2357.com/blog/2023/neovim-custom-vim-ui-input/

local M = {}

M.ui_input = function(opts, on_confirm)
  local prompt = opts.prompt or 'Input: '
  prompt = vim.trim(prompt):gsub(':', ''):gsub('%s+', ' ')
  local default = opts.default or ''

  -- Calculate a minimal width with a bit margin
  local default_width = vim.str_utfindex(default, 'utf-8')
  local prompt_width = vim.str_utfindex(prompt, 'utf-8')
  local input_width = math.max(default_width, prompt_width) + 20

  local win_config = {
    focusable = true,
    style = 'minimal',
    border = 'rounded',
    width = input_width,
    height = 1,
    relative = 'win',
    row = vim.api.nvim_win_get_height(0) / 2 - 1,
    col = vim.api.nvim_win_get_width(0) / 2 - input_width / 2,
  }

  -- Place the window near cursor when rename
  if prompt:lower() == 'new name' then
    win_config.relative = 'cursor'
    win_config.row = 1
    win_config.col = 0
  end

  win_config.title = ' ' .. prompt .. ' '

  -- Create floating window
  local buffer = vim.api.nvim_create_buf(false, true)
  local window = vim.api.nvim_open_win(buffer, true, win_config)
  vim.api.nvim_buf_set_text(buffer, 0, 0, 0, 0, { default })

  -- Start insert from the end of the line
  vim.cmd('startinsert!')

  -- Function to close the window
  local close_win = function()
    vim.api.nvim_win_close(window, true)
    vim.cmd.stopinsert()
  end

  -- CR to confirm
  vim.keymap.set('i', '<cr>', function()
    local line = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1]
    close_win()
    if line ~= default and on_confirm then
      vim.print('line: ' .. line)
      on_confirm(line)
    end
  end, { buffer = buffer })

  -- Esc to close
  vim.keymap.set('i', '<esc>', close_win, { buffer = buffer })
end

return M
