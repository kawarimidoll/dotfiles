require('hlslens').setup({
  calm_down = true,
  nearest_only = true,
})

local map_next_and_lens = function(key)
  vim.keymap.set({ 'n', 'x' }, key, function()
    if pcall(vim.cmd, 'normal! ' .. vim.v.count1 .. key) then
      require('hlslens').start()
    else
      ---@diagnostic disable-next-line: missing-parameter
      vim.api.nvim_echo(
        { { 'E486: Pattern not found: ' .. vim.fn.getreg('/'), 'WarningMsg' } },
        true,
        {}
      )
    end
  end, {})
end

map_next_and_lens('n')
map_next_and_lens('N')

local map_search_and_lens = function(keys)
  local starter = keys
  if vim.fn.exists('*asterisk#do') then
    starter = '<Plug>(asterisk-' .. string.gsub(keys, '[*#]', 'z%1') .. ')'
  end

  vim.keymap.set(
    { 'n', 'x' },
    keys,
    starter .. "<Cmd>lua require('hlslens').start()<CR>",
    { remap = true }
  )
end

map_search_and_lens('*')
map_search_and_lens('#')
map_search_and_lens('g*')
map_search_and_lens('g#')
