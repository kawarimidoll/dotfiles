vim.api.nvim_create_user_command(
  'InitLua',
  function()
    vim.cmd.edit(vim.fn.stdpath('config') .. '/init.lua')
  end,
  { desc = 'Open init.lua' }
)

vim.api.nvim_create_user_command(
  'Ni',
  function()
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
  end,
  { desc = 'npm install' }
)
