local fzf_lua = require('fzf-lua')

fzf_lua.setup({
  winopts = {
    height = 0.90,
    width  = 0.90,
    row    = 0.35,
    col    = 0.50,
  },
  keymap = {
    -- These override the default tables completely
    -- no need to set to `false` to disable a bind
    -- delete or modify is sufficient
    builtin = {
      ["<C-/>"]    = "toggle-help",
      ["<C-;>"]    = "toggle-preview-wrap",
      ["<C-'>"]    = "toggle-preview",
      ["<C-,>"]    = "toggle-preview-ccw",
      ["<C-.>"]    = "toggle-preview-cw",
      ["<S-down>"] = "preview-page-down",
      ["<S-up>"]   = "preview-page-up",
      ["<S-left>"] = "preview-page-reset",
    },
  },
  fzf_opts = {
    ['--cycle'] = '',
  },
  actions = {
    files = {
      ["default"] = fzf_lua.actions.file_edit,
    },
  },
  files = {
    cmd = 'find_for_vim',
  },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --hidden --trim",
  }
})
