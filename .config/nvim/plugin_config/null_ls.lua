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
  local vim_dictionary_url = 'https://github.com/iamcco/coc-spell-checker/raw/master/dicts/vim/vim.txt.gz'
  io.popen('curl -fsSLo ' .. cspell_files.vim .. ' --create-dirs ' .. vim_dictionary_url)
end
if vim.fn.filereadable(cspell_files.user) ~= 1 then
  io.popen('mkdir -p ' .. cspell_data_dir)
  io.popen('touch ' .. cspell_files.user)
end

local null_ls = require('null-ls')

local prettier_configs = vim.tbl_map(
  function(ext) return '.prettierrc' .. ext end,
  { '', '.js', '.cjs', '.json', '.json5', '.yml', '.yaml', '.toml' }
) or {}
table.insert(prettier_configs, 'prettier.config.js')
table.insert(prettier_configs, 'prettier.config.cjs')

local sources = {
  -- completion
  null_ls.builtins.completion.spell,
  null_ls.builtins.completion.vsnip,

  -- diagnostics
  null_ls.builtins.diagnostics.cspell.with({
    diagnostics_postprocess = function(diagnostic)
      diagnostic.severity = vim.diagnostic.severity["WARN"]
    end,
    condition = function()
      return vim.fn.executable('cspell') > 0
    end,
    extra_args = { '--config', cspell_files.config }
  }),

  -- formatting
  null_ls.builtins.formatting.deno_fmt.with {
    filetypes = { "markdown" },
    condition = function(utils)
      return not utils.has_file(prettier_configs)
    end,
  },
  null_ls.builtins.formatting.prettier.with {
    condition = function(utils)
      return utils.has_file(prettier_configs)
    end,
    prefer_local = "node_modules/.bin",
  },
}

local cspell_append = function(opts)
  local word = opts.args
  if not word or word == "" then
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

vim.api.nvim_create_user_command(
  'CSpellAppend',
  cspell_append,
  { nargs = '?', bang = true }
)

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
        if v.source == "cspell" and
            v.col < col and col <= v.end_col and
            string.match(v.message, regex) then
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
          end
        },
        {
          title = 'Append "' .. word .. '" to dotfiles dictionary',
          action = function()
            cspell_append({ args = word, bang = true })
          end
        }
      }
    end
  }
}
null_ls.register(cspell_custom_actions)

local get_candidates = function(entries, opts)
  opts = opts or {}
  local detail = opts.detail or ''
  local kind = opts.kind or vim.lsp.protocol.CompletionItemKind['Text']
  local items = {}
  for _, v in ipairs(entries) do
    if v ~= '' then
      table.insert(items, { label = v, detail = detail, kind = kind })
    end
  end
  return items
end

local rg_dictionary_completion = {
  name = 'rg-dictionary',
  meta = { description = "rg-dictionary completion source.", },
  method = null_ls.methods.COMPLETION,
  filetypes = {},
  generator = {
    fn = function(params, done)
      local dictionaries = vim.api.nvim_get_option_value('dictionary', {})
      local src = vim.fn.substitute(dictionaries, ',', ' ', 'g')
      local pattern = '^' .. params.word_to_complete

      -- local file = io.popen('look ' .. params.word_to_complete)
      local cmd = table.concat({ 'rg',
        '--ignore-case',
        '--no-heading',
        '--no-line-number',
        '--color=never',
        pattern,
        src
      }, ' ')
      local file = io.popen(cmd)
      local stdout = ''
      if file then
        stdout = file:read('a')
        file:close()
      end

      local kind = vim.lsp.protocol.CompletionItemKind['Text']
      local candidates = {}
      for _, v in ipairs(vim.split(stdout, '\r?\n')) do
        if v ~= '' then
          local path_and_word = vim.split(v, ':')
          local label = path_and_word[2]
          local detail = string.gsub(path_and_word[1], '.*/', '[dic] ')

          table.insert(candidates, { label = label, detail = detail, kind = kind })
        end
      end
      done({ { items = candidates, isIncomplete = #candidates > 0 } })
    end,
    async = true,
  },
}
null_ls.register(rg_dictionary_completion)

local ex_commands_completion = {
  name = 'ex-commands',
  meta = { description = "ex-commands completion source.", },
  method = null_ls.methods.COMPLETION,
  filetypes = { 'vim', 'lua' },
  generator = {
    fn = function(params, done)
      local cmds = vim.fn.getcompletion(params.word_to_complete, 'command', 1)

      local candidates = get_candidates(cmds, { detail = '[cmd]' })
      done({ { items = candidates, isIncomplete = #candidates > 0 } })
    end,
    async = true,
  },
}
null_ls.register(ex_commands_completion)

local file_completion = {
  name = 'file',
  meta = { description = "file completion source.", },
  method = null_ls.methods.COMPLETION,
  filetypes = {},
  generator = {
    fn = function(params, done)
      local cmds = vim.fn.getcompletion(params.word_to_complete, 'file', 1)

      local candidates = get_candidates(cmds, { detail = '[file]' })
      done({ { items = candidates, isIncomplete = #candidates > 0 } })
    end,
    async = true,
  },
}
null_ls.register(file_completion)

local around_completion = {
  name = 'around',
  meta = { description = "around completion source.", },
  method = null_ls.methods.COMPLETION,
  filetypes = {},
  generator = {
    fn = function(params, done)
      local term = params.word_to_complete
      local range = 100
      local current_line = vim.fn.line('.')
      local lnum_from = math.max(1, current_line - range)
      local lnum_to = math.min(vim.fn.line('$'), current_line + range)

      local lines = vim.fn.getline(lnum_from, lnum_to)
      local aggregated = {}
      for _, x in ipairs(lines) do
        for w in string.gmatch(x, '[_%w][_%w]+') do
          if w ~= term and vim.startswith(w, term) then
            aggregated[w] = 1
          end
        end
      end

      local candidates = get_candidates(vim.tbl_keys(aggregated), { detail = '[A]' })
      done({ { items = candidates, isIncomplete = #candidates > 0 } })
    end,
    async = true,
  },
}
null_ls.register(around_completion)

null_ls.setup({
  sources = sources
})
