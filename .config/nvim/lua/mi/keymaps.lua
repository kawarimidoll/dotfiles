local U = require('mi.utils')

-- use undo-glow.nvim instead of this
-- vim.keymap.set('n', 'p', 'p`]', { desc = 'Paste and move the end' })
-- vim.keymap.set('n', 'P', 'P`]', { desc = 'Paste and move the end' })

function is_url(str)
  return vim.regex([[^https\?:\/\/]]):match_str(str) ~= nil
end
vim.keymap.set({ 'n', 'x' }, 'gf', function()
  local selection = vim.fn.join(U.get_current_selection(), '')
  if U.blank(selection) then
    selection = vim.fn.expand('<cfile>')
  end
  if is_url(selection) then
    vim.cmd.normal('gx')
    return
  end

  if pcall(vim.cmd.normal, { args = { 'gF' }, bang = true }) then
    return
  end

  local isfname_save = vim.o.isfname
  vim.opt.isfname:remove('#')

  local ok, err = pcall(vim.cmd.normal, { args = { 'gF' }, bang = true })
  vim.o.isfname = isfname_save

  if not ok then
    vim.api.nvim_echo({ { tostring(err) } }, true, { err = true })
  end
end, { desc = 'Open file under cursor including line number' })

-- intentionally swap p and P
vim.keymap.set('x', 'p', 'PmpmP', { desc = 'Paste with mark p' })
vim.keymap.set('x', 'P', 'pmpmP', { desc = 'Paste with mark p' })

vim.keymap.set({ 'n', 'x' }, 'x', '"_d', { desc = 'Delete into blackhole' })
vim.keymap.set('n', 'X', '"_D', { desc = 'Delete into blackhole' })
vim.keymap.set('o', 'x', 'd', { desc = 'Delete using x' })

-- https://blog.atusy.net/2025/08/08/map-minus-to-blackhole-register/
vim.keymap.set({ 'n', 'x' }, '-', '"_', { desc = 'Blackhole register' })

-- vim.keymap.set('c', '<c-b>', '<left>', { desc = 'Emacs like left' })
-- vim.keymap.set('c', '<c-f>', '<right>', { desc = 'Emacs like right' })
-- vim.keymap.set('c', '<c-a>', '<home>', { desc = 'Emacs like home' })
-- vim.keymap.set('c', '<c-e>', '<end>', { desc = 'Emacs like end' })
-- vim.keymap.set('c', '<c-h>', '<bs>', { desc = 'Emacs like bs' })
-- vim.keymap.set('c', '<c-d>', '<del>', { desc = 'Emacs like del' })

vim.keymap.set('n', '<space>;', '@:', { desc = 're-run command' })
vim.keymap.set('n', 's/', ':%s/', { desc = 'substitute whole file' })
vim.keymap.set(
  'n',
  'S',
  [[:<c-u>%s/\V\<<c-r><c-w>\>//g<left><left>]],
  { desc = 'substitute current word' }
)
vim.keymap.set('x', 'S', function()
  local lines = U.get_current_selection()
  if #lines ~= 1 then
    vim.notify('select only one line', vim.log.levels.WARN)
    return
  end
  local text = (lines[1] or ''):gsub([[\]], [[\\]])
  return [[:<c-u>%s/]] .. text .. [[//g<left><left>]]
end, { desc = 'substitute current selection', expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'H', '^', { desc = 'left edge of line' })
vim.keymap.set({ 'n', 'x', 'o' }, 'L', '$', { desc = 'right edge of line' })

vim.keymap.set('n', '<space>2', '<cmd>copy.<cr>', { desc = 'duplicate line to below' })
vim.keymap.set('n', '<space>3', '<cmd>copy-1<cr>', { desc = 'duplicate line to above' })
vim.keymap.set('x', '<space>2', [[:copy'<-1<cr>gv]], { desc = 'duplicate line to below' })
vim.keymap.set('x', '<space>3', [[:copy'>+0<cr>gv]], { desc = 'duplicate line to above' })

vim.keymap.set('x', '<', '<gv', { desc = 'Change indent with keeping selection' })
vim.keymap.set('x', '>', '>gv', { desc = 'Change indent with keeping selection' })

-- " ref: https://github.com/kana/vim-niceblock
-- " ref: https://sgur.tumblr.com/post/64100696722/ビジュアル選択後のrによる置換のアレを改善する
local function get_niceblock(map_v, map_V, fallback)
  return ({ v = map_v, V = map_V })[vim.fn.mode()] or fallback
end
vim.keymap.set('x', 'I', function()
  return get_niceblock('<C-v>I', '<C-v>^o^I', 'I')
end, { expr = true, desc = 'Visual block insert at selection start' })
vim.keymap.set('x', 'A', function()
  return get_niceblock('<C-v>A', '<C-v>0o$A', 'A')
end, { expr = true, desc = 'Visual block append at selection end' })
vim.keymap.set('x', 'gI', function()
  return get_niceblock('<C-v>0I', '<C-v>0o$I', '0I')
end, { expr = true, desc = 'Visual block insert at line start' })
vim.keymap.set('x', 'r', function()
  return get_niceblock('<C-v>r', '<C-v>0o$r', 'r')
end, { expr = true, desc = 'Visual block replace at selection' })

vim.keymap.set('n', '<space>w', '<cmd>write<cr>', { desc = 'Write' })

vim.keymap.set({ 'n', 'x' }, 'so', ':source<cr>', { silent = true, desc = 'Source current script' })

vim.keymap.set('c', '<c-n>', function()
  return vim.bool_fn.wildmenumode() and '<c-n>' or '<down>'
end, { expr = true, desc = 'Select next' })
vim.keymap.set('c', '<c-p>', function()
  return vim.bool_fn.wildmenumode() and '<c-p>' or '<up>'
end, { expr = true, desc = 'Select previous' })

vim.keymap.set('n', '<space>q', function()
  if not pcall(vim.cmd.tabclose) then
    vim.cmd.quit()
  end
end, { desc = 'Quit current tab or window' })

vim.keymap.set('n', 'q:', '<nop>', { desc = 'Disable cmdwin' })

-- " https://zenn.dev/kawarimidoll/articles/17dad86545cbb4
vim.keymap.set('n', '<c-f>', function()
  vim.opt.scroll = 0
  return string.rep('<c-d>', vim.v.count1 * 2)
end, { desc = 'better paging', expr = true })
vim.keymap.set('n', '<c-b>', function()
  vim.opt.scroll = 0
  return string.rep('<c-u>', vim.v.count1 * 2)
end, { desc = 'better paging', expr = true })

-- ref: https://zenn.dev/vim_jp/articles/custom-winline-with-args
-- default scroll step is 3
local scroll_step = 3
vim.keymap.set('n', '<ScrollWheelUp>', function()
  if vim.fn.line('w0') > 1 then
    vim.opt.scroll = scroll_step
    return '<c-u>'
  end
  return string.format('%dk', scroll_step)
end, { expr = true, silent = true })
vim.keymap.set('n', '<ScrollWheelDown>', function()
  local visible_last = vim.fn.line('w$')
  local buffer_last = vim.fn.line('$')
  if visible_last < buffer_last then
    vim.opt.scroll = scroll_step
    return '<c-d>'
  end
  return string.format('%dj', scroll_step)
end, { expr = true, silent = true })

vim.keymap.set('n', 'i', function()
  return vim.api.nvim_get_current_line() == '' and '"_cc' or 'i'
end, { expr = true, desc = 'i keeping indent' })
vim.keymap.set('n', 'A', function()
  return vim.api.nvim_get_current_line() == '' and '"_cc' or 'A'
end, { expr = true, desc = 'A keeping indent' })
vim.keymap.set('x', 'y', 'mzy`z', { desc = 'yank without moving cursor' })

vim.keymap.set({ 'n' }, 'mm', 'mm', { desc = 'set mark m' })
vim.keymap.set({ 'n', 'x' }, 'm,', '`m', { desc = 'jump to mark m' })

-- https://github.com/kuuote/dotvim/blob/cce964b162abfe0e74c4932d74697c4b01caf146/conf/rc/mode/ic/map.vim#L175-L178
vim.keymap.set({ 'i', 'c' }, ';', 'toupper(getcharstr()[0])', { expr = true })
vim.keymap.set({ 'i', 'c' }, ';<space>', ';', { desc = 'semicolon-space to semicolon' })
vim.keymap.set({ 'i' }, ';<cr>', ';<cr>', { desc = 'semicolon-cr to semicolon' })
vim.keymap.set({ 'i', 'c' }, ';;', ':', { desc = 'double semicolon to colon' })
vim.keymap.set({ 'i', 'c' }, ';<tab>', '::', { desc = 'semicolon-tab to double colon' })
-- vim.keymap.set({ 'i', 'c' }, ';<tab><tab>', '::', { desc = 'semicolon-tabtab to double colon' })

-- -- https://github.com/kuuote/dotvim/blob/cce964b162abfe0e74c4932d74697c4b01caf146/conf/rc/mode/ic/map.vim#L185-L189
-- vim.keymap.set({ 'i' }, '<s-cr>', function()
--   vim.fn.search([[\("\|''\|;\|>\|)\|]\|`\|}\)\zs]], 'cWz')
-- end, { desc = 's-cr to exit brackets' })

vim.keymap.set('i', '<s-cr>', function()
  if vim.fn.getline('.'):len() ~= vim.fn.col('.') then
    vim.fn.search('\\k\\+\\|[({\\[\\]})=]', 'cWe')
  end
  vim.api.nvim_feedkeys(vim.keycode('<right>'), 'n', true)
end, { noremap = true, silent = true })

-- https://zenn.dev/vim_jp/articles/20230814_ekiden_fullpath
vim.keymap.set({ 'i', 'c' }, '<m-p>', function()
  local mode = vim.fn.mode()
  local pos = mode == 'c' and vim.fn.getcmdpos() or vim.fn.col('.')
  local line = mode == 'c' and vim.fn.getcmdline() or vim.fn.getline('.')
  local left = line:sub(pos - 1, pos - 1)
  if left == '/' then
    return vim.fn.expand('%:p:t')
  else
    return vim.fn.expand('%:p:h') .. '/'
  end
end, { expr = true, desc = 'insert full path' })

-- like helix
vim.keymap.set('n', 'U', '<c-r>', { desc = 'helix-like redo' })
vim.keymap.set({ 'n', 'x' }, 'gh', '0', { desc = 'helix-like 0' })
vim.keymap.set({ 'n', 'x' }, 'gs', '^', { desc = 'helix-like ^' })
vim.keymap.set({ 'n', 'x' }, 'gl', '$', { desc = 'helix-like $' })

vim.keymap.set({ 'n', 'x' }, 'so', ':source<cr>', { silent = true, desc = 'source script' })

-- https://zenn.dev/vim_jp/articles/2024-10-07-vim-insert-uppercase
vim.keymap.set('i', '<c-g><c-u>', function()
  local col = vim.fn.getpos('.')[3]
  local substring = vim.fn.getline('.'):sub(1, col - 1)
  local result = vim.fn.matchstr(substring, [[\v<(\k(<)@!)*$]])
  return '<c-w>' .. result:upper()
end, { expr = true, desc = 'Capitalize word before cursor' })

vim.keymap.set('c', '<c-n>', function()
  return vim.bool_fn.wildmenumode() and '<c-n>' or '<down>'
end, { expr = true, desc = 'Select next' })
vim.keymap.set('c', '<c-p>', function()
  return vim.bool_fn.wildmenumode() and '<c-p>' or '<up>'
end, { expr = true, desc = 'Select previous' })
vim.keymap.set('c', '<c-b>', '<left>', { desc = 'Emacs like Left' })
vim.keymap.set('c', '<c-f>', '<right>', { desc = 'Emacs like Right' })
vim.keymap.set('c', '<c-a>', '<home>', { desc = 'Emacs like Home' })
vim.keymap.set('c', '<c-e>', '<end>', { desc = 'Emacs like End' })
vim.keymap.set({ 'i', 'c' }, '<c-h>', '<bs>', { desc = 'Emacs like Bs', remap = true })
vim.keymap.set('c', '<c-d>', '<del>', { desc = 'Emacs like Del' })

vim.keymap.set('c', '/', function()
  if vim.fn.getcmdtype() ~= ':' then
    return '/'
  end
  if vim.bool_fn.wildmenumode() and vim.fn.getcmdcomplpat():match('/$') then
    return '<down>'
  end
  -- local cmdline = vim.fn.getcmdline()
  -- local pos = vim.fn.getcmdpos()
  -- local left = cmdline:sub(1, pos)
  -- if left:match('/$') then
  --   vim.api.nvim_feedkeys(vim.keycode('<tab>'), 'ni', true)
  --   return ''
  --   -- return vim.keycode('<tab>')
  -- end
  -- fallback
  return '/'
end, { desc = 'Continue path completion by slash', expr = true })

-- c-k to delete until end of cmdline
vim.keymap.set('c', '<c-k>', function()
  local cmdline = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  vim.fn.setcmdline(cmdline:sub(1, pos - 1))
end, { desc = 'Delete until end of cmdline' })

vim.keymap.set('n', '?', '<cmd>silent vimgrep//gj%|copen<cr>', { desc = 'populate latest search' })

vim.keymap.set('n', '<space>n', '//e<cr>n', { desc = 'Move cursor to tail of searched range' })

-- word search with keep positions
-- https://twitter.com/Bakudankun/status/1207057884581900289
-- `doautocmd CursorMoved` is required to trigger features like search count
vim.keymap.set('n', '*', function()
  local winview = vim.fn.winsaveview()
  vim.cmd({
    cmd = 'normal',
    args = { '*' },
    bang = true,
    mods = { silent = true, keepjumps = true },
  })
  vim.fn.winrestview(winview)
  vim.cmd.doautocmd('CursorMoved')
end, { silent = true, desc = 'star-search without jump' })
