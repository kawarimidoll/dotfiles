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
  vim.cmd.cd(old_dir)
end, { desc = 'npm install' })

vim.api.nvim_create_user_command('Confetti', function()
  vim.system({ 'open', '-g', 'raycast://confetti' })
end, { desc = 'Confetti' })
vim.keymap.set('n', '<space>0', '<cmd>Confetti<cr>', { desc = 'Confetti' })

vim.api.nvim_create_user_command('BufDiff', function(arg)
  vim.cmd.diffsplit({ mods = { vertical = true }, args = (arg.nargs == 1 and arg.args or { '#' }) })
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
  vim.cmd.saveas({ bang = arg.bang, args = arg.fargs })
  vim.schedule(function()
    vim.cmd.edit({ bang = true })
  end)
end, { nargs = 1, bang = true, complete = 'file', desc = 'Wrapped saveas' })

local function get_range_str(opts)
  if opts.range ~= 2 then
    return ''
  end
  if opts.line1 == opts.line2 then
    return '#L' .. opts.line1
  end
  return '#L' .. opts.line1 .. '-L' .. opts.line2
end
local function copy_path(opts, target)
  local expr = '%'
  if target == 'full path' then
    expr = '%:p'
  elseif target == 'dir name' then
    expr = '%:p:h'
  elseif target == 'file name' then
    expr = '%:t'
  end

  local path = target == 'relative path' and vim.fs.relpath(vim.fn.getcwd(), vim.fn.expand('%:p'))
    or vim.fn.expand(expr)
  path = path .. get_range_str(opts)

  vim.fn.setreg('*', path)
  vim.notify('Copied ' .. target .. ': ' .. path)
end

vim.api.nvim_create_user_command('CopyFullPath', function(opts)
  copy_path(opts, 'full path')
end, { range = true, desc = 'Copy the full path of the current file to the clipboard' })

vim.api.nvim_create_user_command('CopyRelativePath', function(opts)
  copy_path(opts, 'relative path')
end, { range = true, desc = 'Copy the relative path of the current file to the clipboard' })

vim.api.nvim_create_user_command('CopyDirName', function(opts)
  copy_path(opts, 'dir name')
end, { range = true, desc = 'Copy the directory name of the current file to the clipboard' })

vim.api.nvim_create_user_command('CopyFileName', function(opts)
  copy_path(opts, 'file name')
end, { range = true, desc = 'Copy the file name of the current file to the clipboard' })

vim.api.nvim_create_user_command('SearchToQf', function(opts)
  vim.cmd({ cmd = opts.bang and 'vimgrepadd' or 'vimgrep', args = { '//gj %' } })
  vim.cmd.cwindow()
end, { bang = true })

-- https://zenn.dev/vim_jp/articles/d4f89682bebd9f から、ウィンドウを分割するように変更
local memo_path = vim.fn.expand('~/.local/share/memo.md')
local memoaugroup = vim.api.nvim_create_augroup('MemoAutosave', { clear = true })
local function memo()
  -- メモをすでに開いているか確認
  local memo_bufnr = nil
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(bufnr) == memo_path then
      memo_bufnr = bufnr
      break
    end
  end

  -- 現在のバッファがメモのバッファであれば、保存して閉じる
  local current_buf = vim.api.nvim_get_current_buf()
  if current_buf == memo_bufnr then
    vim.cmd.update({ mods = { silent = true } })
    vim.cmd.bdelete()
    return
  end

  -- メモがすでに開いているが、カーソルが別ウィンドウにある場合は、メモのウィンドウへ移動
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == memo_bufnr then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  -- メモはbufhiddenを'wipe'に設定しているので、隠れバッファになることはないはず
  -- したがってここまで来た場合は、メモのバッファが存在しないことになる

  -- メモのバッファを新規作成
  vim.cmd.split({ args = { vim.fn.fnameescape(memo_path) } })
  vim.api.nvim_win_set_height(0, 12)
  vim.opt_local.bufhidden = 'wipe'
  vim.opt_local.swapfile = false
  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufLeave', 'BufWinLeave' }, {
    buffer = 0,
    callback = function()
      vim.cmd.update({ mods = { silent = true } })
    end,
    group = memoaugroup,
  })
end
vim.api.nvim_create_user_command('Memo', memo, { desc = 'Toggle memo' })
vim.keymap.set('n', 'mo', '<Cmd>Memo<CR>', { noremap = true, silent = true, desc = 'Toggle memo' })

vim.api.nvim_create_user_command('Tsgo', function()
  -- 現在のバッファのファイルパスを取得
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == '' then
    vim.notify('[tsgo] No file in current buffer', vim.log.levels.ERROR)
    return
  end

  -- vim.fs.rootを使って現在のファイルから上位のpackage.jsonを探す
  local package_dir = vim.fs.root(current_file, { 'package.json' })
  if not package_dir then
    vim.notify('[tsgo] No package.json found in parent directories', vim.log.levels.ERROR)
    return
  end

  local cwd = vim.fn.getcwd()
  local relative_path = (vim.fs.relpath(cwd, package_dir) or package_dir) .. '/'

  local function on_exit(obj)
    if obj.stderr ~= '' then
      vim.notify('[tsgo] Error: ' .. obj.stderr, vim.log.levels.ERROR)
      return
    end

    local list = vim.split(obj.stdout, '\n')
    list = vim.tbl_filter(function(v)
      return v:match('^.+%(%d+,%d+%): .+$') ~= nil
    end, list)
    if #list > 0 then
      vim.notify('[tsgo] type-error found', vim.log.levels.WARN)
    else
      vim.notify('[tsgo] type-check passed!', vim.log.levels.INFO)
    end

    -- E5560対策
    local setqflist = function()
      -- 実行がカレントディレクトリでない場合、相対パスを解決
      if relative_path ~= './' then
        list = vim.tbl_map(function(line)
          -- tsgoの出力形式: "path/to/file.ext(line,column): message" にマッチするか確認
          if line:match('^.+%(.-%):.*$') then
            return relative_path .. line
          end
          return line
        end, list)
      end

      -- set quickfix list
      vim.fn.setqflist({}, 'r', { title = 'tsgo', lines = list, efm = [[%f(%l\,%c): %m]] })
      vim.cmd.cwindow()
    end
    vim.defer_fn(setqflist, 100)
  end

  vim.notify('[tsgo] type-check is running in ' .. relative_path, vim.log.levels.INFO)
  -- package.jsonがあるディレクトリでtsgoを実行
  vim.system(
    { 'tsgo', '--noEmit', '--pretty', 'false' },
    { text = true, cwd = package_dir },
    on_exit
  )
end, { desc = 'Tsgo' })

-- respect: https://blog.atusy.net/2025/12/02/nvim-restart/
vim.api.nvim_create_user_command('Restart', function()
  -- cleanup non-normal buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buftype ~= '' then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
  end

  local has_session = vim.v.this_session ~= nil and vim.v.this_session ~= ''
  local session = has_session and vim.v.this_session
    or vim.fs.joinpath(tostring(vim.fn.stdpath('state')), 'restart_session.vim')

  vim.fn.mkdir(vim.fs.dirname(session), 'p')
  vim.cmd.mksession({ args = { session }, bang = true })
  if not has_session then
    local session_x = string.gsub(session, '%.vim$', 'x.vim')
    vim.fn.writefile({ 'let v:this_session = ""' }, session_x)
  end
  vim.cmd.restart({ args = { 'source', session } })
end, { desc = 'Restart current Neovim session' })
