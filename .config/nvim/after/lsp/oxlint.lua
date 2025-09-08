return {
  cmd = function(dispatchers, config)
    local cmd = (config or {}).root_dir
      and config.root_dir .. '/node_modules/.bin/oxc_language_server'
    -- 本来ならexecutable()で確認するべきだが、node_modules/.binに入っている時点で
    -- 実行可能とみなして厳密なチェックは省略
    if vim.uv.fs_stat(cmd) then
      return vim.lsp.rpc.start({ cmd }, dispatchers)
    end
  end,
  root_dir = function(bufnr, callback)
    local node_markers =
      { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    local node_dir = vim.fs.root(bufnr, { node_markers })
    if not node_dir then
      return
    end

    return callback(node_dir)
  end,
}
