local get_node_root = require('mi.utils').get_node_root

return {
  cmd = function(dispatchers, config)
    local cmd = (config or {}).root_dir
      and config.root_dir .. '/node_modules/.bin/oxlint'
    -- 本来ならexecutable()で確認するべきだが、node_modules/.binに入っている時点で
    -- 実行可能とみなして厳密なチェックは省略
    if vim.uv.fs_stat(cmd) then
      return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
    end
  end,
  root_dir = function(bufnr, callback)
    local node_root = get_node_root(bufnr)
    if node_root then
      callback(node_root)
    end
  end,
}
