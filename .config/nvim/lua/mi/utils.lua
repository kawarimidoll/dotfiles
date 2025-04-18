local M = {}

-- 存在するならtrueを返す
function M.present(v)
  if not v or v == 0 or v == '' then
    return false
  elseif type(v) == 'table' and next(v) == nil then
    return false
  end
  return true
end

function M.blank(v)
  return not M.present(v)
end

-- fnを引数なしに変える
function M.noarg(fn)
  if type(fn) ~= 'function' then
    error('fn must be a function')
  end
  return function()
    return fn()
  end
end

-- 現在の選択範囲を取得
function M.get_current_selection()
  return vim.fn.getregion(
    vim.fn.getpos('v'),
    vim.fn.getpos('.'),
    { type = vim.api.nvim_get_mode().mode }
  )
end

-- https://scrapbox.io/vim-jp/boolean%E3%81%AA%E5%80%A4%E3%82%92%E8%BF%94%E3%81%99vim.fn%E3%81%AEwrapper_function
-- example:
-- if vim.bool_fn.has('mac') then ... end
if not vim.bool_fn then
  vim.bool_fn = setmetatable({}, {
    __index = function(_, key)
      return function(...)
        return M.present(vim.fn[key](...))
      end
    end,
  })
end

return M
