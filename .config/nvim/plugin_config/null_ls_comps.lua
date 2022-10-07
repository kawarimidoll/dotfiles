local null_ls = require('null-ls')

local register_completion = function(name, fn, filetypes)
  null_ls.register({
    name = name,
    method = null_ls.methods.COMPLETION,
    filetypes = filetypes or {},
    generator = { async = true, fn = fn },
  })
end

local Job = require('plenary.job')
register_completion('rg-dictionary', function(params, done)
  local dictionaries = vim.opt.dictionary:get()
  if vim.tbl_isempty(dictionaries) then
    return
  end

  local args = {
    '--ignore-case',
    '--no-heading',
    '--no-line-number',
    '--color=never',
    '^' .. params.word_to_complete,
  }
  vim.list_extend(args, dictionaries)

  local on_exit = function(j, exit_status)
    if exit_status ~= 0 then
      return
    end

    local items = {}
    for _, v in ipairs(j:result()) do
      if v ~= '' then
        local dict_path, word = unpack(vim.split(v, ':'))
        local item = {
          label = word,
          kind = vim.lsp.protocol.CompletionItemKind.Text,
          detail = '[D]',
          documentation = dict_path,
          sortText = '~~~' .. word,
        }
        table.insert(items, item)
      end
    end

    done({ { items = items, isIncomplete = #items > 0 } })
  end

  Job:new({
    command = 'rg',
    args = args,
    on_exit = on_exit,
  }):start()
end)

register_completion('ex-commands', function(params, done)
  local cmds = vim.fn.getcompletion(params.word_to_complete, 'command', 1)

  local items = {}
  for _, cmd in ipairs(cmds) do
    if cmd ~= '' then
      local item = {
        label = cmd,
        detail = '[C]',
        kind = vim.lsp.protocol.CompletionItemKind.Operator,
      }
      table.insert(items, item)
    end
  end

  done({ { items = items, isIncomplete = #items > 0 } })
end, { 'vim', 'lua' })

register_completion('au-events', function(params, done)
  local events = vim.fn.getcompletion(params.word_to_complete, 'event', 1)

  local items = {}
  for _, event in ipairs(events) do
    if event ~= '' then
      local item = {
        label = event,
        detail = '[E]',
        kind = vim.lsp.protocol.CompletionItemKind.Event,
      }
      table.insert(items, item)
    end
  end

  done({ { items = items, isIncomplete = #items > 0 } })
end, { 'vim', 'lua' })

register_completion('file', function(params, done)
  local line = string.sub(params.content[params.row], 1, params.col)
  local files = {}
  local s, t = vim.regex('\\f\\+$'):match_str(line)
  if s and t then
    local word_to_complete = vim.fs.normalize(string.sub(line, s + 1, t))
    files = vim.fn.getcompletion(word_to_complete, 'file', 1)
  end
  if vim.tbl_isempty(files) then
    return
  end

  local items = {}
  for _, file in ipairs(files) do
    local path = vim.fs.normalize(file)
    if path ~= '' then
      local is_dir = vim.fn.isdirectory(path) == 1
      local item = {
        label = vim.fs.basename(string.gsub(path, '/$', '')),
        detail = '[F]',
        kind = is_dir and vim.lsp.protocol.CompletionItemKind.Folder
          or vim.lsp.protocol.CompletionItemKind.File,
        documentation = path,
      }
      table.insert(items, item)
    end
  end

  done({ { items = items, isIncomplete = #items > 0 } })
end)

register_completion('around', function(params, done)
  -- local term = params.word_to_complete

  local range = 100
  local word_pattern = '[%w](_?[%w])+'

  -- no need to limit in 1..#params.content because vim.list_slice do that
  local lnum_from = params.row - range
  local lnum_to = params.row + range

  local items = {}
  local exists = {}
  for _, line in ipairs(vim.list_slice(params.content, lnum_from, lnum_to)) do
    for w in string.gmatch(line, word_pattern) do
      -- if not exists[w] and string.match(w, '^' .. term .. '.') then
      if not exists[w] then
        -- avoid duplication
        exists[w] = true

        local item = {
          label = w,
          detail = '[A]',
          kind = vim.lsp.protocol.CompletionItemKind.Keyword,
          sortText = '~~~~' .. w,
        }
        table.insert(items, item)
      end
    end
  end

  done({ { items = items, isIncomplete = #items > 0 } })
end)
