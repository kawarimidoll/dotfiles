-- https://scrapbox.io/vim-jp/boolean%E3%81%AA%E5%80%A4%E3%82%92%E8%BF%94%E3%81%99vim.fn%E3%81%AEwrapper_function
-- example:
-- if vim.bool_fn.has('mac') then ... end
if not vim.bool_fn then
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
end

-- https://zenn.dev/uga_rosa/articles/2548e7517b8a8d
-- example:
-- local add = vim.lambda[[ x, y: x + y ]]
-- print(add(1, 2))
-- -> output: 3
if not vim.lambda then
  ---@param str string
  ---@return function
  vim.lambda = function(str)
    local chunk = [[return function(%s) return %s end]]
    local arg, body = str:match('(.*):(.*)')
    return assert(load(chunk:format(arg, body)))()
  end
end
