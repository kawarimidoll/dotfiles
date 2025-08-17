return {
  root_dir = function(bufnr, callback)
    local cwd = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr)))
    local deno_dirs = vim.fs.find({
      'deno.json',
      'deno.jsonc',
      'deps.ts',
    }, {
      upward = true,
      path = cwd,
    })
    if #deno_dirs > 0 then
      return callback(vim.fs.dirname(deno_dirs[1]))
    end

    local node_dirs = vim.fs.find({
      'package.json',
    }, {
      upward = true,
      path = cwd,
    })
    if #node_dirs == 0 then
      return callback(cwd)
    end
  end,
}
