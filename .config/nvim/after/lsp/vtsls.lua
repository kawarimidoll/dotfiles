-- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
return {
  settings = {
    typescript = {
      -- inlayHints = {
      --   parameterNames = { enabled = 'all' },
      --   parameterTypes = { enabled = true },
      --   variableTypes = { enabled = true },
      --   propertyDeclarationTypes = { enabled = true },
      --   functionLikeReturnTypes = { enabled = true },
      --   enumMemberValues = { enabled = true },
      -- },
      preferences = { preferTypeOnlyAutoImports = true },
      preferGoToSourceDefinition = true,
    },
    javascript = {
      preferGoToSourceDefinition = true,
    },
  },
  root_dir = function(bufnr, callback)
    local found_dirs = vim.fs.find({
      'package.json'
    }, {
      upward = true,
      path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr)))
    })
    if #found_dirs > 0 then
      return callback(vim.fs.dirname(found_dirs[1]))
    end
  end
}
