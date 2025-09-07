local function has_luarc(path)
  return vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')
end
return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config') and has_luarc(path) then
        return
      end
    end
    client.config.settings.Lua.workspace.library =
      vim.list_extend(vim.api.nvim_get_runtime_file('lua', true), {
        '${3rd}/luv/library',
        '${3rd}/busted/library',
      })
  end,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        requirePattern = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {},
        ignoreGlobs = { '**/*_spec.lua' },
      },
    },
  },
}
