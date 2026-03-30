local get_node_root = require('mi.utils').get_node_root

-- tsgoが bundled:///libs/**/*.{...} という無効なglobパターンを送信し
-- Neovimのglob parserでエラーになるため、該当パターンのみ除外する
-- ref: https://github.com/neovim/neovim/issues/37204
local function filtered_register_capability(err, params, ctx)
  local filtered = vim.deepcopy(params)
  for _, reg in ipairs(filtered.registrations) do
    if reg.method == 'workspace/didChangeWatchedFiles' then
      local opts = reg.registerOptions or {}
      local watchers = opts.watchers or {}
      reg.registerOptions = reg.registerOptions or {}
      reg.registerOptions.watchers = vim.tbl_filter(function(w)
        local glob_pat = w.globPattern
        if type(glob_pat) == 'string' then
          return not glob_pat:find('^bundled:///')
        end
        return true
      end, watchers)
    end
  end
  return vim.lsp.handlers['client/registerCapability'](err, filtered, ctx)
end

return {
  handlers = {
    ['client/registerCapability'] = filtered_register_capability,
  },
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
