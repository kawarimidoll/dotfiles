-- https://scrapbox.io/vim-jp/boolean%E3%81%AA%E5%80%A4%E3%82%92%E8%BF%94%E3%81%99vim.fn%E3%81%AEwrapper_function
vim.bool_fn = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      local v = vim.fn[key](...)
      if not v or v == 0 or v == '' then
        return false
      elseif type(v) == 'table' and next(v) == nil then
        return false
      end
      return true
    end
  end,
})

-- example:
-- if vim.bool_fn.has('mac') then ... end
