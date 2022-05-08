let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_indent_on             = 1
" load ftplugin to set commentstring
" let g:did_load_ftplugin         = 1
let g:loaded_2html_plugin       = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

set ambiwidth=single
set breakindent
set breakindentopt=min:50,shift:4,sbr
set showbreak=↪
set clipboard&
set clipboard^=unnamed
set clipboard^=unnamedplus
set expandtab
set foldcolumn=0
set ignorecase
set laststatus=1
set nobackup
set nolist
set nomodeline
set nonumber
set noshowmode
set noswapfile
set nowritebackup
set scrolloff=5
set shiftwidth=2
set showtabline=0
set smartcase
set smartindent
set softtabstop=2
set tabstop=2
set whichwrap=b,s,h,l,<,>,[,],~
set wildmenu
set wrap
set wrapscan

noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap gV `[v`]
noremap H ^
noremap L $
map M %

nnoremap S :%s/\V<C-r>///g<Left><Left>
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q qq
nnoremap Q @q

nnoremap p ]p`]
nnoremap P [P`]
nnoremap gp p
nnoremap gP P
nnoremap x "_d
nnoremap X "_D
nnoremap ' `

" https://twitter.com/mo_naqa/status/1467626946293284865
nnoremap gf gF
nnoremap gx :<C-u>!open <C-r><C-a>

nnoremap <Space>g <Cmd>copy.<CR>
nnoremap <Space>G <Cmd>copy-1<CR>
nnoremap <Space>o <Cmd>put =repeat(nr2char(10), v:count1)<CR>
nnoremap <Space>O <Cmd>put! =repeat(nr2char(10), v:count1)<CR>'[
nnoremap <Space>q <cmd>confirm quit<CR>
nnoremap <Space>Q <cmd>quitall!<CR>
nnoremap <Space>w <cmd>w<CR>
nnoremap <Space>wq <cmd>wq<CR>
nnoremap <Space>; @:
nnoremap <silent><expr> <C-k> '<Cmd>move-1-' . v:count1 . '<CR>=l'
nnoremap <silent><expr> <C-j> '<Cmd>move+'   . v:count1 . '<CR>=l'
nnoremap <silent><C-l> :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>

" command
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-r><C-r> <C-r><C-r>*

" insert
inoremap <silent> <C-r><C-r> <C-r><C-r>*

" visual
xnoremap <silent> y y`]
xnoremap x "_x
xnoremap < <gv
xnoremap > >gv
xnoremap <silent><C-k> :m'<-2<CR>gv=gv
xnoremap <silent><C-j> :m'>+1<CR>gv=gv

" operator
onoremap x d

" terminal
tnoremap <C-w><C-n> <C-\><C-n>

colorscheme industry

highlight Reverse    cterm=reverse gui=reverse
highlight Pmenu      ctermfg=254 ctermbg=237 guifg=#e3e1e4 guibg=#37343a
highlight PmenuSel   ctermfg=237 ctermbg=254 guifg=#37343a guibg=#e3e1e4
highlight PmenuSbar  ctermbg=238 guibg=#423f46
highlight PmenuThumb ctermbg=255 guibg=#f8f8f2

augroup min-edit
  autocmd!
  " https://zenn.dev/kawarimidoll/articles/5490567f8194a4
  autocmd FileType markdown syntax match markdownError '\w\@<=\w\@='

  autocmd InsertEnter *.tsv setlocal noexpandtab

  if has('nvim')
    " https://jdhao.github.io/2020/05/22/highlight_yank_region_nvim/
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout=500 })
  endif
augroup END
