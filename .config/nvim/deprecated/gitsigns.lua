require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~_' },
  },
  current_line_blame = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })
    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map({ 'n', 'v' }, 'mhs', gs.stage_hunk)
    map({ 'n', 'v' }, 'mhr', gs.reset_hunk)
    map('n', 'mhS', gs.stage_buffer)
    map('n', 'mhu', gs.undo_stage_hunk)
    map('n', 'mhR', gs.reset_buffer)
    map('n', 'mhp', gs.preview_hunk)
    map('n', 'mhb', function()
      gs.blame_line({ full = true })
    end)
    -- map('n', 'mtb', gs.toggle_current_line_blame)
    map('n', 'mhd', gs.diffthis)
    map('n', 'mhD', function()
      gs.diffthis('~')
    end)
    map('n', 'mht', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
})
