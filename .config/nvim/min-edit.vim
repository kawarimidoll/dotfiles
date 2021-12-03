set encoding=utf-8
scriptencoding utf-8

set background=dark
set backspace=indent,eol,start
set clipboard+=unnamedplus
set foldcolumn=0
set nobackup
set nolist
set nomodeline
set nonumber
set noshowmode
set noswapfile
set nowritebackup
set showtabline=0
set whichwrap=b,s,h,l,<,>,[,],~
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

nnoremap p p`[v`]=`]
nnoremap P P`[v`]=`]
nnoremap ]p p
nnoremap ]P P
nnoremap x "_d
nnoremap xx "_dd
nnoremap X "_D
nnoremap Y y$
nnoremap ' `

nnoremap gx :<C-u>!open <C-r><C-a>

nnoremap <Space>g <Cmd>copy.<CR>
nnoremap <Space>G <Cmd>copy-1<CR>

nnoremap <Space>w <cmd>w<CR>
nnoremap <Space>wq <cmd>wq<CR>
nnoremap <Space>q <cmd>quit<CR>
nnoremap <Space>Q <cmd>quitall!<CR>
nnoremap <silent><expr> <C-k> ':<C-u>move-1-' . v:count1 . '<CR>=l'
nnoremap <silent><expr> <C-j> ':<C-u>move+' . v:count1 . '<CR>=l'
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
