local M = {}

-- https://github.com/neovim/neovim/blob/6a330f893bf15ecab99f1fc796029c7bdba71139/runtime/lua/tohtml.lua#L828-L831
--- @return string
local function utf8_sub(str, i, j)
  return vim.fn.strcharpart(str, i - 1, j and j - i + 1 or nil)
end

M.get_cursor_neighbor = function()
  local current_line = vim.api.nvim_get_current_line()

  -- Return nil if the line is empty
  if current_line == '' then
    return {
      line_before_cursor = '',
      char_before_cursor = '',
      char_at_cursor = '',
      char_after_cursor = '',
      line_after_cursor = '',
    }
  end

  local col = vim.fn.getcursorcharpos()[3] - 1

  -- Text from the beginning of the line to just before the cursor
  local line_before_cursor = utf8_sub(current_line, 0, col)
  -- Character just before the cursor
  local char_before_cursor = utf8_sub(line_before_cursor, -1)
  -- Character at the cursor position
  local char_at_cursor = utf8_sub(current_line, col, 1)
  -- Text from just after the cursor to the end of the line
  local line_after_cursor = utf8_sub(current_line, col + 1)
  -- Character just after the cursor
  local char_after_cursor = utf8_sub(line_after_cursor, 0, 1)

  return {
    line_before_cursor = line_before_cursor,
    char_before_cursor = char_before_cursor,
    char_at_cursor = char_at_cursor,
    char_after_cursor = char_after_cursor,
    line_after_cursor = line_after_cursor,
  }
end

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
  -- return empty array if not in visual mode
  if not vim.api.nvim_get_mode().mode:match('[vV\x16]') then
    return {}
  end
  return vim.fn.getregion(
    vim.fn.getpos('v'),
    vim.fn.getpos('.'),
    { type = vim.api.nvim_get_mode().mode }
  )
end

function M.get_node_root(bufnr)
  local root_markers =
    { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
  return vim.fs.root(bufnr, root_markers)
end

--- skip hit-enter prompt
-- hit-enterプロンプトをスキップするラップされた関数を返す
-- @param fn function ラップする関数
-- @param opts table|nil オプションのテーブル
--   - wait (number|nil): 待機時間（ミリ秒）。デフォルトは0。
-- @return function hit-enterをスキップするラップされた関数
function M.skip_hit_enter(fn, opts)
  opts = opts or {}
  if type(fn) ~= 'function' then
    error('fn must be a function')
  end
  local wait = opts.wait or 0
  vim.notify('wait: ' .. wait, vim.log.levels.INFO)
  if type(wait) ~= 'number' then
    error('wait must be a number')
  end
  return function(...)
    local save_mopt = vim.opt.messagesopt:get()
    vim.opt.messagesopt:append('wait:' .. wait)
    vim.opt.messagesopt:remove('hit-enter')
    fn(...)
    vim.cmd('echomsg &messagesopt')
    vim.schedule(function()
      vim.opt.messagesopt = save_mopt
    end)
  end
end

---@param mark string
function M.set_mark_here(mark)
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_mark(0, mark:lower(), pos[1], pos[2], {})
  vim.api.nvim_buf_set_mark(0, mark:upper(), pos[1], pos[2], {})
end

-- 微妙にうまくいかない
-- vim.api.nvim_create_user_command(
--   'SkipHitEnter',
--   function(arg)
--     M.skip_hit_enter(function(v)
--       -- vim.api.nvim_exec2(v, { output = true })
--       vim.cmd(v)
--     end, { wait = arg.count })(arg.args)
--   end,
--   {
--     desc = 'Skip hit-enter prompt',
--     nargs = '+',
--     complete = 'command',
--     count = true,
--   }
-- )

-- if vim.fn.has('vim_starting') == 1 then
--   vim.cmd.checkhealth = M.skip_hit_enter(vim.cmd.checkhealth)
-- end

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
