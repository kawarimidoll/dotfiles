require('fidget').setup()

-- https://github.com/j-hui/fidget.nvim/issues/86#issuecomment-1220518701
vim.api.nvim_create_autocmd('VimLeavePre', { command = [[silent! FidgetClose]] })
