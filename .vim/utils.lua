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

if not vim.inspect then
  local function inspect(t, indent)
    local loop = false
    local output =  ''
    for _, v in ipairs(t) do
      if loop then
        output = output .. ","
      end
      loop = true

      if type(v) == "table" then
        output = output
              .. " {"
              .. inspect(v, indent .. '  ')
        if output:sub(-1) == '\n' then
          output = output .. indent .. "}"
        else
          output = output .. "}"
        end
      else
        output = output .. ' ' .. v
      end
    end

    local idx = 0
    local simple_array = true
    for k, v in pairs(t) do
      idx = idx + 1
      if k == idx then
        goto continue
      end
      simple_array = false

      if loop then
        output = output .. ","
      end
      loop = true

      output = output .. "\n"

      if type(v) == "table" then
        output = output
              .. indent .. k .. " = {\n"
              .. inspect(v, indent .. '  ')
              .. indent .. "}"
      else
        output = output
              .. indent .. k .. " = " .. vim.fn.string(v)
      end

      ::continue::
    end

    if simple_array then
      return output .. ' '
    else
      return output .. "\n"
    end
  end
  local function inspect_entry(t)
    return "{" .. inspect(t, '  ') .. "}"
  end
  vim.inspect = inspect_entry
end
if not vim.print then
  vim.print = function(v)
    print(vim.inspect(v))
  end
end

-- vim.print({1,2,3, 4})
-- vim.print({1,2,{3, 4}})
-- vim.print({1,2,3, a='k', b='2', 5, {t='ok',j=3}, 4})
-- vim.print({a = 2, b = 100, c = { k = 'KK', j = 3}, func = function(a) print(a) end, f2 = vim.lambda })
-- vim.print({1, 2, 3, a=2, b=100})
