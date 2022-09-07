local mason = require('mason')
local nvim_lsp = require('lspconfig')
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if ok then
  local lsp_capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

vim.keymap.set('n', '<space>p',
  function()
    if vim.lsp.buf.format then
      vim.lsp.buf.format({
        filter = function(client)
          return client.name ~= 'tsserver'
        end
      })
    else
      vim.lsp.buf.formatting()
    end
  end,
  { silent = true })

local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers({
  function(server_name)
    local node_root_dir = nvim_lsp.util.root_pattern('package.json')
    local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

    local opts = {}

    if lsp_capabilities ~= nil then
      opts.capabilities = lsp_capabilities
    end

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

      opts.root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.jsonc', 'deps.ts', 'import_map.json')
      opts.init_options = {
        lint = true,
        unstable = true,
        suggest = {
          imports = {
            hosts = {
              ['https://deno.land'] = true,
              ['https://cdn.nest.land'] = true,
              ['https://crux.land'] = true
            }
          }
        }
      }
    elseif server_name == 'sumneko_lua' then
      -- https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua
      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
      local path = { '?.lua', '?/init.lua' }

      opts.settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = path,
          },
          completion = { callSnippet = 'Replace' },
          diagnostics = { globals = { 'vim' } },
          workspace = { library = vim.api.nvim_get_runtime_file('', true) },
          telemetry = { enable = false },
        }
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
  end
})
