"-----------------
" プラグイン
"-----------------
" 初期化
set nocompatible
filetype plugin on

" matchit.vim
runtime macros/matchit.vim

" netrw: tree view
let g:netrw_liststyle=3
" netrw: ヘッダ非表示
let g:netrw_banner=0
" netrw: 左右分割を右側に
let g:netrw_altv=1
" netrw: 分割サイズを85%に
let g:netrw_winsize=85

" vim-plugここから
" :PlugInstall でインストール
call plug#begin('~/.vim/plugged')

" Ruby用 endを自動挿入
Plug 'tpope/vim-endwise'

" <C-_><C-_>でコメントアウトON/OFF
Plug 'tomtom/tcomment_vim'

" インデント可視化
Plug 'nathanaelkane/vim-indent-guides'
" vim起動時に自動で有効化
let g:indent_guides_enable_on_vim_startup = 1

" :AnsiEscでカラーデータを含むファイルを色づけ
Plug 'vim-scripts/AnsiEsc.vim'

" :FixWhitespaceで行末の半角スペースを削除
Plug 'bronson/vim-trailing-whitespace'

" markdownファイルのシンタックスハイライト
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" :PrevimOpenでmarkdownファイルをブラウザで表示、HMRつき
Plug 'previm/previm'
autocmd BufRead,BufNewFile *.md set filetype=markdown

" ノーマルモードでカーソル下の単語、ビジュアルモードで選択範囲をブラウザで開くか検索する
Plug 'tyru/open-browser.vim'
" netrwではopen-browserを無効化
let g:netrw_nogx = 1
" キーマップはgx
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" markを可視化
Plug 'jacquesbh/vim-showmarks'
augroup show_marks_sync
  autocmd!
  autocmd BufReadPost * silent! DoShowMarks
augroup END

" C-d/C-u/C-f/C-b でのページ送りをスムーズにスクロールする
Plug 'yuttie/comfortable-motion.vim'
let g:comfortable_motion_interval = 2400.0 / 60
let g:comfortable_motion_friction = 100.0
let g:comfortable_motion_air_drag = 3.0

" :Goyo で Zen Mode
Plug 'junegunn/goyo.vim'

" tabキーで補完
Plug 'ervandew/supertab'

" 括弧を補完
Plug 'jiangmiao/auto-pairs'

" クォートなどの囲みの編集を強化
Plug 'tpope/vim-surround'

" C-eで起動、hjklでカレントウィンドウのサイズを変更、CRで確定
Plug 'simeji/winresizer'

" 閉じタグを自動補完
Plug 'alvan/vim-closetag'
let g:closetag_filenames = '*.html,*.vue'

" ステータスライン増強
Plug 'itchyny/lightline.vim'

" カラーテーマ
" Plug 'cocopon/iceberg.vim'
Plug 'w0ng/vim-hybrid'

call plug#end()
" vim-plugここまで

" カラーテーマ適用
colorscheme hybrid
" let g:lightline = {
"   \ 'colorscheme': 'hybrid',
"   \ }

"-----------------
" 練習用設定 矢印キーを無効にする 慣れたら「無効にする」のではなく別のキーにマッピングしよう！
"-----------------
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

"-----------------
" 基本設定
"-----------------
" 文字コードをUTF8に
set fenc=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

" 中間ファイルを作らない
set nobackup
set noswapfile

" 編集中のファイルが変更されたら自動で読み直す
set autoread

" 現在のバッファが編集中でも他のファイルを開けるようにする
set hidden

" vimからファイルを開くときにリストを表示
set wildmenu wildmode=list:full

"-----------------
" 入力補助
"-----------------
" C-p/C-nで履歴確認
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" バッファ移動 like as unimpaired.vim
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" パス入力時に%%でカレントディレクトリを展開
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

"-----------------
" 検索関連
"-----------------

" 検索がファイル末尾まで行ったら最初に戻る
set wrapscan

" インクリメンタルサーチ
set incsearch

" 検索結果をハイライト
set hlsearch

" 検索文字列が小文字のみのときは大文字小文字を区別しない
set ignorecase

" 検索文字列に大文字があれば区別する
set smartcase

" ESC連打で検索ハイライトを解除する
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>

"-----------------
"表示関連
"-----------------
" 対応する括弧を表示
set showmatch matchtime=1

" ステータスバーを常に表示
set laststatus=2

" --Insert-- などのモード表示をしない(プラグインに任せる)
set noshowmode

" 入力中のコマンドを表示
set showcmd

" 行を省略しない
set display=lastline

" ホワイトスペース可視化
set list
set listchars=tab:^\ ,trail:~

" 入力時Tabキーで半角スペース2つ
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

" 改行時に自動でインデント調整
set autoindent
set smartindent

" .pyファイルのみtab幅を4に
augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

" タイトル表示
set title
set titleold="Terminal"
set titlestring=%F

" 行番号表示
set number
" highlight LineNr ctermfg=darkyellow

" 現在位置を強調
set ruler
set cursorline
"set cursorcolumn

" 行末までカーソルを動かせるようにする
set virtualedit=onemore

" ヤンクでシステムのクリップボードにコピー
set clipboard=unnamed,autoselect

" シンタックスハイライト
syntax on

" 数を10進数として扱う(<C-a><C-x>で計算するときに効く)
set nrformats=

" 行をまたいで移動できるようにする
set whichwrap=b,s,h,l,<,>,[,],~

" 全角スペースの可視化
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction
if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
  augroup END
  call ZenkakuSpace()
endif
