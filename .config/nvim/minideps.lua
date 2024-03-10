vim.cmd.source(vim.fn.expand('~/dotfiles/.vim/vimrc'))

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'

local mini_path = path_package .. 'pack/deps/start/mini.nvim'
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echomsg "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
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

  add('nvim-tree/nvim-web-devicons')
  require('nvim-web-devicons').setup()

  require('mini.statusline').setup({ set_vim_settings = false })
  vim.opt.laststatus = 3

  require('mini.tabline').setup()
end)

local init_lsp = function()
  add({ source = 'neovim/nvim-lspconfig', depends = { 'williamboman/mason.nvim' } })

  vim.keymap.set('n', 'mxe', vim.diagnostic.open_float, { desc = 'diagnostic.open_float' })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'diagnostic.goto_next' })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'diagnostic.goto_next' })
  vim.keymap.set('n', 'mxl', vim.diagnostic.setloclist, { desc = 'diagnostic.setloclist' })

  -- :h LspAttach
  vim.api.nvim_create_autocmd({ 'LspAttach' }, {
    callback = function(args)
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
        pcall(vim.keymap.del, "n", "K", { buffer = bufnr })
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
      buf_set_keymap('<space>p', function()
        vim.lsp.buf.format({ async = true })
      end, 'format')
    end,
  })

  add({ source = 'williamboman/mason-lspconfig.nvim' })

  vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/lsp.lua')
end

local init_treesitter = function()
  local langs = { 'astro', 'bash', 'css', 'csv', 'git_config', 'git_rebase', 'gitattributes',
    'gitcommit', 'gitignore', 'go', 'html', 'javascript', 'jq', 'jsdoc', 'json', 'jsonc', 'lua',
    'luadoc', 'make', 'markdown_inline', 'nix', 'python', 'ruby', 'rust', 'scss', 'sql', 'svelte',
    'toml', 'tsv', 'tsx', 'typescript', 'vim', 'vimdoc', 'vue', 'xml', 'yaml', 'zig', }

  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup({
    ensure_installed = langs,
    highlight = { enable = true },
  })
end

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*',
  once = true,
  callback = function()
    init_lsp()
    init_treesitter()
  end
})

later(function()
  require('mini.ai').setup()
  require('mini.bufremove').setup()
  require('mini.cursorword').setup()
  require('mini.misc').setup()
  require('mini.indentscope').setup()
  require('mini.surround').setup()
  require('mini.comment').setup()
  require('mini.visits').setup()

  require('mini.extra').setup()

  local hipatterns = require('mini.hipatterns')
  hipatterns.setup({
    highlighters = {
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  require('mini.trailspace').setup()
  vim.api.nvim_create_user_command('Trim', MiniTrailspace.trim, {})

  require('mini.pick').setup({
    mappings = { delete_char = '<c-h>' }
  })
  vim.ui.select = MiniPick.ui_select
  vim.keymap.set({ 'n' }, '<space>f', function() MiniPick.builtin.files({ tool = 'git' }) end)
  vim.keymap.set({ 'n' }, '<space>H', MiniPick.builtin.help)
  local wipeout_cur = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end
  local buffer_mappings = { wipeout = { char = '<C-d>', func = wipeout_cur } }
  vim.keymap.set({ 'n' }, '<space>b', function()
    MiniPick.builtin.buffers({ include_current = false }, { mappings = buffer_mappings })
  end)

  require('mini.files').setup()
  vim.keymap.set({ 'n' }, '<space>F', MiniFiles.open)

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

  local clue = require('mini.clue')
  clue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- Space triggers
      { mode = 'n', keys = '<Space>' },

      -- LSP mappings
      { mode = 'n', keys = 'mx' },

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
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
    },
  })
end)

later(function()
  add('lewis6991/gitsigns.nvim')
  vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/gitsigns.lua')

  add('vim-jp/vimdoc-ja')

  add({ source = 'monaqa/dial.nvim' })
  vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/dial.lua')
  vim.keymap.set({ 'x' }, 'g<C-a>', 'g<Plug>(dial-increment)')
  vim.keymap.set({ 'x' }, 'g<C-x>', 'g<Plug>(dial-decrement)')
  vim.keymap.set({ 'n', 'x' }, '<C-a>', '<Plug>(dial-increment)')
  vim.keymap.set({ 'n', 'x' }, '<C-x>', '<Plug>(dial-decrement)')

  vim.api.nvim_create_autocmd({ 'WinEnter' }, {
    pattern = '*',
    callback = function()
      add({ source = 'simeji/winresizer' })
      vim.keymap.set({ 'n' }, '<c-w><c-e>', '<Cmd>WinResizerStartResize<CR>')
    end,
    once = true,
  })

  vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
    pattern = '*',
    callback = function()
      add({ source = 'segeljakt/vim-silicon' })
      vim.cmd.source('~/dotfiles/.config/nvim/plugin_config/silicon.vim')

      add({ source = 'tyru/capture.vim' })
    end,
    once = true,
  })

  add({ source = 'tzachar/highlight-undo.nvim' })
  require('highlight-undo').setup()

  add({ source = 'zbirenbaum/copilot.lua' })
  require("copilot").setup({
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = "<c-g><c-cr>",
        --   accept_word = false,
        --   accept_line = false,
        next = "<c-g><c-n>",
        prev = "<c-g><c-p>",
        --   dismiss = "<C-]>",
      },
    }
  })

  add({
    source = 'CopilotC-Nvim/CopilotChat.nvim',
    checkout = 'canary',
    depends = { 'nvim-lua/plenary.nvim' }
  })
  require("CopilotChat").setup()

  vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    pattern = '*',
    callback = function()
      add({ source = 'hrsh7th/nvim-insx' })
      vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/insx.lua')
    end,
    once = true,
  })

end)
