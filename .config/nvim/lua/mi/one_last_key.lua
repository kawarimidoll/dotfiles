local M = {}

M._saved_last_key = ''

M.setup = function()
  local ns_id = vim.api.nvim_create_namespace('one-last-key')
  vim.on_key(function(_, typed)
    if typed == '' then
      return
    end
    M._saved_last_key = vim.fn.keytrans(typed)
  end, ns_id)
end

---@return string
M.get = function()
  return M._saved_last_key
end

return M
