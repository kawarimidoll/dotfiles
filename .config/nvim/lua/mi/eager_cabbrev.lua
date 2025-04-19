local defined_abbrev_table = {}

return function(lhs, rhs)
  local lhs_except_last = string.sub(lhs, 1, -2)
  local lhs_last = string.sub(lhs, -1)

  if not defined_abbrev_table[lhs_last] then
    defined_abbrev_table[lhs_last] = {}
  end

  defined_abbrev_table[lhs_last][lhs_except_last] = rhs

  vim.keymap.set('c', lhs_last, function()
    if vim.fn.getcmdtype() ~= ':' then
      return lhs_last
    end
    local cmd_tail = vim.fn.getcmdline():gsub([[^'<,'>]], '')
    local mapped = defined_abbrev_table[lhs_last][cmd_tail]
    if not mapped then
      return lhs_last
    end
    local bs = string.rep('<bs>', string.len(cmd_tail))
    local keys = type(mapped) == 'function' and mapped() or mapped
    return bs .. keys
  end, { expr = true, desc = 'eager_cabbrev ' .. lhs_last })
end
