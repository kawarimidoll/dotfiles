local reacher = require('reacher')

vim.keymap.set('n', 'gs', reacher.start_multiple, {})

local group = vim.api.nvim_create_augroup('reacher_setting', {})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = group,
  pattern = { 'reacher' },
  callback = function()
    ---@diagnostic disable-next-line: assign-type-mismatch
    require('cmp').setup.buffer({ enabled = false })

    local opts = { buffer = true }

    vim.keymap.set('i', '<CR>', '<ESC>', opts)
    vim.keymap.set('n', '<CR>', reacher.finish, opts)
    vim.keymap.set({ 'n', 'i' }, '<ESC>', reacher.cancel, opts)

    -- next/previous like as default search
    vim.keymap.set('n', 'n', reacher.next, opts)
    vim.keymap.set('n', 'N', reacher.previous, opts)

    -- move by hjkl
    vim.keymap.set('n', 'j', reacher.next, opts)
    vim.keymap.set('n', 'k', reacher.previous, opts)
    vim.keymap.set('n', 'l', reacher.side_next, opts)
    vim.keymap.set('n', 'h', reacher.side_previous, opts)
  end,
})
