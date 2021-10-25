let $CACHE = expand('~/.cache')
if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" load secrets
if filereadable(expand('~/.secret_vimrc'))
  execute 'source' expand('~/.secret_vimrc')
endif

"-----------------
" dein scripts
"-----------------
if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
" if dein#load_state('$CACHE/dein')
  call dein#begin('$CACHE/dein')

  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/ddc.vim')
  call dein#add('vim-denops/denops.vim')
  call dein#add('vim-skk/denops-skkeleton.vim')
  call dein#add('Shougo/ddc-matcher_head')
  call dein#add('Shougo/ddc-sorter_rank')

  call dein#end()
  call dein#save_state()
" endif

filetype plugin indent on
syntax enable

" Install not installed plugins on startup automatically
if dein#check_install()
  call dein#install()
endif

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

imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)

" <TAB>/<S-TAB> completion.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? '<C-n>' :
  \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
  \ '<TAB>' : ddc#map#manual_complete()
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" function! s:skkeleton_init() abort
  call skkeleton#config({
    \   'eggLikeNewline': v:true,
    \   'globalJisyo': expand('~/.cache/skk/SKK-JISYO.L'),
    \ })
" endfunction
" autocmd User skkeleton-initialize-pre call s:skkeleton_init()

colorscheme industry
