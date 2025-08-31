-- https://zenn.dev/vim_jp/articles/a6839f7204a611
return {
  root_dir = function(bufnr, callback)
    -- disable for files with specific names
    local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
    local disable_patterns = { 'env', 'conf', 'local', 'private' }
    local is_disabled = vim.iter(disable_patterns):any(function(pattern)
      return string.match(fname, pattern)
    end)
    if is_disabled then
      return
    end

    local root_dir = vim.fs.root(bufnr, { '.git' })
    if root_dir then
      return callback(root_dir)
    end
  end,
  on_init = function()
    -- Highlight for suggestions
    local hlc = vim.api.nvim_get_hl(0, { name = 'Comment' })
    vim.api.nvim_set_hl(0, 'ComplHint', vim.tbl_extend('force', hlc, { underline = true }))
    local hlm = vim.api.nvim_get_hl(0, { name = 'MoreMsg' })
    vim.api.nvim_set_hl(0, 'ComplHintMore', vim.tbl_extend('force', hlm, { underline = true }))

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local bufnr = args.buf
        vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
        vim.keymap.set('i', '<c-e>', function()
          vim.lsp.inline_completion.get()
          return '<c-e>'
        end, { silent = true, expr = true, buffer = bufnr })
        vim.keymap.set('i', '<c-f>', function()
          vim.lsp.inline_completion.select()
        end, { silent = true, buffer = bufnr })
        vim.keymap.set('i', '<c-b>', function()
          vim.lsp.inline_completion.select({ count = -1 * vim.v.count1 })
        end, { silent = true, buffer = bufnr })
      end,
    })
  end,
}
