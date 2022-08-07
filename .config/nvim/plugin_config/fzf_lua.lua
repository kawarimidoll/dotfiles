local fzf_lua = require('fzf-lua')

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
    rg_opts = fzf_lua.config.get_global('grep.rg_opts') .. " --hidden --trim --glob '!**/.git/*'",
    actions = {
      ["ctrl-g"] = '',
      ["ctrl-l"] = { fzf_lua.actions.grep_lgrep },
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

local mru_cache = require('mru_cache')

local gen_mru_cmd = function(type)
  local file = mru_cache.cache_path(type)
  -- remove current file and cwd
  return "sed -e '\\|^" .. vim.api.nvim_buf_get_name(0) .. "$|d' -e 's|^"
      .. vim.fn.getcwd() .. "/||' " .. file
end
local gen_mru_opts = function(args)
  local file_actions = fzf_lua.defaults.actions.files
  file_actions.default = fzf_lua.actions.file_edit

  local opts = {
    previewer = "builtin",
    actions = file_actions,
    file_icons = true,
    color_icons = true
  }
  for k, v in pairs(args) do
    opts[k] = v
  end

  opts.fn_transform = function(x)
    return fzf_lua.make_entry.file(x, opts)
  end
  return opts
end

fzf_lua.mru = function(args)
  args.prompt = 'MRU> '
  local cmd = gen_mru_cmd('mru')
  local opts = gen_mru_opts(args)
  fzf_lua.fzf_exec(cmd, opts)
end

fzf_lua.mrw = function(args)
  args.prompt = 'MRW> '
  local cmd = gen_mru_cmd('mrw')
  local opts = gen_mru_opts(args)
  fzf_lua.fzf_exec(cmd, opts)
end
