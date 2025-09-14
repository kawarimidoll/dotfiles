let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']
" smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
" smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap j <BS>j
smap k <BS>k
" Keymap is <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-j>'
Keymap is <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
Keymap nx st <Plug>(vsnip-select-text)
Keymap nx sT <Plug>(vsnip-cut-text)
