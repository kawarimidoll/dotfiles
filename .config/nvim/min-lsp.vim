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
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('Shougo/dein.vim')
  call dein#add('vim-denops/denops.vim')

  call dein#add('Shougo/ddc.vim')
  call dein#add('Shougo/ddc-nvim-lsp.vim')
  call dein#add('Shougo/ddc-around')
  call dein#add('Shougo/ddc-matcher_head')
  call dein#add('Shougo/ddc-matcher_length')
  call dein#add('Shougo/ddc-sorter_rank')
  call dein#add('Shougo/ddc-nvim-lsp')
  call dein#add('neovim/nvim-lspconfig', {
        \ 'on_ft': ['typescript'],
        \ }
        \ )

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" Install not installed plugins on startup automatically
if dein#check_install()
  call dein#install()
endif

" call ddc#custom#patch_global('sources', ['nvim-lsp'])
call ddc#custom#patch_global('sources', ['around'])
call ddc#custom#patch_global('sourceOptions', {
  \   '_': {
  \     'ignoreCase': v:true,
  \     'matchers': ['matcher_head'],
  \     'sorters': ['sorter_rank'],
  \   },
  \   'around': {
  \     'mark': 'A',
  \     'matchers': ['matcher_head', 'matcher_length'],
  \   },
  \   'nvim-lsp': {
  \     'mark': 'lsp',
  \     'forceCompletionPattern': '\.\w*|:\w*|->\w*',
  \   },
  \ })
call ddc#custom#patch_filetype(
  \ ['typescript'], 'sources', ['nvim-lsp', 'around']
  \ )

" <TAB>/<S-TAB> completion.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? '<C-n>' :
  \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
  \ '<TAB>' : ddc#map#manual_complete()
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" [NeovimのBuiltin LSPを使ってみる - Qiita](https://qiita.com/slin/items/2b43925065de3b9a6d3b)
lua require'lspconfig'.denols.setup{}

" autocmd Filetype typescript setlocal omnifunc=v:lua.vim.lsp.omnifunc

"lsp.txtそのまま
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>

colorscheme industry

nnoremap <Space>q :<C-u>quitall<CR>
nnoremap <Space>Q :<C-u>only<CR>

set number
