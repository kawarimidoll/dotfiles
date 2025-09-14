require('noice').setup({
  history = {
    filter = { ['not'] = { kind = { 'search_count' } } },
  },
  views = {
    cmdline_popup = {
      position = {
        row = 5,
        col = '50%',
      },
      size = {
        width = 60,
        height = 'auto',
      },
    },
    popupmenu = {
      relative = 'editor',
      position = {
        row = 8,
        col = '50%',
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = 'rounded',
        padding = { 0, 1 },
      },
      win_options = {
        winhighlight = { Normal = 'Normal', FloatBorder = 'DiagnosticInfo' },
      },
    },
  },
  routes = {
    {
      filter = { event = 'msg_ruler' },
      opts = { skip = true },
    },
    {
      filter = { event = 'msg_show', kind = 'search_count' },
      opts = { skip = true },
    },
    {
      filter = {
        event = 'cmdline',
        find = '^%s*[/?]',
      },
      view = 'cmdline',
    },
  },
})
