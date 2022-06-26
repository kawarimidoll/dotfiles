local lsp_installer = require("nvim-lsp-installer")
local nvim_lsp = require('lspconfig')
lsp_installer.setup({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

for _, server in ipairs(lsp_installer.get_installed_servers()) do
  local opts = {}

  ---@diagnostic disable-next-line: undefined-global
  if lsp_capabilities ~= nil then
    ---@diagnostic disable-next-line: undefined-global
    opts.capabilities = lsp_capabilities
  end

  if server.name == "tsserver" then
    opts.root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
    opts.settings = { documentFormatting = false }
    opts.init_options = { hostInfo = "neovim" }
  elseif server.name == "eslint" then
    opts.root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
  elseif server.name == "denols" then
    opts.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
    opts.init_options = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://cdn.nest.land"] = true,
            ["https://crux.land"] = true
          }
        }
      }
    }
  elseif server.name == "sumneko_lua" then
    -- https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
    local path = {}
    table.insert(path, "?.lua")
    table.insert(path, "?/init.lua")

    opts.settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = path,
        },
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      }
    }
  end

  opts.on_attach = function(_, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>p', vim.lsp.buf.formatting, bufopts)
  end

  nvim_lsp[server.name].setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end
