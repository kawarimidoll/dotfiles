local U = require('mi.utils')

vim.keymap.set('n', 'p', 'p`]', { desc = 'Paste and move the end' })
vim.keymap.set('n', 'P', 'P`]', { desc = 'Paste and move the end' })

vim.keymap.set('x', 'p', 'P', { desc = 'Paste without change register' })
vim.keymap.set('x', 'P', 'p', { desc = 'Paste with change register' })

vim.keymap.set({ 'n', 'x' }, 'x', '"_d', { desc = 'Delete into blackhole' })
vim.keymap.set('n', 'X', '"_D', { desc = 'Delete into blackhole' })
vim.keymap.set('o', 'x', 'd', { desc = 'Delete using x' })

vim.keymap.set('c', '<c-b>', '<left>', { desc = 'Emacs like left' })
vim.keymap.set('c', '<c-f>', '<right>', { desc = 'Emacs like right' })
vim.keymap.set('c', '<c-a>', '<home>', { desc = 'Emacs like home' })
vim.keymap.set('c', '<c-e>', '<end>', { desc = 'Emacs like end' })
vim.keymap.set('c', '<c-h>', '<bs>', { desc = 'Emacs like bs' })
vim.keymap.set('c', '<c-d>', '<del>', { desc = 'Emacs like del' })

vim.keymap.set('n', '<space>;', '@:', { desc = 're-run command' })
vim.keymap.set('n', 's/', ':%s/', { desc = 'substitute whole file' })
vim.keymap.set(
  'n',
  'S',
  [[:<c-u>%s/\V\<<c-r><c-w>\>//g<left><left>]],
  { desc = 'substitute current word' }
)
vim.keymap.set('x', 'S', function()
  local lines = U.get_current_selected_lines()
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
