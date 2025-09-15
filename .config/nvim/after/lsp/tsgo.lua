return {
  settings = {
    typescript = {
      preferences = { preferTypeOnlyAutoImports = true },
      preferGoToSourceDefinition = true,
    },
    javascript = {
      preferGoToSourceDefinition = true,
    },
  },
  root_dir = function(bufnr, callback)
    local node_markers =
      { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    local node_dir = vim.fs.root(bufnr, node_markers)
    if node_dir then
      callback(node_dir)
    end
  end,
}
