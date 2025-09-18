local get_node_root = require('mi.utils').get_node_root

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
    local node_root = get_node_root(bufnr)
    if node_root then
      callback(node_root)
    end
  end,
}
