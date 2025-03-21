vim.cmd.source(vim.fn.expand('~/dotfiles/.vim/vimrc'))

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'

local mini_path = path_package .. 'pack/deps/start/mini.nvim'
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echomsg "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echomsg "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify({ ERROR = { duration = 10000 } })
end)

now(function()
  require('mini.icons').setup()
end)

now(function()
  require('mini.git').setup()

  local align_blame = function(au_data)
    if au_data.data.git_subcommand ~= 'blame' then return end

    -- Align blame output with source
    local win_src = au_data.data.win_source
    vim.wo.wrap = false
    vim.fn.winrestview({ topline = vim.fn.line('w0', win_src) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

    -- Bind both windows so that they scroll together
    vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
  end

  local au_opts = { pattern = 'MiniGitCommandSplit', callback = align_blame }
  vim.api.nvim_create_autocmd('User', au_opts)

  vim.keymap.set(
    { 'n', 'x' },
    '<Leader>gs',
    '<Cmd>lua MiniGit.show_at_cursor()<CR>',
    { desc = 'Show at cursor' }
  )
end)

now(function()
  require('mini.statusline').setup({ set_vim_settings = false })
  vim.opt.laststatus = 3
  vim.opt.cmdheight = 0
end)

now(function()
  require('mini.tabline').setup({ set_vim_settings = false })
  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = '*',
    callback = function()
      -- `later` function is needed to ensure count is correct
      later(function()
        -- count loaded buffers
        -- if there are multiple buffers, show tabline
        -- otherwise, hide tabline
        local bufs_output = vim.api.nvim_exec2('buffers', { output = true })
        local loaded = vim.tbl_count(vim.split(bufs_output.output, '\n'))

        if loaded >= 2 then
          vim.opt.showtabline = 2
        else
          vim.opt.showtabline = 0
        end
      end)
    end,
  })
end)

local init_lsp = function()
  add({ source = 'neovim/nvim-lspconfig' })

  -- https://zenn.dev/vim_jp/articles/c62b397647e3c9
  vim.diagnostic.config({ severity_sort = true })

  vim.keymap.set('n', 'mxe', function()
    vim.diagnostic.open_float({ focusable = true })
  end, { desc = 'diagnostic.open_float' })
  vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = 'diagnostic.goto_next' })
  vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, { desc = 'diagnostic.goto_next' })
  -- vim.keymap.set('n', 'mxl', vim.diagnostic.setloclist, { desc = 'diagnostic.setloclist' })
  vim.keymap.set('n', 'mxq', vim.diagnostic.setqflist, { desc = 'diagnostic.setqflist' })

  -- :h lsp-attach
  vim.api.nvim_create_autocmd({ 'LspAttach' }, {
    callback = function(args)
      local c = vim.lsp.get_client_by_id(args.data.client_id)
      if c == nil or c.name == 'copilot' then
        return
      end

      local bufnr = args.buf

      local function buf_set_keymap(key, func, desc, ...)
        local rest = { ... }
        local need_xmap = rest[1]
        local mode = need_xmap and { 'n', 'x' } or 'n'
        local opts = { buffer = bufnr, desc = 'lsp.' .. desc }

        vim.keymap.set(mode, key, func, opts)
      end
      buf_set_keymap('gD', vim.lsp.buf.declaration, 'declaration')
      buf_set_keymap('gd', vim.lsp.buf.definition, 'definition')
      if args.file:match('%.vim$') then
        pcall(vim.keymap.del, 'n', 'K', { buffer = bufnr })
      end
      buf_set_keymap('gi', vim.lsp.buf.implementation, 'implementation')
      buf_set_keymap('mxh', vim.lsp.buf.signature_help, 'signature_help')
      buf_set_keymap('mxwa', vim.lsp.buf.add_workspace_folder, 'add_workspace_folder')
      buf_set_keymap('mxwr', vim.lsp.buf.remove_workspace_folder, 'remove_workspace_folder')
      buf_set_keymap('mxwl', function()
        vim.print(vim.lsp.buf.list_workspace_folders())
      end, 'list_workspace_folders')
      buf_set_keymap('mxd', vim.lsp.buf.type_definition, 'type_definition')
      buf_set_keymap('mxn', vim.lsp.buf.rename, 'rename')
      buf_set_keymap('mxc', vim.lsp.buf.code_action, 'code_action', true)
      buf_set_keymap('gr', vim.lsp.buf.references, 'references')
      buf_set_keymap('<space>i', function()
        vim.lsp.buf.format({ async = true })
      end, 'format', true)

      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client:supports_method('textDocument/inlayHint', bufnr) then
        vim.lsp.inlay_hint.enable(true, { bufnr })
        buf_set_keymap('mxi', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr }), { bufnr })
        end, 'toggle_inlay_hints')
      end
    end,
  })

  vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/lsp.lua')
end

local init_treesitter = function()
  local langs = {
    'astro',
    'bash',
    'css',
    'csv',
    'git_config',
    'git_rebase',
    'gitattributes',
    'gitignore',
    'go',
    'html',
    'javascript',
    'jq',
    'jsdoc',
    'json',
    'jsonc',
    'lua',
    'luadoc',
    'make',
    'markdown',
    'markdown_inline',
    'nix',
    'python',
    'ruby',
    'rust',
    'scss',
    'sql',
    'svelte',
    'toml',
    'tsv',
    'tsx',
    'typescript',
    'vim',
    'vue',
    'xml',
    'yaml',
    'zig',
  }

  -- https://zenn.dev/kawarimidoll/articles/18ee967072def7
  vim.treesitter.start = (function(wrapped)
    return function(bufnr, lang)
      lang = lang or vim.fn.getbufvar(bufnr or '', '&filetype')
      pcall(wrapped, bufnr, lang)
    end
  end)(vim.treesitter.start)

  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = {
      post_checkout = function()
        vim.cmd('TSUpdate')
      end,
    },
  })
  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup({
    ensure_installed = langs,
    highlight = { enable = true },
  })
end

now(init_lsp)
now(init_treesitter)

later(require('mini.bufremove').setup)
later(require('mini.cursorword').setup)
later(require('mini.indentscope').setup)
later(require('mini.surround').setup)
later(require('mini.comment').setup)
later(function()
  local animate = require('mini.animate')
  animate.setup({
    cursor = { enable = false },
    scroll = {
      -- Animate for 150 milliseconds with linear easing
      timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
    },
    resize = {
      -- Animate for 150 milliseconds with linear easing
      timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),

      -- Animate only if there are at least 3 windows
      subresize = animate.gen_subscroll.equal({
        predicate = function(sizes_from)
          return vim.tbl_count(sizes_from) >= 3
        end
      }),
    }
  })
end)

later(function()
  require('mini.ai').setup()
  vim.keymap.set({ 'x', 'o' }, 'i<space>', 'iW', { desc = 'in space' })
  vim.keymap.set({ 'x', 'o' }, 'a<space>', 'aW', { desc = 'around space' })
end)

later(function()
  require('mini.diff').setup({
    view = {
      signs = { add = '+', change = '~', delete = '-' },
    },
  })
end)

later(function()
  require('mini.visits').setup({
    list = {
      filter = function(item)
        return not item.path:match('^%.git/')
      end,
    },
  })
end)

later(function()
  require('mini.extra').setup()
  vim.keymap.set({ 'n' }, '<space>h', function()
    MiniExtra.pickers.visit_paths()
  end, { desc = 'mini.extra.visit_paths' })
  vim.keymap.set({ 'n', 'x' }, '<space>k', function()
    vim.schedule(function()
      MiniPick.set_picker_query({ '☆ ' })
    end)
    MiniExtra.pickers.keymaps({ mode = 'n' })
  end, { desc = 'mini.extra.keymaps' })

  for k, v in pairs(MiniExtra.pickers) do
    if type(v) == 'function' then
      local name = 'mini.extra.' .. k
      vim.keymap.set('n', '<Plug>(' .. name .. ')', v, { desc = '☆ ' .. name })
    end
  end
end)

later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = require('mini.extra').gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function()
  require('mini.trailspace').setup()
  vim.api.nvim_create_user_command('Trim', MiniTrailspace.trim, {})
end)

now(function()
  require('mini.misc').setup()
  MiniMisc.setup_restore_cursor()
  vim.api.nvim_create_user_command('Zoom', function()
    MiniMisc.zoom(0, {})
  end, {})
end)

later(function()
  require('mini.pick').setup({
    --mappings = { delete_char = '<c-h>' }
  })
  vim.ui.select = MiniPick.ui_select
  vim.keymap.set({ 'n' }, '<space>f', function()
    MiniPick.builtin.files({ tool = 'git' })
  end, { desc = 'mini.pick.files' })
  vim.keymap.set({ 'n' }, '<space>H', MiniPick.builtin.help, { desc = 'mini.pick.help' })
  local wipeout_cur = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end
  local buffer_mappings = { wipeout = { char = '<C-d>', func = wipeout_cur } }
  vim.keymap.set({ 'n' }, '<space>b', function()
    MiniPick.builtin.buffers({ include_current = false }, { mappings = buffer_mappings })
  end, { desc = 'mini.pick.buffers' })

  for k, v in pairs(MiniPick.builtin) do
    if type(v) == 'function' then
      local name = 'mini.pick.' .. k
      vim.keymap.set('n', '<Plug>(' .. name .. ')', v, { desc = '☆ ' .. name })
    end
  end
end)

later(function()
  require('mini.files').setup()
  vim.keymap.set({ 'n' }, '<space>F', MiniFiles.open, { desc = 'mini.files.open' })

  vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    pattern = '*',
    callback = function()
      require('mini.completion').setup({
        lsp_completion = {
          process_items = require('mini.fuzzy').process_lsp_items,
        },
      })
    end,
    once = true,
  })
end)

later(function()
  local vimrc_sid = vim.fn.getscriptinfo({ name = 'vimrc' })[1].sid
  local vimrc_q = '<SNR>' .. vimrc_sid .. '_(q)'
  local clue = require('mini.clue')
  clue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      { mode = 'n', keys = vimrc_q },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      { mode = 'i', keys = '<C-g>' },

      -- Space triggers
      { mode = 'n', keys = '<Space>' },
      { mode = 'n', keys = 's' },

      { mode = 'n', keys = 'm' },
      { mode = 'n', keys = 'mx', desc = 'lsp' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows({ submode_resize = true }),
      clue.gen_clues.z(),
    },
  })
  MiniClue.set_mapping_desc('n', vimrc_q .. 'o', 'only')
  MiniClue.set_mapping_desc('n', 'so', 'source')
  MiniClue.set_mapping_desc('n', 's/', 'substitute magic')
  MiniClue.set_mapping_desc('n', 's?', 'substitute nomagic')
end)

later(function()
  local palettes = {}
  local base16 = require('mini.base16')
  -- :h minischeme
  palettes.mini_default = base16.mini_palette('#112641', '#e2e98f', 75)
  palettes.minicyan = base16.mini_palette('#0A2A2A', '#D0D0D0', 50)
  -- green is from icon, gray is from icon but brightness down
  palettes.kawarimidoll = base16.mini_palette('#1f1d24', '#8fecd9', 75)
  palettes.harukawarimi = base16.mini_palette('#1f1d24', '#e68be7', 65)

  local scheme_names = vim.tbl_keys(palettes)
  vim.api.nvim_create_user_command('MiniScheme', function(opts)
    local key = opts.fargs[1]

    if vim.tbl_contains(scheme_names, key) then
      vim.g.scheme_name = key
    else
      math.randomseed(os.time())
      vim.g.scheme_name = scheme_names[math.random(#scheme_names)]
    end

    base16.setup({
      palette = palettes[vim.g.scheme_name],
      use_cterm = true,
    })
    vim.api.nvim_exec_autocmds('ColorScheme', {})
    vim.api.nvim_set_hl(0, 'VertSplit', { ctermbg = 'NONE', bg = 'NONE' })
  end, {
    nargs = '?',
    complete = function(arg_lead, _, _)
      return vim.tbl_filter(function(item)
        return vim.startswith(item, arg_lead)
      end, scheme_names)
    end,
  })
  if not vim.g.scheme_name then
    vim.cmd.MiniScheme()
  end
end)

later(function()
  add('rlane/pounce.nvim')
  vim.keymap.set({ 'n', 'x' }, 's;', require('pounce').pounce, { desc = 'pounce' })
  vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/pounce.lua')
end)

-- later(function()
--   add('vim-jp/vimdoc-ja')
-- end)

later(function()
  add('thinca/vim-quickrun')
  vim.g.quickrun_config = {
    ['_'] = {
      ['outputter/buffer/opener'] = 'new',
      ['outputter/buffer/close_on_empty'] = 1,
    },
  }
  vim.keymap.set({ 'n', 'x' }, 'so', '<cmd>QuickRun<cr>', { desc = 'QuickRun' })
end)

later(function()
  add({ source = 'monaqa/dial.nvim' })
  vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/dial.lua')
  vim.keymap.set({ 'x' }, 'g<C-a>', 'g<Plug>(dial-increment)', { desc = 'dial-increment' })
  vim.keymap.set({ 'x' }, 'g<C-x>', 'g<Plug>(dial-decrement)', { desc = 'dial-decrement' })
  vim.keymap.set({ 'n', 'x' }, '<C-a>', '<Plug>(dial-increment)')
  vim.keymap.set({ 'n', 'x' }, '<C-x>', '<Plug>(dial-decrement)')

  -- add({ source = 'simeji/winresizer' })
  -- vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  --   pattern = '*',
  --   callback = function()
  --     vim.keymap.set({ 'n' }, '<c-w><c-e>', '<Cmd>WinResizerStartResize<CR>')
  --   end,
  --   once = true,
  -- })
end)

later(function()
  add({ source = 'tyru/capture.vim' })
end)

later(function()
  add({ source = 'segeljakt/vim-silicon' })
  vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
    pattern = '*',
    callback = function()
      vim.cmd.source('~/dotfiles/.config/nvim/plugin_config/silicon.vim')
    end,
    once = true,
  })
end)

later(function()
  add({ source = 'tzachar/highlight-undo.nvim' })
  require('highlight-undo').setup()
end)

later(function()
  add({ source = 'zbirenbaum/copilot.lua' })
  require('copilot').setup({
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = '<c-g><c-cr>',
        accept_word = '<c-g><c-l>',
        accept_line = '<c-g><c-j>',
        next = '<c-g><c-n>',
        prev = '<c-g><c-p>',
        --   dismiss = "<C-]>",
      },
    },
  })
  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    pattern = '*',
    callback = function()
      vim.fn['mi#highlight#merge']('CopilotSuggestion Comment Underlined')
    end,
  })
  vim.fn['mi#highlight#merge']('CopilotSuggestion Comment Underlined')

  add({
    source = 'CopilotC-Nvim/CopilotChat.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  })
  local copilotChat = require('CopilotChat')
  copilotChat.setup({
    prompts = {
      Explain = { mapping = '<Plug>(copilotchat-explain)' },
      Tests = { mapping = '<Plug>(copilotchat-tests)' },
      Fix = { mapping = '<Plug>(copilotchat-fix)' },
      Optimize = { mapping = '<Plug>(copilotchat-optimize)' },
      Docs = { mapping = '<Plug>(copilotchat-docs)' },
      Commit = { mapping = '<Plug>(copilotchat-commit)' },
      CommitStaged = { mapping = '<Plug>(copilotchat-commit-staged)' },
    },
  })
  for _, k in ipairs(vim.tbl_keys(copilotChat.config.prompts)) do
    local name = 'copilotchat' .. string.gsub(k, '[A-Z]', '-%0'):lower()
    vim.keymap.set(
      'n',
      '<Plug>(' .. name .. ')',
      ':CopilotChat' .. k .. '<cr>',
      { desc = '☆ ' .. name }
    )
  end

  vim.api.nvim_create_user_command('Chat', function()
    vim.ui.input({ prompt = 'CopilotChat: ' }, function(input)
      if input ~= '' then
        copilotChat.ask(input)
      end
    end)
  end, { range = true })

  -- vim.cmd.AbbrevCmd('ccc CopilotChatCommit')
  -- vim.cmd.AbbrevCmd('cco CopilotChatOptimize')
  -- vim.cmd.AbbrevCmd('cce CopilotChatExplain')

  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = 'copilot-chat',
    callback = function()
      if #vim.api.nvim_list_wins() == 1 then
        vim.cmd.quit()
      end
    end,
  })
end)

later(function()
  add({ source = 'hrsh7th/nvim-insx' })
  vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    pattern = '*',
    callback = function()
      vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/insx.lua')
    end,
    once = true,
  })
end)

later(function()
  vim.cmd.luafile('~/dotfiles/.config/nvim/ui_input.lua')
end)

later(function()
  add({ source = 'https://github.com/tani/dmacro.nvim' })
  vim.keymap.set({ 'i', 'n' }, '<C-t>', '<Plug>(dmacro-play-macro)')
end)

later(function()
  -- https://eiji.page/blog/nvim-quicker-nvim-intro/
  add({ source = 'https://github.com/stevearc/quicker.nvim' })
  require('quicker').setup({
    keys = {
      {
        '>',
        function()
          require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
  })
end)

vim.api.nvim_create_user_command(
  'InitLua',
  'edit ' .. vim.fn.stdpath('config') .. '/minideps.lua',
  {}
)

-- https://zenn.dev/vim_jp/articles/20240304_ekiden_disable_plugin
local default_rtp = vim.opt.runtimepath:get()
vim.opt.runtimepath:remove(vim.env.VIMRUNTIME)
vim.cmd.source(vim.env.VIMRUNTIME .. '/filetype.lua')
vim.api.nvim_create_autocmd("SourcePre", {
  pattern = "*/plugin/*",
  once = true,
  callback = function()
    vim.opt.runtimepath = default_rtp
  end
})
