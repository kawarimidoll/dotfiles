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
}
