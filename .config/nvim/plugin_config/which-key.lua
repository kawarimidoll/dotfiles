local wk = require('which-key')

wk.setup()

-- :h ins-completion
wk.register({
  ['<C-l>'] = 'Whole lines',
  ['<C-n>'] = 'keywords in the current file',
  ['<C-k>'] = 'keywords in dictionary',
  ['<C-t>'] = 'keywords in thesaurus',
  ['<C-i>'] = 'keywords in the current and included files',
  ['<C-]>'] = 'tags',
  ['<C-f>'] = 'file names',
  ['<C-d>'] = 'definitions or macros',
  ['<C-v>'] = 'Vim command-line',
  ['<C-u>'] = 'User defined completion',
  ['<C-o>'] = 'omni completion',
  ['<C-s>'] = 'Spelling suggestions',
  ['<C-z>'] = 'stop completion',
  ['<C-g>'] = 'mini.completion force_twostep',
  ['<C-x>'] = 'mini.completion force_fallback',
}, {
  mode = 'i',
  prefix = '<C-x>',
})

wk.register({
  [vim.g.vimrc_snr .. '(q)d'] = 'TroubleToggle',
  [vim.g.vimrc_snr .. '(q)z'] = 'mini.zoom',
})

-- gitsigns
wk.register({
  ['s'] = 'gitsigns.stage_hunk',
  ['r'] = 'gitsigns.reset_hunk',
  ['S'] = 'gitsigns.stage_buffer',
  ['u'] = 'gitsigns.undo_stage_hunk',
  ['R'] = 'gitsigns.reset_buffer',
  ['p'] = 'gitsigns.preview_hunk',
  ['b'] = 'gitsigns.blame_line{full=true}',
  ['d'] = 'gitsigns.diffthis',
  ['D'] = "gitsigns.diffthis('~')",
  ['t'] = 'gitsigns.toggle_deleted',
}, {
  prefix = '<leader>h',
})
wk.register({
  ['s'] = 'gitsigns.stage_hunk',
  ['r'] = 'gitsigns.reset_hunk',
}, {
  mode = 'v',
  prefix = '<leader>h',
})
