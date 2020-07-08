"-----------------
" Sets
"-----------------
set ambiwidth=double
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set clipboard=unnamed,autoselect
set cursorline
set display=lastline
set encoding=utf-8
set expandtab
set fenc=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set formatoptions=tcqmMj1
set helplang=ja
set hidden
set history=200
set hlsearch
set ignorecase
set incsearch
set infercase
set laststatus=2
set lazyredraw
set linebreak
set list
set listchars=tab:^-,trail:~,extends:»,precedes:«,nbsp:%
set matchtime=1
set nobackup
set nomodeline
set noshowmode
set noswapfile
set nowritebackup
set nrformats=
set number
set ruler
set scrolloff=5
set shiftround
set shiftwidth=2
set showcmd
set showmatch
set showtabline=2
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set switchbuf=usetab
set t_Co=256
set tabstop=2
set textwidth=0 " 自動改行しない
set title
set ttyfast
set whichwrap=b,s,h,l,<,>,[,],~
set wildmenu
set wildmode=list:longest,full
set wrap
set wrapscan
" if executable('rg')
"   set grepprg=rg\ --vimgrep\ --no-heading
"   set grepformat=%f:%l:%c:%m,%f:%l:%m
" endif

"-----------------
" Plugins
"-----------------
filetype plugin indent on
runtime macros/matchit.vim

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dense-analysis/ale'
Plug 'ervandew/supertab'
Plug 'haya14busa/is.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'itchyny/lightline.vim'
" Plug 'itchyny/vim-gitbranch'
Plug 'jacquesbh/vim-showmarks'
Plug 'jesseleite/vim-agriculture'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'lifepillar/vim-gruvbox8'
Plug 'markonm/traces.vim'
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'
Plug 'nelstrom/vim-qargs'
Plug 'sheerun/vim-polyglot'
Plug 'osyo-manga/vim-anzu'
Plug 'plasticboy/vim-markdown'
Plug 'previm/previm' " :PrevimOpenでmarkdownファイルをブラウザで表示、HMRつき
Plug 'sheerun/vim-polyglot'
Plug 'simeji/winresizer' " C-eで起動、hjklでカレントウィンドウのサイズを変更
Plug 'terryma/vim-expand-region'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tyru/open-browser.vim' " カーソル下の単語か選択範囲をブラウザで検索
Plug 'vim-jp/vimdoc-ja'
Plug 'vim-scripts/AnsiEsc.vim' " :AnsiEscでカラーデータを含むログファイルを色づけ
Plug 'Yggdroot/indentLine'

" Plug 'altercation/solarized'
" Plug 'cocopon/iceberg.vim'
" Plug 'cocopon/lightline-hybrid.vim'
" Plug 'freeo/vim-kalisi'
" Plug 'jacoborus/tender.vim'
" Plug 'nanotech/jellybeans.vim'
" Plug 'romainl/Apprentice'
" Plug 'sainnhe/sonokai'
" Plug 'sjl/badwolf'
" Plug 'tomasr/molokai'
" Plug 'volment/vim-colorblind-colorscheme'
" Plug 'w0ng/vim-hybrid'

call plug#end()

let g:closetag_filenames='*.html,*.vue'
let g:fzf_buffers_jump=1
let g:gruvbox_italics = 0
let g:gruvbox_italicize_strings = 0
let g:indentLine_leadingSpaceEnabled=1
let g:netrw_alto=1
let g:netrw_altv=1
let g:netrw_banner=0
let g:netrw_list_hide='^\.[^\.]'
let g:netrw_liststyle=3
let g:netrw_nogx=1 " netrwではopen-browserを無効化
let g:netrw_preview=1
let g:netrw_winsize=85
let g:vim_json_syntax_conceal=0
let g:vim_markdown_auto_insert_bullets=0
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_new_list_item_indent=0

let $FZF_DEFAULT_COMMAND='rg --files --follow --glob "!{.git,node_modules}/*" 2> /dev/null'
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case -g "!{*.lock,*-lock.json}"'.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:40%')
      \           : fzf#vim#with_preview('right:50%:hidden','?'),
      \   <bang>0)
" avoid to search file name: fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:40%')
augroup show_marks_sync
  autocmd!
  autocmd BufReadPost * silent! DoShowMarks
augroup END

"-----------------
" Key mappings
" :map  ノーマル、ビジュアル、選択、オペレータ待機
" :nmap ノーマル
" :vmap ビジュアル、選択
" :smap 選択
" :xmap ビジュアル
" :omap オペレータ待機
" :map! 挿入、コマンドライン
" :imap 挿入
" :lmap 挿入、コマンドライン、Lang-Arg
" :cmap コマンドライン
" :tmap 端末ジョブ
"-----------------
" その他マッピングについて
" s: デフォルトの挙動はclかxiで代用可能、押しやすい位置にあるので別機能にマッピングしたほうが良い
" t: オペレータ待機モードでは重要だがノーマルモードではf->hで補えるので潰しても良い
" m: a-zA-Zのマークを付けられるがそんなに大量に使えない、mmやmkなど押しやすいいくつかのマークのみを使うと決めそれ以外のmwとかmeとかを別の機能にマッピングしよう
" #,?: *,/とNで事足りるのでデフォルトの挙動は潰しても良い
let mapleader="\<space>"

" disable arrow keys
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" global
" map g/ <plug>(incsearch-stay)
map z/ <plug>(incsearch-fuzzy-/)
map z? <plug>(incsearch-fuzzy-?)
map zg/ <plug>(incsearch-fuzzy-stay)
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap H ^
noremap L $
noremap M %

" normal
nmap gx <plug>(openbrowser-smart-search)
nmap n <plug>(is-nohl)<plug>(anzu-n)zz
nmap N <plug>(is-nohl)<plug>(anzu-N)zz
map s <plug>(asterisk-z*)<plug>(is-nohl-1)<plug>(anzu-update-search-status)zz
" nmap S <plug>(asterisk-z#)<plug>(is-nohl-1)<plug>(anzu-update-search-status)zz
nnoremap S :%s/\V<c-r>///g<left><left>
map gs <plug>(asterisk-gz*)<plug>(is-nohl-1)<plug>(anzu-update-search-status)zz
" nmap gS <plug>(asterisk-gz#)<plug>(is-nohl-1)<plug>(anzu-update-search-status)zz
" nmap gS gs:%s/<c-r>///g<left><left>
nnoremap x "_x
nnoremap X "_X
" q to recode, Q to play
nnoremap Q @
nnoremap ? /\v
nnoremap == gg=G''
nnoremap <silent> <c-l> :<c-u>nohlsearch<cr><c-l>
" nnoremap <silent> p p`]
" nnoremap <silent> P P`]
" leader-s to repeat substitution
nnoremap <leader>s :&&<cr>
nnoremap <leader>r :registers<cr>
nnoremap <leader>w :write<cr>

nnoremap <c-k> "zdd<up>"zP
nnoremap <c-j> "zdd"zp

nnoremap [fzf] <nop>
nmap <leader>f [fzf]
nnoremap [fzf]f :Files<cr>
nnoremap [fzf]b :Buffers<cr>
nnoremap [fzf]m :Marks<cr>
nnoremap [fzf]r :Rg<cr>

" command
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
cnoremap <c-p> <up>
cnoremap <c-n> <down>
cnoremap <c-b> <left>
cnoremap <c-f> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <c-d> <del>

" insert
" このあたり改善の余地あり
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-j> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
inoremap <c-]> <esc><right>
inoremap <c-t> <esc><left>"zx"pa

" visual
vmap gx <plug>(openbrowser-smart-search)
vnoremap <silent> y y`]
vnoremap x "_x
" vnoremap <silent> p pgvy`]
" vnoremap <silent> P Pgvy`]
" xnoremap <expr> p 'pgv"'.v:register.'y`>'

vnoremap <c-k> "zd<up>"zP`[V`]
vnoremap <c-j> "zd"zp`[V`]

"-----------------
" Appearances
"-----------------
syntax enable

" augroup MyVimAppearances
"   autocmd!
"   autocmd ColorScheme * highlight LineNr ctermfg=darkyellow
" augroup END

" colorscheme elflord
colorscheme gruvbox8

let g:lightline={
      \ 'colorscheme': 'gruvbox8',
      \ 'active': {
      \   'left': [['mode', 'paste'], ['readonly', 'filename', 'modified']],
      \   'right': [['lineinfo', 'anzu'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
      \ },
      \ 'tabline': {
      \  'left': [['tabs']],
      \  'right': [['gitbranch']],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'anzu': 'anzu#search_status'
      \ },
      \ }

" 全角スペースの可視化 colorscheme以降に記述する
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=darkmagenta
endfunction
if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
  augroup END
  call ZenkakuSpace()
endif

"-----------------
" Auto Commands
"-----------------
augroup fileTypeSettings
  autocmd!
  autocmd BufNewFile,BufRead *.md set filetype=markdown
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

"-----------------
" Commands and Functions
"-----------------
command! Evimrc edit $MYVIMRC
command! Svimrc source $MYVIMRC

" [:SyntaxInfoでカラースキーム確認](http://cohama.hateblo.jp/entry/2013/08/11/020849)
function! s:get_syn_attr(synid)
  return "name: " . synIDattr(a:synid, "name") .
        \ ", ctermfg: " . synIDattr(a:synid, "fg", "cterm") .
        \ ", ctermbg: " . synIDattr(a:synid, "bg", "cterm") .
        \ ", guifg: " . synIDattr(a:synid, "fg", "gui") .
        \ ", guibg: " . synIDattr(a:synid, "bg", "gui")
endfunction
function! s:get_syn_info()
  let currentSyn = synID(line("."), col("."), 1)
  echo s:get_syn_attr(currentSyn)
  echo "link to"
  echo s:get_syn_attr(synIDtrans(currentSyn))
endfunction
command! SyntaxInfo call s:get_syn_info()

" [lightline.vimとvim-anzuで検索ヒット数を表示する - Qiita](https://qiita.com/shiena/items/f53959d62085b7980cb5)
augroup vim_anzu
  autocmd!
  autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()
augroup END

augroup vim_auto_reload
  autocmd!
  autocmd BufReadPost $MYVIMRC source $MYVIMRC
augroup END

" [Vimの生産性を高める12の方法 | POSTD](https://postd.cc/how-to-boost-your-vim-productivity/)
" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()
