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

null_ls.setup({
  sources = sources
})
