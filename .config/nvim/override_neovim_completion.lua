-- override functions in runtime/lua/vim/lsp/util.lua
local util = require('vim.lsp.util')

---@param arg any Value to check
---@return any|nil value Found value if exists, nil otherwise
local function presence(arg)
  if arg ~= nil and arg ~= 0 and arg ~= '' then
    return arg
  end
  return nil
end

-- override to ignore case
local function compare_completion_items(a, b)
  return vim.stricmp((presence(a.sortText) or a.label), (presence(b.sortText) or b.label)) < 0
end

local function get_completion_word(item)
  local returnText = presence(vim.tbl_get(item, 'textEdit', 'newText'))
    or presence(item.insertText)
    or item.label

  if
    item.insertTextFormat == 'Snippet'
    or item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet
  then
    return vim.lsp.util.parse_snippet(returnText)
  end

  return returnText
end

-- override to use filterText
local function filter_completion_items(items, prefix)
  return vim.tbl_filter(function(item)
    return vim.startswith(presence(item.filterText) or get_completion_word(item), prefix)
  end, items)
end

util.text_document_completion_list_to_complete_items = function(result, prefix)
  local items = util.extract_completion_items(result)
  if vim.tbl_isempty(items) then
    return {}
  end

  items = filter_completion_items(items, prefix)
  table.sort(items, compare_completion_items)

  local matches = {}

  for _, completion_item in ipairs(items) do
    local info = ''
    local documentation = completion_item.documentation
    if documentation then
      if type(documentation) == 'string' then
        info = documentation
      elseif type(documentation) == 'table' and type(documentation.value) == 'string' then
        info = documentation.value
      end
    end

    local word = get_completion_word(completion_item)
    table.insert(matches, {
      word = word,
      abbr = completion_item.label,
      kind = util._get_completion_item_kind_name(completion_item.kind),
      menu = completion_item.detail or '',
      info = info,
      icase = 1,
      dup = 1,
      empty = 1,
      user_data = { nvim = { lsp = { completion_item = completion_item } } },
    })
  end

  return matches
end
