-- save dictionaries in $XDG_DATA_HOME/cspell
local cspell_config_dir = '~/.config/cspell'
local cspell_data_dir = '~/.local/share/cspell'
local cspell_files = {
  config = vim.call('expand', cspell_config_dir .. '/cspell.json'),
  dotfiles = vim.call('expand', cspell_config_dir .. '/dotfiles.txt'),
  vim = vim.call('expand', cspell_data_dir .. '/vim.txt.gz'),
  user = vim.call('expand', cspell_data_dir .. '/user.txt'),
}

if vim.fn.filereadable(cspell_files.vim) ~= 1 then
  local vim_dictionary_url =
    'https://github.com/iamcco/coc-spell-checker/raw/master/dicts/vim/vim.txt.gz'
  io.popen('curl -fsSLo ' .. cspell_files.vim .. ' --create-dirs ' .. vim_dictionary_url)
end
if vim.fn.filereadable(cspell_files.user) ~= 1 then
  io.popen('mkdir -p ' .. cspell_data_dir)
  io.popen('touch ' .. cspell_files.user)
end

local null_ls = require('null-ls')

local prettier_configs = vim.tbl_map(function(ext)
  return '.prettierrc' .. ext
end, { '', '.js', '.cjs', '.json', '.json5', '.yml', '.yaml', '.toml' }) or {}
table.insert(prettier_configs, 'prettier.config.js')
table.insert(prettier_configs, 'prettier.config.cjs')

local sources = {
  -- completion
  -- null_ls.builtins.completion.spell,
  null_ls.builtins.completion.vsnip.with({
    generator = {
      fn = function(params, done)
        local items = {}
        local snips = vim.fn['vsnip#get_complete_items'](params.bufnr)
        local targets = vim.tbl_filter(function(item)
          return string.match(item.word, '^' .. params.word_to_complete)
        end, snips)
        for _, item in ipairs(targets) do
          local user_data = vim.fn.json_decode(item.user_data or '{}')
          local value = ''
          if user_data and user_data.vsnip and user_data.vsnip.snippet then
            value = vim.fn['vsnip#to_string'](user_data.vsnip.snippet)
          end
          table.insert(items, {
            word = item.word,
            label = item.abbr,
            detail = item.menu,
            kind = vim.lsp.protocol.CompletionItemKind['Snippet'],
            documentation = { value = value, kind = vim.lsp.protocol.MarkupKind.PlainText },
          })
        end
        done({ { items = items, isIncomplete = #items > 0 } })
      end,
      async = true,
    },
  }),

  -- diagnostics
  null_ls.builtins.diagnostics.cspell.with({
    diagnostics_postprocess = function(diagnostic)
      diagnostic.severity = vim.diagnostic.severity['WARN']
    end,
    condition = function()
      return vim.fn.executable('cspell') > 0
    end,
    extra_args = { '--config', cspell_files.config },
  }),

  -- formatting
  null_ls.builtins.formatting.deno_fmt.with({
    filetypes = { 'markdown' },
    condition = function(utils)
      return not utils.has_file(prettier_configs)
    end,
  }),
  null_ls.builtins.formatting.prettier.with({
    condition = function(utils)
      return utils.has_file(prettier_configs)
    end,
    prefer_local = 'node_modules/.bin',
  }),
  null_ls.builtins.formatting.stylua.with({
    condition = function()
      return vim.fn.executable('stylua') > 0
    end,
  }),
}

local cspell_append = function(opts)
  local word = opts.args
  if not word or word == '' then
    word = vim.call('expand', '<cword>'):lower()
  end

  local dictionary_name = opts.bang and 'dotfiles' or 'user'

  io.popen('echo ' .. word .. ' >> ' .. cspell_files[dictionary_name])
  vim.notify(
    '"' .. word .. '" is appended to ' .. dictionary_name .. ' dictionary.',
    vim.log.levels.INFO,
    {}
  )

  -- redraw current line (and undo immediately) to reload cspell
  if vim.api.nvim_get_option_value('modifiable', {}) then
    vim.api.nvim_set_current_line(vim.api.nvim_get_current_line())
    vim.api.nvim_command('silent! undo')
  end
end

vim.api.nvim_create_user_command('CSpellAppend', cspell_append, { nargs = '?', bang = true })

local cspell_custom_actions = {
  name = 'append-to-cspell-dictionary',
  method = null_ls.methods.CODE_ACTION,
  filetypes = {},
  generator = {
    fn = function(_)
      local lnum = vim.fn.getcurpos()[2] - 1
      local col = vim.fn.getcurpos()[3]
      local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

      -- require('mini.misc').put({ pos = vim.fn.getcurpos() })
      -- require('mini.misc').put(diagnostics)

      local word = ''
      local regex = '^Unknown word %((%w+)%)$'
      for _, v in pairs(diagnostics) do
        if
          v.source == 'cspell'
          and v.col < col
          and col <= v.end_col
          and string.match(v.message, regex)
        then
          word = string.gsub(v.message, regex, '%1'):lower()
          break
        end
      end

      if word == '' then
        return
      end

      return {
        {
          title = 'Append "' .. word .. '" to user dictionary',
          action = function()
            cspell_append({ args = word })
          end,
        },
        {
          title = 'Append "' .. word .. '" to dotfiles dictionary',
          action = function()
            cspell_append({ args = word, bang = true })
          end,
        },
      }
    end,
  },
}
null_ls.register(cspell_custom_actions)

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

null_ls.setup({
  sources = sources,
})
