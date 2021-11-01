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

Plug 'Shougo/ddc-around'
Plug 'matsui54/ddc-dictionary'
Plug 'gamoutatsumi/ddc-emoji'
Plug 'kat0h/bufpreview.vim', { 'on': 'PreviewMarkdown' }
call plug#end()

setlocal dictionary+=/usr/share/dict/words
setlocal dictionary+=~/.cache/nvim/20k.txt
"
call ddc#custom#patch_global('sources', [
      \ 'skkeleton', 'around', 'emoji', 'dictionary'])
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
      \   'around': {'mark': 'A'},
      \   'emoji': {
      \     'mark': 'emoji',
      \     'matchers': ['emoji'],
      \     'sorters': [],
      \   },
      \   'dictionary': {'mark': 'D'},
      \ })

call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ 'dictionary': {
      \   'dictPaths': ['~/.cache/nvim/20k.txt','/usr/share/dict/words'],
      \   'smartCase': v:true,
      \   'showMenu': v:false,
      \ }
      \ })

call ddc#custom#patch_global('keywordPattern', '[a-zA-Z_:]\w*')

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

let s:jisyoPath = '~/.cache/nvim/SKK-JISYO.L'
if !filereadable(expand(s:jisyoPath))
  echo "SSK Jisyo does not exists! '" .
        \ s:jisyoPath . "' is required!"
  let s:jisyoDir = fnamemodify(s:jisyoPath, ':h')
  echo "Run: "
  echo "curl -OL http://openlab.jp/skk/dic/SKK-JISYO.L.gz"
  echo "gunzip SKK-JISYO.L.gz"
  echo "mkdir -p " . s:jisyoDir
  echo "mv ./SKK-JISYO.L " . s:jisyoDir

  let s:choice = confirm("Run automatically?", "y\nN")
  if s:choice == 1
    echo "Running..."
    call system("curl -OL http://openlab.jp/skk/dic/SKK-JISYO.L.gz")
    call system("gunzip SKK-JISYO.L.gz")
    call system("mkdir -p " . s:jisyoDir)
    call system("mv ./SKK-JISYO.L " . s:jisyoDir)
    echo "Done."
  endif
endif
call skkeleton#config({
  \   'eggLikeNewline': v:true,
  \   'globalJisyo': expand(s:jisyoPath),
  \ })

nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>wq :<C-u>wq<CR>
nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>Q :<C-u>quit!<CR>
inoremap qq <C-r>*

colorscheme industry
