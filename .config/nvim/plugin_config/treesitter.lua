require('nvim-treesitter.configs').setup({
  -- {{{ nvim-treesitter
  sync_install = false,
  indent = { enable = true },
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
  context_commentstring = { enable = true },
  -- }}}

  -- {{{ vim-matchup
  matchup = { enable = true },
  -- }}}
})