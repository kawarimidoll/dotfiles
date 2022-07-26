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
local sources = {
  null_ls.builtins.diagnostics.cspell.with({
    diagnostics_postprocess = function(diagnostic)
      diagnostic.severity = vim.diagnostic.severity["WARN"]
    end,
    condition = function()
      return vim.fn.executable('cspell') > 0
    end,
    extra_args = { '--config', cspell_files.config }
  }),
}

local cspell_append = function(opts)
  local word = opts.args
  if not word or word == "" then
    word = vim.call('expand', '<cword>'):lower()
  end

  local dictionary_name = opts.bang and 'dotfiles' or 'user'

  io.popen('echo ' .. word .. ' >> ' .. cspell_files[dictionary_name])
  print('"' .. word .. '" is appended to ' .. dictionary_name .. ' dictionary.')

  -- redraw current line to reload cspell
  vim.api.nvim_set_current_line(vim.api.nvim_get_current_line())
end

vim.api.nvim_create_user_command(
  'CSpellAppend',
  cspell_append,
  { nargs = '?', bang = true }
)

local cspell_custom_actions = {
  method = null_ls.methods.CODE_ACTION,
  filetypes = {},
  generator = {
    fn = function(_)
      local lnum = vim.fn.getcurpos()[2] - 1
      local diagnostics = vim.diagnostic.get(0, { lnum = lnum })
      local cword = vim.call('expand', '<cword>')
      if not cword or cword == '' then
        return
      end
      -- require('mini.misc').put({ lnum = lnum, cword = cword })
      -- require('mini.misc').put(diagnostics)

      local found = false
      for _, v in pairs(diagnostics) do
        if v.source == "cspell" and v.message == "Unknown word (" .. cword .. ")" then
          found = true
          break
        end
      end
      if not found then
        return
      end

      local word = cword:lower()
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
