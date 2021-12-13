set clipboard+=unnamedplus
set expandtab
set foldcolumn=0
set ignorecase
set laststatus=0
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

nnoremap p p`[v`]=`]
nnoremap P P`[v`]=`]
nnoremap ]p p
nnoremap ]P P
nnoremap x "_d
nnoremap X "_D
nnoremap ' `

nnoremap gx :<C-u>!open <C-r><C-a>

nnoremap <Space>g <Cmd>copy.<CR>
nnoremap <Space>G <Cmd>copy-1<CR>
nnoremap <Space>o <Cmd>put =repeat(nr2char(10), v:count1)<CR>
nnoremap <Space>O <Cmd>put! =repeat(nr2char(10), v:count1)<CR>'[
nnoremap <Space>q <cmd>quit<CR>
nnoremap <Space>Q <cmd>quitall!<CR>
nnoremap <Space>w <cmd>w<CR>
nnoremap <Space>wq <cmd>wq<CR>
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
inoremap <silent> jj <ESC>
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

colorscheme industry

highlight Pmenu      ctermfg=254 ctermbg=237 guifg=#e3e1e4 guibg=#37343a
highlight PmenuSel   ctermfg=237 ctermbg=254 guifg=#37343a guibg=#e3e1e4
highlight PmenuSbar  ctermbg=238 guibg=#423f46
highlight PmenuThumb ctermbg=255 guibg=#f8f8f2

augroup min-edit
  autocmd!
  " https://zenn.dev/kawarimidoll/articles/5490567f8194a4
  autocmd FileType markdown syntax match markdownError '\w\@<=\w\@='

  autocmd InsertEnter *.tsv setlocal noexpandtab

  " https://jdhao.github.io/2020/05/22/highlight_yank_region_nvim/
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{timeout=500}
augroup END
