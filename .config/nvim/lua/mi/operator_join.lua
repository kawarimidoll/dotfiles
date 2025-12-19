-- @param mode string|nil One of `nil`, `'char'`, `'line'`, `'block'`, `'visual'`.
_G.OperatorJoin = function(mode)
  if require('mi.utils').blank(mode) then
    vim.o.operatorfunc = 'v:lua.OperatorJoin'
    return 'g@'
  end
  vim.cmd.normal({ args = { '`[v`]J' }, bang = true })
end

return _G.OperatorJoin
