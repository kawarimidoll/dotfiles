require('nvim-treesitter.configs').setup({
  -- {{{ nvim-treesitter
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'vim' },
  },
  sync_install = false,
  indent = { enable = false }, -- use yati for indent
  -- }}}

  -- {{{ nvim-treesitter-refactor
  refactor = {
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "gd",
        list_definitions = "grD",
        list_definitions_toc = "grt",
        goto_previous_usage = "[u",
        goto_next_usage = "]u",
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
require('hlargs').setup()

-- require('treesitter-context').setup({
  -- enable = true,
  -- max_lines = 100,
  -- patterns = {
    -- default = {
      -- 'class',
      -- 'function',
      -- 'method',
      -- 'for',
      -- 'while',
      -- 'if',
      -- 'switch',
      -- 'case',
    -- },
  -- },
-- })
