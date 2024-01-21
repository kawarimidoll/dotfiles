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
  local function inspect_table(t, indent)
    local next_indent = indent .. '  '

    -- parse array part
    local array_part_lines = {}
    for _, v in ipairs(t) do
      local line = ' '
      if type(v) == "table" then
        line = line .. inspect_table(v, next_indent)
      else
        line = line .. v
      end
      table.insert(array_part_lines, line)
    end
    local array_part_str = table.concat(array_part_lines, ",")

    -- parse table part
    local idx = 0
    local table_part_lines = {}
    for k, v in pairs(t) do
      idx = idx + 1
      if k == idx then
        goto continue
      end

      local line = next_indent .. k .. " = "
      if type(v) == "table" then
        line = line .. inspect_table(v, next_indent)
      else
        line = line .. vim.fn.string(v)
      end
      table.insert(table_part_lines, line)

      ::continue::
    end
    table.sort(table_part_lines)
    local table_part_str = table.concat(table_part_lines, ",\n")

    if array_part_str ~= '' and table_part_str ~= '' then
      -- array and table
      return '{' .. array_part_str .. ",\n" .. table_part_str  .. '\n' .. indent .. '}'
    elseif array_part_str ~= '' then
      -- only array
      return '{' .. array_part_str .. ' }'
    elseif table_part_str ~= '' then
      -- only table
      return '{\n' .. table_part_str .. '\n' .. indent .. '}'
    else
      return ''
    end
  end
  vim.inspect = function(t)
    if type(t) == "table" then
      return inspect_table(t, '')
    else
      return tostring(t)
    end
  end
end
if not vim.print then
  vim.print = function(v)
    print(vim.inspect(v))
  end
end

-- vim.print({1,2,3, 4})
-- vim.print({1,2,{3, 4}})
-- vim.print({{1},2,{3}, 4})

-- vim.print({a=1, b='k', c={d='a', e='b'}, g=5})

-- vim.print({1,2,3, a='k', b='2', 5, {t='ok',j=3}, 4})
-- vim.print({a = 2, b = 100, z = { k = 'KK', j = 3, p = { 1, 2, d={3}}}, func = function(a) print(a) end, f2 = {11,12} })
-- vim.print({{1}, 2, 3, a=2, f='pp', b=100})

-- local arr = {'a=1', 'fun=fff', 'b=2'}
-- table.insert(arr, 'pp')
-- vim.print(arr)
-- table.sort(arr)
-- vim.print(arr)
-- dst = table.concat(arr,"\n")
-- vim.print(dst)
