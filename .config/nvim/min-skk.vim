set encoding=utf-8
scriptencoding utf-8

set clipboard=unnamed

call plug#begin(stdpath('config') . '/plugged')
Plug 'vim-denops/denops.vim'
Plug 'vim-skk/denops-skkeleton.vim'
Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'delphinus/skkeleton_indicator.nvim'
call plug#end()

call ddc#custom#patch_global('sources', ['skkeleton'])
call ddc#custom#patch_global('sourceOptions', {
 \   '_': {
 \     'matchers': ['matcher_head'],
 \     'sorters': ['sorter_rank']
 \   },
 \   'skkeleton': {
 \     'mark': 'skkeleton',
 \     'matchers': ['skkeleton'],
 \     'sorters': []
 \   },
 \ })
call ddc#enable()

lua require('skkeleton_indicator').setup{}

imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)

" <TAB>/<S-TAB> completion.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? '<C-n>' :
  \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
  \ '<TAB>' : ddc#map#manual_complete()
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

call skkeleton#config({
  \   'eggLikeNewline': v:true,
  \   'globalJisyo': expand('~/.cache/skk/SKK-JISYO.L'),
  \ })

nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>wq :<C-u>wq<CR>
nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>Q :<C-u>quit!<CR>

colorscheme industry
