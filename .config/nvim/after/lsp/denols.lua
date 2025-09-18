local get_node_root = require('mi.utils').get_node_root

return {
  root_dir = function(bufnr, callback)
    local deno_markers = { 'deno.json', 'deno.jsonc', 'deps.ts' }
    local deno_dir = vim.fs.root(bufnr, deno_markers)
    if deno_dir then
      return callback(deno_dir)
    end

    local node_root = get_node_root(bufnr)
    if node_root then
      return
    end

    local cwd = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr)))
    return callback(cwd)
  end,
}
