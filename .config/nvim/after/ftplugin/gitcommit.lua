-- https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
local conventional_keys = { 'feat', 'fix', 'docs', 'style', 'refactor', 'test', 'chore' }

local function get_conventional_key()
  local line = vim.api.nvim_get_current_line()
  local key = line:match('^#%s*(%w+)%s')
  if key and vim.tbl_contains(conventional_keys, key) then
    return key
  end
  return nil
end

local function is_co_authored_by_line()
  local line = vim.api.nvim_get_current_line()
  return line:match('^#%s*Add Co%-Authored%-By.*$') ~= nil
end

local function add_co_authored_by()
  vim.ui.input({ prompt = 'GitHub username: ' }, function(username)
    if not username or username == '' then
      return
    end
    local cmd = string.format(
      'gh api users/%s --jq \'"Co-Authored-By: \\(.name // .login) <\\(.id)+\\(.login)@users.noreply.github.com>"\'',
      username
    )
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify('Failed to fetch user: ' .. username, vim.log.levels.ERROR)
      return
    end
    result = vim.trim(result)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { result })
  end)
end

local function startinsert_with_commit_prefix(prefix, col)
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { prefix })
  vim.api.nvim_win_set_cursor(0, { 1, col })
  vim.cmd.startinsert({ bang = true })
end

vim.keymap.set('n', 'i', function()
  local key = get_conventional_key()
  if key then
    startinsert_with_commit_prefix(key .. ': ', #key + 1)
  elseif is_co_authored_by_line() then
    add_co_authored_by()
  else
    vim.api.nvim_feedkeys('i', 'n', false)
  end
end, { buffer = true })

vim.keymap.set('n', 'I', function()
  local key = get_conventional_key()
  if key then
    startinsert_with_commit_prefix(key .. '!: ', #key + 2)
  else
    vim.api.nvim_feedkeys('I', 'n', false)
  end
end, { buffer = true })

vim.keymap.set('n', 'a', function()
  local key = get_conventional_key()
  if key then
    startinsert_with_commit_prefix(key .. '(): ', #key)
  elseif is_co_authored_by_line() then
    add_co_authored_by()
  else
    vim.api.nvim_feedkeys('a', 'n', false)
  end
end, { buffer = true })

vim.keymap.set('n', 'A', function()
  local key = get_conventional_key()
  if key then
    startinsert_with_commit_prefix(key .. '()!: ', #key)
  else
    vim.api.nvim_feedkeys('A', 'n', false)
  end
end, { buffer = true })

vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.cmd([[
silent! /=====/,/with '#' will/fold
silent! /Changes not staged for commit:\|Untracked files:/,/--- >8 ---/fold
]])
