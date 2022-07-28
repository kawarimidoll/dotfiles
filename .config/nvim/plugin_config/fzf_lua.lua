local fzf_lua = require('fzf-lua')
local actions = require('fzf-lua.actions')
local config = require('fzf-lua.config')

fzf_lua.setup({
  winopts = {
    height  = 0.90,
    width   = 0.90,
    row     = 0.35,
    col     = 0.50,
    preview = {
      vertical = 'down:60%',
      layout = 'vertical'
    },
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
  git = {
    status = {
      preview_pager = "delta --width=$FZF_PREVIEW_COLUMNS",
      -- actions     = {
      --   ["right"] = { actions.git_unstage, actions.resume },
      --   ["left"]  = { actions.git_stage, actions.resume },
      -- },
    },
  },
  grep = {
    rg_opts = config.get_global('grep.rg_opts') .. " --hidden --trim --glob '!**/.git/*'",
    actions = {
      ["ctrl-g"] = '',
      ["ctrl-l"] = { actions.grep_lgrep },
    },
  },
  oldfiles = {
    cwd_only = true,
  },
  blines = {
    fzf_opts = {
      -- hide line no.
      ["--with-nth"] = '4..',
    },
  },
})
