-- https://zenn.dev/vim_jp/articles/29d021fff07e60
local augroup_wrapper = vim.api.nvim_create_augroup('prefix-q-wrapper', {})

-- qをprefixに使う
vim.api.nvim_create_autocmd('RecordingEnter', {
  pattern = '*',
  group = augroup_wrapper,
  callback = function()
    -- q以外のマクロは使わないので即終了
    if vim.fn.reg_recording() ~= 'q' then
      vim.cmd.normal({ args = { 'q' }, bang = true })
      return
    end

    local augroup_inner = vim.api.nvim_create_augroup('prefix-q-inner', {})

    local buffer = vim.api.nvim_get_current_buf()
    -- vim.keymap.set('n', 'q', 'q', { nowait = true, buffer = buffer })
    -- HACK: mini.clueがbuffer mappingを上書きしてくるのでautocmd CursorMovedで設定する
    vim.api.nvim_create_autocmd('CursorMoved', {
      pattern = '*',
      once = true,
      group = augroup_inner,
      callback = function()
        vim.keymap.set('n', 'q', 'q', { nowait = true, buffer = buffer })
      end,
      desc = 'set stop-recording key',
    })
    vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
      pattern = '*',
      once = true,
      group = augroup_inner,
      callback = function()
        vim.cmd.normal({ args = { 'q' }, bang = true })
        vim.notify('stop recording', vim.log.levels.INFO)
      end,
      desc = 'stop recording when leaving buffer',
    })
    vim.api.nvim_create_autocmd('RecordingLeave', {
      pattern = '*',
      once = true,
      callback = function()
        vim.keymap.del('n', 'q', { buffer = buffer })
        vim.api.nvim_del_augroup_by_id(augroup_inner)
      end,
      desc = 'delete q mapping when recording leave',
    })
  end,
})

vim.keymap.set('n', 'qq', 'qq', { desc = 'start rec' })
vim.keymap.set('n', 'qo', '<cmd>only<cr>', { desc = 'only' })
vim.keymap.set('n', 'qO', '<cmd>BufOnly<cr>', { desc = 'BufOnly' })
vim.keymap.set('n', 'qt', '<c-^>', { desc = 'toggle buffer' })
vim.keymap.set('n', 'qg', ':<c-u>global/^/normal ', { desc = 'global command' })
vim.keymap.set('n', 'qd', ':<c-u>g//d<left><left>', { desc = 'delete using regex' })
