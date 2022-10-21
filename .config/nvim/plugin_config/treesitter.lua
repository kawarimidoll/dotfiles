local parser_install_dir = vim.fn.stdpath('data') .. '/treesitter'
vim.opt.runtimepath:append(parser_install_dir)

require('nvim-treesitter.configs').setup({
  -- {{{ nvim-treesitter
  highlight = {
    enable = true,
    disable = function(lang, buf)
      -- disable in large files
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end

      -- disable when parse failed
      local parse_success = pcall(function()
        vim.treesitter.get_query(lang, 'highlights')
      end)
      if not parse_success then
        return true
      end

      return false
    end,
    additional_vim_regex_highlighting = { 'vim' },
    parser_install_dir = parser_install_dir,
  },
  sync_install = false,
  indent = { enable = false }, -- use yati for indent
  -- }}}

  -- {{{ nvim-treesitter-refactor
  refactor = {
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = 'grr',
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = 'gd',
        list_definitions = 'grD',
        list_definitions_toc = 'grt',
        goto_previous_usage = '[u',
        goto_next_usage = ']u',
      },
    },
  },
  -- }}}

  -- {{{ nvim-ts-rainbow
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 100,
  },
  -- }}}

  -- {{{ ts-context-commentstring
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  -- }}}

  -- {{{ vim-matchup
  matchup = { enable = true },
  -- }}}

  -- {{{ nvim-yati
  yati = { enable = true },
  -- }}}
})
