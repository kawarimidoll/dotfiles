vim.api.nvim_create_user_command('InitLua', function()
  vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua')
end, { desc = 'Open init.lua' })

vim.api.nvim_create_user_command('Ni', function()
  local fname = vim.fn.expand('%:t')
  if fname ~= 'package.json' then
    vim.print('[Ni] Not in a package.json file')
    return
  end
  local old_dir = vim.fn.getcwd()
  -- directory of the current file (resolve symlinks if it's a symlink)
  local dir = vim.fs.dirname(vim.fn.resolve(vim.fn.expand('%:p')))
  -- cd to the directory
  local cmd = 'cd ' .. dir
  -- check lockfile to determine which command (npm, yarn, pnpm, bun) to run
  -- default to bun
  local tool = 'bun'
  local lockfiles = {
    ['package-lock.json'] = 'npm',
    ['yarn.lock'] = 'yarn',
    ['pnpm-lock.yaml'] = 'pnpm',
  }
  for lockfile, tool_name in pairs(lockfiles) do
    if vim.uv.fs_stat(dir .. '/' .. lockfile) then
      tool = tool_name
      break
    end
  end
  cmd = cmd .. ' && ' .. tool .. ' install'
  vim.print('[Ni] run: ' .. cmd)

  -- run the command
  local result = vim.fn.system(cmd)
  -- check for errors
  if vim.v.shell_error ~= 0 then
    vim.print('[Ni] Error')
  else
    vim.print('[Ni] Success')
  end
  -- print the result
  vim.print(result)

  -- cd back to the old directory
  vim.cmd('cd ' .. old_dir)
end, { desc = 'npm install' })

vim.api.nvim_create_user_command('Confetti', function()
  vim.system({ 'open', '-g', 'raycast://confetti' })
end, { desc = 'Confetti' })
vim.keymap.set('n', '<space>0', '<cmd>Confetti<cr>', { desc = 'Confetti' })

vim.api.nvim_create_user_command('BufDiff', function(arg)
  vim.cmd('vertical diffsplit ' .. (arg.nargs == 1 and arg.args or '#'))
end, { nargs = '?', complete = 'file', desc = 'Show diff with current buffer' })
vim.api.nvim_create_user_command('DiffOff', function()
  vim.cmd.diffoff()
  vim.cmd.only()
end, { desc = 'Switch off diff mode and quit other windows' })

-- :h ansi-colorize
vim.api.nvim_create_user_command('TermHl', function()
  local b = vim.api.nvim_create_buf(false, true)
  local chan = vim.api.nvim_open_term(b, {})
  vim.api.nvim_chan_send(chan, table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'))
  vim.api.nvim_win_set_buf(0, b)
end, { desc = 'Highlights ANSI termcodes in curbuf' })

vim.api.nvim_create_user_command('Rename', function(arg)
  local fname = arg.args
  vim.cmd({ cmd = 'saveas', args = { fname }, bang = arg.bang })
  if not vim.uv.fs_stat(fname) then
    vim.notify('[ABORT] Failed to save as ' .. fname, vim.log.levels.ERROR)
    return
  end
  vim.cmd.bdelete('#')
  vim.fs.rm(vim.fn.expand('#:p'))
end, { nargs = 1, complete = 'file', desc = 'Rename current file', bang = true })

-- https://zenn.dev/glaucus03/articles/a4649f70f2b2e8
vim.api.nvim_create_user_command('BufOnly', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local closed_count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      not vim.api.nvim_get_option_value('modified', { scope = 'local', buf = buf })
      and buf ~= current_buf
      and not pcall(vim.api.nvim_buf_get_var, buf, 'terminal_job_id')
    then
      if pcall(vim.api.nvim_buf_delete, buf, { force = false }) then
        closed_count = closed_count + 1
      end
    end
  end
  vim.notify(closed_count .. ' buffers closed', vim.log.levels.INFO)
end, {})

-- https://koturn.hatenablog.com/entry/2015/08/03/095040
vim.api.nvim_create_user_command('SudoWrite', function(arg)
  local bang = arg.bang and '!' or ''
  local args = vim.fn.trim(arg.args)
  local file = vim.fn.empty(args) and '%' or args
  vim.cmd.execute('write' .. bang .. ' !sudo tee > /dev/null ' .. file)
end, { nargs = '?', complete = 'file', bang = true, desc = 'Save using sudo' })

vim.api.nvim_create_user_command('Saveas', function(arg)
  vim.cmd.saveas(arg.args)
  vim.cmd('edit!')
end, { nargs = 1, complete = 'file', desc = 'Wrapped saveas' })
