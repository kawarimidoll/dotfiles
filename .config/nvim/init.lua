-- cache init.lua
vim.loader.enable()

-- share clipboard with OS
vim.opt.clipboard:append('unnamedplus,unnamed')

-- use 2-spaces indent
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- scroll offset as 3 lines
vim.opt.scrolloff = 3

-- move the cursor to the previous/next line across the first/last character
vim.opt.whichwrap = 'b,s,h,l,<,>,[,],~'

-- wrap lines
vim.opt.wrap = true
vim.opt.showbreak = '↪'

vim.opt.title = true

local U = require('mi.utils')

-- augroup for this config file
local augroup = vim.api.nvim_create_augroup('init.lua', {})

-- wrapper function to use internal augroup
local function create_autocmd(event, opts)
  vim.api.nvim_create_autocmd(
    event,
    vim.tbl_extend('force', {
      group = augroup,
    }, opts)
  )
end

-- https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(event)
    local dir = vim.fs.dirname(event.file)
    local force = U.present(vim.v.cmdbang)
    if
      not vim.bool_fn.isdirectory(dir)
      and (force or vim.fn.confirm('"' .. dir .. '" does not exist. Create?', '&Yes\n&No') == 1)
    then
      vim.fn.mkdir(vim.fn.iconv(dir, vim.opt.encoding:get(), vim.opt.termencoding:get()), 'p')
    end
  end,
  desc = 'Auto mkdir to save file',
})

local function transparent_bg()
  -- make background transparent
  local hl_groups = {
    'Normal',
    'NormalNC',
    'NonText',
    'LineNr',
    'Folded',
    'EndOfBuffer',
    'TabLineFill',
    'NormalFloat',
    'FloatBorder',
  }
  for _, group in ipairs(hl_groups) do
    vim.api.nvim_set_hl(0, group, { ctermbg = 'NONE', bg = 'NONE' })
  end
end
create_autocmd('ColorScheme', {
  pattern = '*',
  callback = transparent_bg,
})

-- https://zenn.dev/kawarimidoll/articles/33cf46fae69809
create_autocmd('BufNewFile', {
  pattern = '*',
  callback = function(args)
    -- 開こうとしたファイル
    local fname = args.file

    -- ファイル名が前方一致するものを抽出
    -- かつ、`lock`を名前に含むものは除く
    local possible = vim.tbl_filter(function(v)
      return not v:match('lock')
    end, vim.fn.glob(fname .. '*', true, true))

    -- 候補がなければ終了
    if vim.tbl_isempty(possible) then
      return
    end

    -- 文字数でソートし、最初（最短）のものを質問なしで開く
    table.sort(possible, function(a, b)
      return #a < #b
    end)
    vim.schedule(function()
      vim.cmd.edit(possible[1])
      vim.cmd('bwipeout! #')
      if #possible > 1 then
        vim.notify('There are ' .. #possible .. ' files that match ' .. fname, vim.log.levels.INFO)
      end
    end)
  end,
})

-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

later(function()
  require('mi.commands')
end)

later(function()
  require('mi.keymaps')
end)

later(function()
  -- qをprefixに使う
  create_autocmd('RecordingEnter', {
    pattern = '*',
    callback = function()
      -- q以外のマクロは使わないので即終了
      if vim.fn.reg_recording() ~= 'q' then
        vim.cmd('normal! q')
        return
      end

      local buffer = vim.api.nvim_get_current_buf()
      -- vim.keymap.set('n', 'q', 'q', { nowait = true, buffer = buffer })
      -- HACK: mini.clueがbuffer mappingを上書きしてくるのでautocmd CursorMovedで設定する
      create_autocmd('CursorMoved', {
        pattern = '*',
        once = true,
        callback = function()
          vim.keymap.set('n', 'q', 'q', { nowait = true, buffer = buffer })
        end,
        desc = 'set stop-recording key',
      })
      create_autocmd('BufLeave', {
        pattern = '*',
        once = true,
        callback = function()
          vim.cmd('normal! q')
          vim.notify('stop recording', vim.log.levels.INFO)
        end,
        desc = 'stop recording when leaving buffer',
      })
      create_autocmd('RecordingLeave', {
        pattern = '*',
        once = true,
        callback = function()
          vim.keymap.del('n', 'q', { buffer = buffer })
        end,
        desc = 'delete q mapping when recording leave',
      })
    end,
  })

  vim.keymap.set('n', 'qq', 'qq', { desc = 'start rec' })
  vim.keymap.set('n', 'qo', '<cmd>only<cr>', { desc = 'only' })
  vim.keymap.set('n', 'qO', '<cmd>BufOnly<cr>', { desc = 'BufOnly' })
  vim.keymap.set('n', 'qt', '<c-^>', { desc = 'toggle buffer' })
  vim.keymap.set('n', 'qg', ':<c-u>global/^/normal ', { desc = 'global command' })
end)

later(function()
  local eager_cabbrev = require('mi.eager_cabbrev')
  eager_cabbrev('yep', 'echo "yeah"')
  eager_cabbrev('ec', 'echo')
  eager_cabbrev('ed', 'edit')
  eager_cabbrev('en', 'enew')
  eager_cabbrev('mes', 'messages')
  eager_cabbrev('mec', 'messages clear')
  eager_cabbrev('ss', '%s/')
  eager_cabbrev('qw', 'wq')
  eager_cabbrev('lup', 'lua =')
  eager_cabbrev('chat', 'CopilotChat')

  local function fname_and_move_cursor()
    local fname = vim.fn.expand('%')
    local ext = vim.fn.expand('%:e')
    local move_left = ext:len() > 0 and vim.fn['repeat']('<left>', ext:len() + 1) or ''
    return fname .. move_left
  end
  eager_cabbrev('sv', function()
    return 'Saveas ' .. fname_and_move_cursor()
  end)
  eager_cabbrev('rn', function()
    return 'Rename ' .. fname_and_move_cursor()
  end)
end)

now(function()
  require('mini.icons').setup()
end)

now(function()
  require('mini.basics').setup({
    options = {
      extra_ui = true,
    },
    mappings = {
      option_toggle_prefix = 'm',
    },
  })
  vim.opt.number = false
  vim.opt.cursorline = false
end)

later(function()
  add('https://github.com/vim-jp/vimdoc-ja')
  -- Prefer Japanese as the help language
  vim.opt.helplang:prepend('ja')
end)

later(function()
  require('mi.one_last_key').setup()
end)

now(function()
  require('mini.statusline').setup()

  MiniStatusline.section_mode = (function(wrapped)
    return function(args)
      local mode, hl = wrapped(args)
      local last_key = require('mi.one_last_key').get()
      if last_key and last_key ~= '' then
        mode = mode .. ' ' .. last_key
      end
      local rec = vim.fn.reg_recording()
      if rec == '' then
        return mode, hl
      end
      return mode .. ' @' .. rec, 'Error'
    end
  end)(MiniStatusline.section_mode)

  vim.opt.laststatus = 3
  vim.opt.cmdheight = 0
end)

now(function()
  require('mini.misc').setup()

  MiniMisc.setup_restore_cursor()

  vim.api.nvim_create_user_command('Zoom', function()
    MiniMisc.zoom(0, {})
  end, { desc = 'Zoom current buffer' })
  vim.keymap.set('n', 'mz', '<cmd>Zoom<cr>', { desc = 'Zoom current buffer' })
end)

now(function()
  require('mini.notify').setup()

  vim.notify = require('mini.notify').make_notify({})

  vim.api.nvim_create_user_command('NotifyHistory', function()
    MiniNotify.show_history()
  end, { desc = 'Show notify history' })
end)

later(function()
  -- local base16 = require('mini.base16')
  -- -- { background, foreground, accent chroma }
  -- local palette_args = vim.opt.background:get() == 'dark' and { '#0a2a2a', '#edf2f6', 75 }
  --   or { '#f1efef', '#1a1d1f', 85 }
  -- local palette = base16.mini_palette(palette_args[1], palette_args[2], palette_args[3])
  -- base16.setup({ palette = palette })

  -- add('https://github.com/futsuuu/vim-robot')
  -- vim.cmd.colorscheme('robot')
  -- later(function()
  --   -- robotのtablineの色がちょっと微妙なので変更
  --   vim.api.nvim_set_hl(0, 'MiniTablineCurrent', { link = 'Search' })
  -- end)

  add('https://github.com/scottmckendry/cyberdream.nvim')
  require('cyberdream').setup({
    variant = 'auto',
    transparent = true,
  })
  vim.cmd.colorscheme('cyberdream')

  -- vim.cmd.colorscheme('minicyan')
  -- overwrite highlight WinSeparator
  vim.api.nvim_set_hl(0, 'WinSeparator', { link = 'Comment' })
  -- call autocmd ColorScheme manually
  vim.api.nvim_exec_autocmds('ColorScheme', {})
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
      wip = hi_words({ 'WIP', 'Wip', 'wip' }, 'MiniHipatternsTodo'),
      note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
      -- Highlight hex color strings (`#rrggbb`) using that color
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

later(function()
  require('mini.cursorword').setup()
end)

later(function()
  require('mini.indentscope').setup()
end)

later(function()
  require('mini.trailspace').setup()

  vim.api.nvim_create_user_command('Trim', function()
    MiniTrailspace.trim()
    MiniTrailspace.trim_last_lines()
  end, { desc = 'Trim trailing space and last blank lines' })
end)

now(function()
  require('mini.sessions').setup()

  local function get_sessions(lead)
    -- ref: https://qiita.com/delphinus/items/2c993527df40c9ebaea7
    return vim
      .iter(vim.fs.dir(MiniSessions.config.directory))
      :map(function(v)
        local name = vim.fs.basename(v)
        return vim.startswith(name, lead) and name or nil
      end)
      :totable()
  end
  vim.api.nvim_create_user_command('SessionWrite', function(arg)
    local session_name = U.blank(arg.args) and vim.v.this_session or arg.args
    if U.blank(session_name) then
      vim.notify('No session name specified', vim.log.levels.WARN)
      return
    end
    vim.cmd('%argdelete')
    MiniSessions.write(session_name)
  end, { desc = 'Write session', nargs = '?', complete = get_sessions })

  vim.api.nvim_create_user_command('SessionDelete', function(arg)
    MiniSessions.select('delete', { force = arg.bang })
  end, { desc = 'Delete session', bang = true })

  vim.api.nvim_create_user_command('SessionLoad', function()
    MiniSessions.select('read', { verbose = true })
  end, { desc = 'Load session' })

  vim.api.nvim_create_user_command('SessionEscape', function()
    vim.v.this_session = ''
  end, { desc = 'Escape session' })

  vim.api.nvim_create_user_command('SessionReveal', function()
    if U.blank(vim.v.this_session) then
      vim.print('No session')
      return
    end
    vim.print(vim.fs.basename(vim.v.this_session))
  end, { desc = 'Reveal session' })
end)

local logo = [[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━ ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄ ▄▄   ▄▄ ━━━━━━━━
━━━━━━━━█  █  █ █       █       █  █ █  █  █  █▄█  █━━━━━━━━
━━━━━━━━█   █▄█ █    ▄▄▄█   ▄   █  █▄█  █  █       █━━━━━━━━
━━━━━━━━█       █   █▄▄▄█  █ █  █       █  █       █━━━━━━━━
━━━━━━━━█  ▄    █    ▄▄▄█  █▄█  █       █  █       █━━━━━━━━
━━━━━━━━█ █ █   █   █▄▄▄█       ██     ██  █ ██▄██ █━━━━━━━━
━━━━━━━━█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄█▄█   █▄█━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]
local _logo2 = [[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━┏┓┏━┓━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┏┓━━━━┏┓━┏┓━━━━━━━━
━━━━━━━┃┃┃┏┛━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┃┃━━━━┃┃━┃┃━━━━━━━━
━━━━━━━┃┗┛┛━┏━━┓━┏┓┏┓┏┓┏━━┓━┏━┓┏┓┏┓┏┓┏┓┏━┛┃┏━━┓┃┃━┃┃━━━━━━━━
━━━━━━━┃┏┓┃━┗━┓┃━┃┗┛┗┛┃┗━┓┃━┃┏┛┣┫┃┗┛┃┣┫┃┏┓┃┃┏┓┃┃┃━┃┃━━━━━━━━
━━━━━━━┃┃┃┗┓┃┗┛┗┓┗┓┏┓┏┛┃┗┛┗┓┃┃━┃┃┃┃┃┃┃┃┃┗┛┃┃┗┛┃┃┗┓┃┗┓━━━━━━━
━━━━━━━┗┛┗━┛┗━━━┛━┗┛┗┛━┗━━━┛┗┛━┗┛┗┻┻┛┗┛┗━━┛┗━━┛┗━┛┗━┛━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

now(function()
  require('mini.starter').setup({
    header = string.rep('\n', 7),
  })

  local function display_logo()
    local buf = vim.api.nvim_create_buf(false, true)
    -- local width = math.floor(vim.o.columns * 0.8)
    -- local height = math.floor(vim.o.lines * 0.8)
    local logo_lines = vim.split(vim.trim(logo), '\n')
    local line_widths = vim.tbl_map(function(line)
      return vim.fn.strdisplaywidth(line)
    end, logo_lines)
    local width = math.max(unpack(line_widths))
    local height = #logo_lines + 1
    local row = 2
    local col = math.floor((vim.o.columns - width) / 2)

    local focusable = false
    local winopts = {
      style = 'minimal',
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      border = 'none',
      focusable = focusable,
      noautocmd = true,
    }

    local win = vim.api.nvim_open_win(buf, focusable, winopts)
    vim.api.nvim_set_option_value('winblend', 100, { scope = 'local', win = win })
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { scope = 'local', buf = buf })

    local subcommands = {
      'middleout --center-movement-speed 0.8 --full-movement-speed 0.2',
      'slide --merge --movement-speed 0.8',
      'beams --beam-delay 5 --beam-row-speed-range 20-60 --beam-column-speed-range 8-12',
    }
    -- random pick subcommand
    math.randomseed(os.time())
    -- local subcommand = subcommands[3]
    local subcommand = subcommands[math.random(#subcommands)]
    local cmd = {
      'sh',
      '-c',
      'echo -e '
        .. vim.fn.shellescape(vim.trim(logo))
        .. ' | tte --anchor-canvas s '
        .. subcommand
        .. ' --final-gradient-direction diagonal',
    }
    vim.api.nvim_buf_call(buf, function()
      vim.fn.jobstart(cmd, {
        term = true,
        on_exit = function() end,
      })
    end)
    return { buf = buf, win = win }
  end

  create_autocmd('User', {
    pattern = 'MiniStarterOpened',
    callback = function()
      -- display logo
      local logo_info = display_logo()
      -- close logo
      local buf = vim.api.nvim_get_current_buf()
      create_autocmd('BufLeave', {
        buffer = buf,
        once = true,
        callback = function()
          vim.api.nvim_win_close(logo_info.win, true)
        end,
        desc = 'Close logo',
      })
    end,
    desc = 'Display logo when starter opened',
  })
end)

later(function()
  require('mini.pairs').setup()
end)

later(function()
  require('mini.surround').setup()
end)

later(function()
  local gen_ai_spec = require('mini.extra').gen_ai_spec
  require('mini.ai').setup({
    custom_textobjects = {
      e = gen_ai_spec.buffer(),
      d = gen_ai_spec.diagnostic(),
      i = gen_ai_spec.indent(),
      l = gen_ai_spec.line(),
      n = gen_ai_spec.number(),
      J = { { '()%d%d%d%d%-%d%d%-%d%d()', '()%d%d%d%d%/%d%d%/%d%d()' } },
    },
  })

  vim.keymap.set({ 'x', 'o' }, 'i<space>', 'iW', { desc = 'in space' })
  vim.keymap.set({ 'x', 'o' }, 'a<space>', 'aW', { desc = 'around space' })
end)

now(function()
  local js_like_types = {
    'javascript',
    'javascript.jsx',
    'javascriptreact',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
  }

  create_autocmd('FileType', {
    pattern = js_like_types,
    callback = function()
      -- surround
      vim.b.minisurround_config = vim.tbl_deep_extend('force', vim.b.minisurround_config or {}, {
        custom_surroundings = {
          s = {
            input = { '${().-()}' },
            output = { left = '${', right = '}' },
          },
          g = {
            input = { '%f[%w_%.][%w_%.]+%b<>', '^.-<().*()>$' },
            output = function()
              local generics_name = require('mini.surround').user_input('Generics name')
              if generics_name == nil then
                return nil
              end
              return { left = generics_name .. '<', right = '>' }
            end,
          },
        },
      })

      -- ai
      vim.b.miniai_config = vim.tbl_deep_extend('force', vim.b.miniai_config or {}, {
        custom_textobjects = {
          s = { '${().-()}' },
          g = { '%f[%w_%.][%w_%.]+%b<>', '^.-<().*()>$' },
        },
      })
    end,
    desc = 'Local setting for js-like filetypes',
  })
end)

later(function()
  local function mode_nx(keys)
    return { mode = 'n', keys = keys }, { mode = 'x', keys = keys }
  end
  local clue = require('mini.clue')
  clue.setup({
    triggers = {
      -- Leader triggers
      mode_nx('<leader>'),

      -- Built-in completion
      { mode = 'i', keys = '<c-x>' },

      -- `g` key
      mode_nx('g'),

      -- Marks
      mode_nx("'"),
      mode_nx('`'),

      -- Registers
      mode_nx('"'),
      { mode = 'i', keys = '<c-r>' },
      { mode = 'c', keys = '<c-r>' },

      -- Window commands
      { mode = 'n', keys = '<c-w>' },

      -- bracketed commands
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },

      -- `z` key
      mode_nx('z'),

      -- surround
      mode_nx('s'),

      -- text object
      { mode = 'x', keys = 'i' },
      { mode = 'x', keys = 'a' },
      { mode = 'o', keys = 'i' },
      { mode = 'o', keys = 'a' },

      -- option toggle (mini.basics)
      { mode = 'n', keys = 'm' },

      -- `q` key
      { mode = 'n', keys = 'q' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers({ show_contents = true }),
      clue.gen_clues.z(),
      clue.gen_clues.windows({ submode_resize = true, submode_move = true }),
      { mode = 'n', keys = 'mm', desc = '+mini.map' },
    },
  })
end)

now(function()
  add('https://github.com/neovim/nvim-lspconfig')

  -- https://github.com/neovim/neovim/discussions/26571#discussioncomment-11879196
  -- https://github.com/lttb/gh-actions-language-server
  vim.filetype.add({
    pattern = {
      ['compose.*%.ya?ml'] = 'yaml.docker-compose',
      ['docker%-compose.*%.ya?ml'] = 'yaml.docker-compose',
      ['.*/%.github[%w/]+workflows[%w/]+.*%.ya?ml'] = 'yaml.github-actions',
      ['.*/ghostty/config'] = 'conf',
    },
  })

  require('mi.lsp')
end)

later(function()
  require('mini.fuzzy').setup()
  require('mini.completion').setup({
    lsp_completion = {
      process_items = MiniFuzzy.process_lsp_items,
    },
  })

  -- improve fallback completion
  vim.opt.complete = { '.', 'w', 'k', 'b', 'u' }
  vim.opt.completeopt:append('fuzzy')
  vim.opt.dictionary:append('~/.cache/vim/sorted_words')

  require('mini.snippets').setup({
    mappings = {
      jump_prev = '<c-k>',
    },
  })

  local map_multistep = require('mini.keymap').map_multistep
  -- NOTE: this will never insert tab, press <c-v><tab> for that
  local tab_steps = {
    'minisnippets_next',
    'minisnippets_expand',
    'pmenu_next',
    'jump_after_tsnode',
    'jump_after_close',
  }
  map_multistep('i', '<tab>', tab_steps)
  local shifttab_steps = {
    'minisnippets_prev',
    'pmenu_prev',
    'jump_before_tsnode',
    'jump_before_open',
  }
  map_multistep('i', '<s-tab>', shifttab_steps)
  map_multistep('i', '<bs>', { 'minipairs_bs', 'hungry_bs' })

  local function has_trailing_word_after_completion()
    if vim.fn.complete_info({ 'selected' }).selected == -1 then
      -- complete item is NOT selected
      return false
    end
    local char_at_cursor = U.get_cursor_neighbor().char_at_cursor
    local iskeyword = vim.regex('\\k'):match_str(char_at_cursor)
    return iskeyword ~= nil
  end
  local function pmenu_accept_and_remove_trailing_word()
    return '<c-y><c-o>"_de'
  end

  map_multistep('i', '<cr>', {
    {
      condition = has_trailing_word_after_completion,
      action = pmenu_accept_and_remove_trailing_word,
    },
    'pmenu_accept',
    'minipairs_cr',
  })
end)

local function close_extui_wins()
  local ok, extui_shared = pcall(require, 'vim._extui.shared')
  if not ok or type(extui_shared.wins) ~= 'table' then
    return
  end
  for _, win_type in ipairs({ 'cmd', 'dialog', 'msg', 'pager' }) do
    local win = extui_shared.wins[win_type]
    if win then
      vim.api.nvim_win_set_config(win, { hide = true })
    end
  end
end
later(function()
  local map_combo = require('mini.keymap').map_combo
  map_combo({ 'n', 'x' }, 'ww', '}')
  map_combo({ 'n', 'x' }, 'bb', '{')
  map_combo({ 'n', 'i', 'x', 'c' }, '<esc><esc>', function()
    close_extui_wins()
    vim.cmd.nohlsearch()
    vim.cmd.diffupdate()
    return '<c-l>'
  end)
  map_combo({ 'i', 'c' }, 'jk', '<bs><bs><esc>')
  map_combo({ 'i', 'c' }, 'kj', '<bs><bs><esc>')
end)

later(function()
  require('mini.tabline').setup()
end)

later(function()
  require('mini.bufremove').setup()

  vim.api.nvim_create_user_command('Bufdelete', function()
    MiniBufremove.delete()
  end, { desc = 'Remove buffer' })
  vim.keymap.set('n', '<space>d', function()
    MiniBufremove.delete()
  end, { desc = 'Remove buffer' })
end)

now(function()
  require('mini.files').setup()

  vim.api.nvim_create_user_command('Files', function()
    MiniFiles.open()
  end, { desc = 'Open file exproler' })
  vim.keymap.set('n', '<space>e', '<cmd>Files<cr>', { desc = 'Open file exproler' })
end)

later(function()
  require('mini.pick').setup()

  vim.ui.select = MiniPick.ui_select

  vim.keymap.set('n', '<space>f', function()
    MiniPick.builtin.files({ tool = 'git' })
  end, { desc = 'mini.pick.files' })

  vim.keymap.set('n', '<space>b', function()
    local wipeout_cur = function()
      vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
    end
    local buffer_mappings = { wipeout = { char = '<c-d>', func = wipeout_cur } }
    MiniPick.builtin.buffers({ include_current = false }, { mappings = buffer_mappings })
  end, { desc = 'mini.pick.buffers' })

  require('mini.visits').setup()
  vim.keymap.set('n', '<space>h', function()
    require('mini.extra').pickers.visit_paths()
  end, { desc = 'mini.extra.visit_paths' })

  vim.keymap.set('c', 'h', function()
    if vim.fn.getcmdtype() .. vim.fn.getcmdline() == ':h' then
      return '<c-u>Pick help<cr>'
    end
    return 'h'
  end, { expr = true, desc = 'mini.pick.help' })
end)

later(function()
  require('mini.diff').setup({
    view = {
      signs = { add = '+', change = '~', delete = '-' },
    },
  })
end)

later(function()
  require('mini.git').setup()

  vim.keymap.set({ 'n', 'x' }, '<space>gs', MiniGit.show_at_cursor, { desc = 'Show at cursor' })
end)

later(function()
  require('mini.operators').setup({
    replace = { prefix = 'R' },
    exchange = { prefix = 'g/' },
  })

  vim.keymap.set('n', 'RR', 'R', { desc = 'Replace mode' })
end)

later(function()
  require('mini.jump').setup({
    delay = {
      idle_stop = 10,
    },
  })
end)

later(function()
  -- require('mini.jump2d').setup()
  add('https://github.com/rlane/pounce.nvim')
  vim.keymap.set({ 'n', 'x', 'o' }, 'g;', function()
    vim.cmd.nohlsearch()
    require('pounce').pounce({})
  end)
  vim.api.nvim_set_hl(0, 'PounceUnmatched', { link = 'Comment' })
end)

-- later(function()
--   local animate = require('mini.animate')
--   animate.setup({
--     cursor = {
--       -- Animate for 100 milliseconds with linear easing
--       timing = animate.gen_timing.linear({ duration = 100, unit = 'total' }),
--     },
--     scroll = {
--       -- Animate for 150 milliseconds with linear easing
--       timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
--     }
--   })
-- end)

later(function()
  require('mini.bracketed').setup({
    undo = { suffix = '' }, -- disable
  })
end)

later(function()
  require('mini.splitjoin').setup({
    mappings = {
      toggle = 'gS',
      split = 'ss',
      join = 'sj',
    },
  })
end)

later(function()
  require('mini.move').setup()
end)

later(function()
  require('mini.align').setup()
end)

later(function()
  local map = require('mini.map')
  map.setup({
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diff(),
      map.gen_integration.diagnostic(),
    },
    symbols = {
      scroll_line = '▶',
    },
  })
  vim.keymap.set('n', 'mmf', MiniMap.toggle_focus, { desc = 'MiniMap.toggle_focus' })
  vim.keymap.set('n', 'mms', MiniMap.toggle_side, { desc = 'MiniMap.toggle_side' })
  vim.keymap.set('n', 'mmt', MiniMap.toggle, { desc = 'MiniMap.toggle' })
end)

later(function()
  -- avoid error
  vim.treesitter.start = (function(wrapped)
    return function(bufnr, lang)
      lang = lang or vim.fn.getbufvar(bufnr or '', '&filetype')
      pcall(wrapped, bufnr, lang)
    end
  end)(vim.treesitter.start)

  add({
    source = 'https://github.com/nvim-treesitter/nvim-treesitter',
    hooks = {
      post_checkout = U.noarg(vim.cmd.TSUpdate),
    },
  })
  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup({
    -- auto-install parsers
    ensure_installed = { 'lua', 'vim', 'tsx' },
    highlight = { enable = true },
  })
end)

now(function()
  add('https://github.com/andymass/vim-matchup')
end)

later(function()
  add({
    source = 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',
    depends = { 'nvim-treesitter/nvim-treesitter' },
  })
  require('ts_context_commentstring').setup({})
end)

later(function()
  vim.keymap.set(
    'n',
    '?',
    '<cmd>silent vimgrep//gj%|cwindow<cr>',
    { desc = 'Populate latest search result to quickfix list' }
  )

  -- use rg for external-grep
  vim.opt.grepprg = table.concat({
    'rg',
    '--vimgrep',
    '--trim',
    '--hidden',
    [[--glob='!.git']],
    [[--glob='!*.lock']],
    [[--glob='!*-lock.json']],
    [[--glob='!*generated*']],
  }, ' ')
  vim.opt.grepformat = '%f:%l:%c:%m'

  -- ref: `:NewGrep` in `:help grep`
  vim.api.nvim_create_user_command('Grep', function(arg)
    local grep_cmd = 'silent grep! '
      .. (arg.bang and '--fixed-strings -- ' or '')
      .. vim.fn.shellescape(arg.args, true)
    vim.cmd(grep_cmd)
    if vim.fn.getqflist({ size = true }).size > 0 then
      vim.cmd.copen()
    else
      vim.notify('no matches found', vim.log.levels.WARN)
      vim.cmd.cclose()
    end
  end, { nargs = '+', bang = true, desc = 'Enhounced grep' })

  vim.keymap.set('n', '<space>/', ':Grep ', { desc = 'Grep' })
  vim.keymap.set('n', '<space>?', ':Grep <c-r><c-w>', { desc = 'Grep current word' })
  vim.keymap.set('x', '<space>?', function()
    local word = table.concat(U.get_current_selection(), ' ')
    return ':<c-u>Grep! ' .. vim.fn.escape(word, [[ \]])
  end, { desc = 'Grep current word', expr = true })
end)

later(function()
  add('https://github.com/stevearc/quicker.nvim')
  local quicker = require('quicker')
  vim.keymap.set('n', 'mq', function()
    quicker.toggle()
    quicker.refresh()
  end, { desc = 'Toggle quickfix' })
  quicker.setup({
    keys = {
      {
        '>',
        function()
          quicker.expand({ before = 2, after = 2, add_to_existing = true })
        end,
        desc = 'Expand quickfix context',
      },
      { '<', U.noarg(quicker.collapse), desc = 'Collapse quickfix context' },
    },
  })
end)

later(function()
  add('https://github.com/zbirenbaum/copilot.lua')

  require('copilot').setup({
    suggestion = {
      auto_trigger = true,
      hide_during_completion = false,
      keymap = {
        accept = '<c-e>',
        accept_word = '<c-g><c-e>',
        next = '<c-f>',
        prev = '<c-b>',
        dismiss = '<c-a>',
      },
    },
    filetypes = {
      markdown = true,
      gitcommit = true,
      ['*'] = function()
        -- disable for files with specific names
        local fname = vim.fs.basename(vim.api.nvim_buf_get_name(0))
        local disable_patterns = { 'env', 'conf', 'local', 'private' }
        return vim.iter(disable_patterns):all(function(pattern)
          return not string.match(fname, pattern)
        end)
      end,
    },
  })

  -- set CopilotSuggestion as underlined comment
  local hl = vim.api.nvim_get_hl(0, { name = 'Comment' })
  vim.api.nvim_set_hl(0, 'CopilotSuggestion', vim.tbl_extend('force', hl, { underline = true }))
end)

later(function()
  add({
    source = 'https://github.com/CopilotC-Nvim/CopilotChat.nvim',
    depends = {
      'https://github.com/nvim-lua/plenary.nvim',
      'https://github.com/zbirenbaum/copilot.lua',
    },
  })

  local default_prompts = require('CopilotChat.config.prompts')
  local in_japanese = 'なお、説明は日本語でお願いします。'
  require('CopilotChat').setup({
    prompts = vim.tbl_deep_extend('force', default_prompts, {
      Explain = { prompt = default_prompts.Explain.prompt .. in_japanese },
      Review = { prompt = default_prompts.Review.prompt .. in_japanese },
      Fix = { prompt = default_prompts.Fix.prompt .. in_japanese },
      Optimize = { prompt = default_prompts.Optimize.prompt .. in_japanese },
      TranslateJE = {
        prompt = 'Translate the selected text from English to Japanese if it is in English, or from Japanese to English if it is in Japanese. Please do not include unnecessary line breaks, line numbers, comments, etc. in the result.',
        system_prompt = 'You are an excellent Japanese-English translator. You can translate the original text correctly without losing its meaning. You also have deep knowledge of system engineering and are good at translating technical documents.',
        description = 'Translate text from Japanese to English or vice versa',
      },
    }),
  })

  vim.keymap.set(
    { 'n', 'x' },
    '<space>p',
    '<cmd>CopilotChatPrompt<cr>',
    { desc = 'Select CopilotChat predefined prompts' }
  )

  create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
      vim.opt_local.relativenumber = false
      vim.opt_local.number = false
      vim.opt_local.signcolumn = 'no'
      vim.opt_local.conceallevel = 0
      -- vim.opt_local.foldcolumn = '0'
    end,
  })
end)

later(function()
  -- @param mode string|nil One of `nil`, `'char'`, `'line'`, `'block'`, `'visual'`.
  _G.OperatorJoin = function(mode)
    if U.blank(mode) then
      vim.o.operatorfunc = 'v:lua.OperatorJoin'
      return 'g@'
    end
    vim.cmd('normal! `[v`]J')
  end
  vim.keymap.set(
    'n',
    'J',
    'v:lua.OperatorJoin()',
    { expr = true, silent = true, replace_keycodes = false, desc = 'Join lines' }
  )
end)

later(function()
  add('monaqa/dial.nvim')
  vim.cmd.luafile('~/dotfiles/.config/nvim/plugin_config/dial.lua')
  local dial_manipulate = require('dial.map').manipulate
  vim.keymap.set('n', '<C-a>', function()
    dial_manipulate('increment', 'normal')
  end, { desc = 'dial-increment' })
  vim.keymap.set('n', '<C-x>', function()
    dial_manipulate('decrement', 'normal')
  end, { desc = 'dial-decrement' })
  vim.keymap.set('n', 'g<C-a>', function()
    dial_manipulate('increment', 'gnormal')
  end, { desc = 'dial-increment' })
  vim.keymap.set('n', 'g<C-x>', function()
    dial_manipulate('decrement', 'gnormal')
  end, { desc = 'dial-decrement' })
  vim.keymap.set('v', '<C-a>', function()
    dial_manipulate('increment', 'visual')
  end, { desc = 'dial-increment' })
  vim.keymap.set('v', '<C-x>', function()
    dial_manipulate('decrement', 'visual')
  end, { desc = 'dial-decrement' })
  vim.keymap.set('v', 'g<C-a>', function()
    dial_manipulate('increment', 'gvisual')
  end, { desc = 'dial-increment' })
  vim.keymap.set('v', 'g<C-x>', function()
    dial_manipulate('decrement', 'gvisual')
  end, { desc = 'dial-decrement' })
end)

later(function()
  add('https://github.com/tyru/capture.vim')
end)

-- later(function()
--   add('https://github.com/kdheepak/lazygit.nvim')
--   vim.keymap.set('n', '<space>L', '<c-l><cmd>nohlsearch<cr><cmd>LazyGit<cr>', { desc = 'LazyGit' })
-- end)

later(function()
  add('https://github.com/windwp/nvim-ts-autotag')
  ---@diagnostic disable-next-line: missing-fields
  require('nvim-ts-autotag').setup({
    opts = {
      enable_close = false, -- Auto close tags
      enable_rename = false, -- Auto rename pairs of tags
      enable_close_on_slash = true, -- Auto close on trailing </
    },
  })
end)

later(function()
  add('https://github.com/y3owk1n/undo-glow.nvim')
  _G.UndoGlow = require('undo-glow')
  UndoGlow.setup()
  vim.keymap.set('n', 'u', UndoGlow.undo, { desc = 'Undo with highlight' })
  vim.keymap.set('n', 'U', UndoGlow.redo, { desc = 'Redo with highlight' })
  vim.keymap.set(
    'n',
    'p',
    '<cmd>lua UndoGlow.paste_below()<cr>`]',
    { desc = 'Paste below with highlight' }
  )
  vim.keymap.set(
    'n',
    'P',
    '<cmd>lua UndoGlow.paste_above()<cr>`]',
    { desc = 'Paste above with highlight' }
  )
end)

later(function()
  add('https://github.com/akinsho/toggleterm.nvim')
  require('toggleterm').setup({
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
    end,
    float_opts = {
      width = function()
        return math.ceil(vim.o.columns * 0.9)
      end,
      height = function()
        return vim.o.lines - 4
      end,
    },
    open_mapping = [[<c-`>]],
    insert_mappings = false,
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    persist_size = true,
    direction = 'horizontal',
    close_on_exit = true,
  })

  create_autocmd({ 'TermOpen' }, {
    pattern = 'term://*',
    callback = function()
      vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Easy escape', buffer = true })
      vim.keymap.set('t', '<c-[><c-[>', '<c-\\><c-n>', { desc = 'Easy escape', buffer = true })
      local keys = { 'i', 'a', 'A', 'o', 'O' }
      for _, k in ipairs(keys) do
        vim.keymap.set('n', k, 'I', { desc = 'Enter terminal mode', buffer = true })
      end
    end,
    desc = 'Terminal keymaps',
  })

  -- default 'guicursor' includes 't:block-blinkon500-blinkoff500-TermCursor'
  vim.opt.guicursor:remove('t:block-blinkon500-blinkoff500-TermCursor')
  vim.opt.guicursor:append('t:block-TermCursor')

  -- https://github.com/akinsho/toggleterm.nvim#custom-terminal-usage
  local Terminal = require('toggleterm.terminal').Terminal
  local function create_tui(cmd, ex_command)
    local cmd_term = Terminal:new({
      cmd = cmd,
      dir = 'git_dir',
      direction = 'float',
      float_opts = { border = 'rounded' },
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd('startinsert!')
        vim.keymap.set('n', 'q', function()
          term:close()
        end, { desc = 'close ' .. cmd, buffer = term.bufnr, nowait = true, silent = true })
      end,
      -- function to run on closing the terminal
      on_close = function(_term)
        vim.cmd('startinsert!')
      end,
    })
    vim.api.nvim_create_user_command(ex_command, function()
      vim.cmd.normal('<c-l>')
      vim.cmd.nohlsearch()
      cmd_term:toggle()
    end, { desc = 'Toggle ' .. cmd })
  end
  create_tui('lazygit', 'Lazygit')
  vim.keymap.set('n', '<space>L', '<cmd>Lazygit<cr>', { desc = 'LazyGit', silent = true })
  create_tui('lazydocker', 'Lazydocker')
  vim.keymap.set('n', '<space>D', '<cmd>Lazydocker<cr>', { desc = 'LazyDocker', silent = true })
end)

later(function()
  add('https://github.com/stevearc/conform.nvim')
  local formatters_by_ft = {
    bash = { 'beautysh' },
    sh = { 'beautysh' },
    lua = { 'stylua' },
    proto = { 'buf' },
    sql = { 'sleek' },
    rust = { 'rustfmt' },
    toml = { 'dprint' },
    dockerfile = { lsp_format = 'prefer' },
    glsl = { lsp_format = 'prefer' },
    markdown = { 'deno_fmt' },
  }
  local web_formatters = { 'biome-check', 'prettier', stop_after_first = true }
  local web_targets = {
    'typescript',
    'javascript',
    'typescript.tsx',
    'javascript.jsx',
    'typescriptreact',
    'javascriptreact',
    'vue',
    'svelte',
    'json',
    'jsonc',
    'yaml',
    'html',
    'css',
    'scss',
    'less',
  }
  for _, target in ipairs(web_targets) do
    formatters_by_ft[target] = web_formatters
  end

  require('conform').setup({
    formatters = {
      dprint = {
        command = 'dprint',
        args = { 'fmt', '--config', '~/dotfiles/dprint.json', '--stdin', '$FILENAME' },
        cwd = function()
          return '.'
        end,
      },
      beautysh = {
        args = { '--indent-size', '2', '-' },
      },
    },
    formatters_by_ft = formatters_by_ft,
  })

  vim.keymap.set('n', '<space>i', require('conform').format, { desc = 'format buffer' })
end)

later(function()
  add('https://github.com/AndrewRadev/linediff.vim')
end)

later(function()
  add('https://github.com/tani/dmacro.vim')
  vim.keymap.set({ 'i', 'n' }, '<c-t>', '<plug>(dmacro-play-macro)')
end)

now(function()
  local ok, extui = pcall(require, 'vim._extui')
  if ok then
    extui.enable({
      enable = true, -- Whether to enable or disable the UI.
      msg = { -- Options related to the message module.
        ---@type 'cmd'|'msg' Where to place regular messages, either in the
        ---cmdline or in a separate ephemeral message window.
        target = 'msg',
        timeout = 4000, -- Time a message is visible in the message window.
      },
    })
  end
end)

now(function()
  local default_rtp = vim.opt.runtimepath:get()
  vim.opt.runtimepath:remove(vim.env.VIMRUNTIME)
  create_autocmd('SourcePre', {
    pattern = '*/plugin/*',
    once = true,
    callback = function()
      vim.opt.runtimepath = default_rtp
    end,
  })
end)
