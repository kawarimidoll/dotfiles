local mason = require('mason')
local nvim_lsp = require('lspconfig')
mason.setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
  },
})

-- ref: cmp_nvim_lsp.update_capabilities
local update_capabilities = function(capabilities)
  local completionItem = capabilities.textDocument.completion.completionItem

  completionItem.snippetSupport = true
  completionItem.preselectSupport = true
  completionItem.insertReplaceSupport = true
  completionItem.labelDetailsSupport = true
  completionItem.deprecatedSupport = true
  completionItem.commitCharactersSupport = true
  completionItem.tagSupport = { valueSet = { 1 } }
  completionItem.resolveSupport =
    { properties = { 'documentation', 'detail', 'additionalTextEdits' } }

  return capabilities
end

vim.keymap.set('n', '<space>p', function()
  if vim.lsp.buf.format then
    vim.lsp.buf.format({
      filter = function(client)
        return client.name ~= 'tsserver' and client.name ~= 'jsonls'
      end,
    })
  else
    vim.lsp.buf.formatting()
  end
end, { silent = true })

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers({
  function(server_name)
    local node_root_dir = nvim_lsp.util.root_pattern('package.json')
    local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

    local opts = {}

    opts.capabilities = update_capabilities(vim.lsp.protocol.make_client_capabilities())

    if server_name == 'tsserver' then
      if not is_node_repo then
        return
      end
      opts.settings = { documentFormatting = false }
    elseif server_name == 'eslint' then
      if not is_node_repo then
        return
      end
      opts.root_dir = node_root_dir
    elseif server_name == 'denols' then
      if is_node_repo then
        return
      end

      opts.root_dir =
        nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc', 'deps.ts', 'import_map.json')
      opts.init_options = {
        lint = true,
        unstable = true,
        suggest = {
          imports = {
            hosts = {
              ['https://deno.land'] = true,
              ['https://cdn.nest.land'] = true,
              ['https://crux.land'] = true,
            },
          },
        },
      }
    elseif server_name == 'sumneko_lua' then
      -- https://github.com/folke/neodev.nvim/blob/main/lua/neodev/sumneko.lua
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
      local library = vim.api.nvim_get_runtime_file('', true)
      local neodev_dir = '/Users/kawarimidoll/.config/nvim/plugged/neodev.nvim/types'
      if vim.fn.isdirectory(neodev_dir) == 1 then
        table.insert(library, neodev_dir)
      end

      opts.settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          completion = { callSnippet = 'Both' },
          diagnostics = { globals = { 'vim' } },
          workspace = { library = library },
          telemetry = { enable = false },
        },
      }
    end

    opts.on_attach = function(_, bufnr)
      local bufopts = { silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
      -- vim.keymap.set('n', '<space>p', vim.lsp.buf.format or vim.lsp.buf.formatting, bufopts)
    end

    nvim_lsp[server_name].setup(opts)
  end,
})
