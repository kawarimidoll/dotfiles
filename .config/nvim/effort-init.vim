set encoding=utf-8
scriptencoding utf-8
"  _       _ _         _
" (_)     (_) |       (_)
"  _ _ __  _| |___   ___ _ __ ___
" | | '_ \| | __\ \ / / | '_ ` _ \
" | | | | | | |_ \ V /| | | | | | |
" |_|_| |_|_|\__(_)_/ |_|_| |_| |_|

" @kawarimidoll
" https://twitter.com/kawarimidoll
" https://github.com/kawarimidoll

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
if dein#load_state('$CACHE/dein')
  call dein#begin('$CACHE/dein')
  call dein#load_toml('~/.config/nvim/dein.toml')
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" Install not installed plugins on startup automatically
if dein#check_install()
  call dein#install()
endif

"-----------------
" Options
"-----------------
set ambiwidth=single
set autoindent
set autoread
set autowrite
set background=dark
set backspace=indent,eol,start
set clipboard=unnamed
set cmdheight=2
set completeopt=longest,menu
set cursorline
set display=lastline
set expandtab
set fenc=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set fileformats=unix,dos,mac
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
set shortmess+=c
set signcolumn=yes
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set switchbuf=usetab
set t_Co=256
set tabstop=2
set textwidth=0
set title
set ttyfast
set updatetime=300
set whichwrap=b,s,h,l,<,>,[,],~
set wildmenu
set wildmode=list:longest,full
set wrap
set wrapscan

"-----------------
" Commands and Functions
"-----------------
command! Rcedit edit $MYVIMRC
command! Rcreload write | source $MYVIMRC | nohlsearch | redraw | echo 'init.vim is reloaded.'
command! Deinedit edit ~/.config/nvim/dein.toml
command! Deinupdate call dein#check_update(v:true)
" command! LazyGit tab terminal lazygit
" command! Lg LazyGit
" command! FmtTabTrail retab | FixWhitespace
" command! DenoFmt echo system("deno fmt --quiet ".expand("%:p")) | edit | echo 'deno fmt current file'
command! CopyFullPath let @*=expand('%:p') | echo 'copy full path'
command! CopyDirName  let @*=expand('%:h') | echo 'copy dir name'
command! CopyFileName let @*=expand('%:t') | echo 'copy file name'
command! -nargs=* T split | wincmd j | resize 12 | terminal <args>

" [Vimの生産性を高める12の方法 | POSTD](https://postd.cc/how-to-boost-your-vim-productivity/)
function! s:VisualPaste()
  let clipboard_options = split(&clipboard, ",")
  let restore_reg = index(clipboard_options, "unnamed") >= 0 ? @* : @"
  function! RestoreRegister() closure
    if index(clipboard_options, "unnamed") >= 0
      let @* = restore_reg
      if index(clipboard_options, "unnamedplus") >= 0
        let @+ = restore_reg
      endif
    else
      let @" = restore_reg
    endif
    return ''
  endfunction
  return "p@=RestoreRegister()\<CR>"
endfunction

" " [vimのマーク機能をできるだけ活用してみる - Make 鮫 noise](http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908)
" let g:mark_chars = ['h', 'j', 'k', 'l']
" function! s:AutoMark() abort
"   let b:mark_pos = exists('b:mark_pos') ? (b:mark_pos + 1) % len(g:mark_chars) : 0
"   execute 'normal! m' . g:mark_chars[b:mark_pos]
"   echo 'auto-marked' g:mark_chars[b:mark_pos]
" endfunction
" function! s:AutoJump() abort
"   if !exists('b:mark_pos')
"     echo 'not auto-marked yet.'
"     return
"   endif
"   execute 'normal! `' . g:mark_chars[b:mark_pos]
"   echo 'jumped to mark' g:mark_chars[b:mark_pos]
" endfunction
" 
" " [neovim terminal](https://gist.github.com/pocari/fd0622fb5ec6946a368e8ee0603979ae)
" " terminalの終了時にバッファを消すフック
" function! s:onTermExit(job_id, code, event) dict
"   " Process Exitが表示されたその後cr打つとバッファが無くなるので
"   " それと同じようにする
"   call feedkeys("\<CR>")
" endfun

" function! s:DenoRepl() abort
"   only | echo 'deno repl' | split | wincmd j | resize 12 | execute 'terminal deno'
" endfun
" command! -bang DenoRepl call s:DenoRepl()

function! s:DenoTerm() abort
  let l:filename = expand('%:p')
  let l:cmd = l:filename =~ '\(\.\|_\)\?test\.\(ts\|tsx\|js\|mjs\|jsx\)$'
   \ ? 'test' : 'run'
  only | echo '' | split | wincmd j | resize 12 |
   \ execute 'terminal deno ' . l:cmd .
   \ ' -A --no-check --unstable --watch ' . l:filename |
   \ stopinsert | execute 'normal! G' |
   \ set bufhidden=wipe | wincmd k
endfun
command! -bang DenoRun call s:DenoTerm()

" braces motion
" (count)+braces+action
" [ to effect prev, ] to effect next
" m to move, t to copy, o to add blank line
" use capital to fix cursor position
" nnoremap <silent><expr> [m ':<C-u>move-' . (v:count1 + 1) . '<CR>=l'
" nnoremap <silent><expr> ]m ':<C-u>move+' . v:count1 . '<CR>=l'
" nnoremap <silent><expr> [M ':<C-u>move-' . (v:count1 + 1) . '<CR>=l<Esc>' . v:count1 . 'j'
" nnoremap <silent><expr> ]M ':<C-u>move+' . v:count1 . '<CR>=l<Esc>' . v:count1 . 'k'
" nnoremap <silent><expr> [t ':<C-u>copy-' . v:count1 . '<CR>=l'
" nnoremap <silent><expr> ]t ':<C-u>copy+' . (v:count1 - 1) . '<CR>=l'
" nnoremap <silent><expr> [T 'mz:<C-u>copy-' . v:count1 . '<CR>=l<Esc>`z:<C-u>delmarks z<CR>'
" nnoremap <silent><expr> ]T 'mz:<C-u>copy+' . (v:count1 - 1) . '<CR>=l<Esc>`z:<C-u>delmarks z<CR>'
" nnoremap <silent><expr> [o '<Esc>' . v:count1 . 'O<Esc>' . (v:count ? v:count - 1 . 'k' : '')
" nnoremap <silent><expr> ]o '<Esc>' . v:count1 . 'o<Esc>'
" nnoremap <silent><expr> [O 'mz' . v:count1 . 'O<Esc>`z:<C-u>delmarks z<CR>'
" nnoremap <silent><expr> ]O 'mz' . v:count1 . 'o<Esc>`z:<C-u>delmarks z<CR>'
" xnoremap [m :<C-u>move'<-2<CR>gv=gv
" xnoremap ]m :<C-u>move'>+1<CR>gv=gv
" xnoremap [M :<C-u>move'<-2<CR>gv=gvj
" xnoremap ]M :<C-u>move'>+1<CR>gv=gvk
" xnoremap [t :<C-u>copy'<-2<CR>gv=gv
" xnoremap ]t :<C-u>copy'>+1<CR>gv=gv
" xnoremap [T :<C-u>copy'<-2<CR>gv=gvj
" xnoremap ]T :<C-u>copy'>+1<CR>gv=gvk

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

" global
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap gV `[v`]
noremap H ^
noremap L $
noremap [b :<C-u>bprevious<CR>
noremap ]b :<C-u>bnext<CR>
noremap [B :<C-u>bfirst<CR>
noremap ]B :<C-u>blast<CR>
noremap [q :<C-u>cprevious<CR>
noremap ]q :<C-u>cnext<CR>
noremap [Q :<C-u>cfirst<CR>
noremap ]Q :<C-u>clast<CR>
" map n <Plug>(anzu-n)zz
" map N <Plug>(anzu-N)zz
map M %
" " z*はssにマッピングするが通常のsの動作を潰すため1個の場合も登録しておく
" map s <Plug>(asterisk-z*)<Plug>(anzu-update-search-status)zz
" map ss <Plug>(asterisk-z*)<Plug>(anzu-update-search-status)zz
" map sg <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status)zz
" map <Space>ef <Plug>(easymotion-bd-f)
" map <Space>el <Plug>(easymotion-bd-jk)
" map <Space>ew <Plug>(easymotion-bd-w)

" for sandwich
" TODO: s to visual search
nmap s <Nop>
xmap s <Nop>

" normal
" nnoremap mm :<C-u>call <sid>AutoMark()<CR>
" nnoremap m, :<C-u>call <sid>AutoJump()<CR>
" nnoremap S :%s/\V<C-r>///g<Left><Left>
" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
" nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
" nnoremap <sid>(q)q :<C-u>call <sid>AutoRec()<CR>
" nnoremap <expr> Q <sid>AutoPlay()
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q qq
nnoremap Q @q
nnoremap p p`[v`]=`]
nnoremap P P`[v`]=`]
nnoremap ]p p
nnoremap ]P P
nnoremap x "_d
nnoremap xx "_dd
nnoremap X "_D
nnoremap Y y$

" [こだわりのmap](https://qiita.com/itmammoth/items/312246b4b7688875d023)
" カーソル下の単語をハイライト
nnoremap <silent> ss :let @/ = '\<' . expand('<cword>') . '\>'<CR>:set hlsearch<CR>
" 最新の検索文字列を置換
nmap sf :%s/<C-r>///g<Left><Left>
" nnoremap ' `
" nnoremap ? /\v
" nnoremap == gg=G''

" nmap gx <Plug>(openbrowser-smart-search)
" 
" " nnoremap <Space>a <C-w><C-w>
" nnoremap <Space>b :<C-u>Buffers<CR>
" nnoremap <Space>B :<C-u>BLines<CR>
" " nmap <Space>c <Plug>(caw:hatpos:toggle)
" " nnoremap <Space>C :<C-u>CaseToSelected<CR>
nnoremap <Space>d :<C-u>bdelete<CR>
" " nnoremap <Space>d :<C-u>Sayonara!<CR>
" nmap <Space>ef <Plug>(easymotion-overwin-f)
" nmap <Space>el <Plug>(easymotion-overwin-jk)
" nmap <Space>es <Plug>(easymotion-overwin-f2)
" nmap <Space>ew <Plug>(easymotion-overwin-w)
" nnoremap <Space>f :<C-u>Files<CR>
nnoremap <silent><Space>g :<C-u>copy.<CR>
nnoremap <silent><Space>G :<C-u>copy-1<CR>
" nnoremap <Space>h :<C-u>History<CR>
" " nnoremap <silent><Space>i mzviwbg~`z:<C-u>delmarks z<CR>
" " nmap <Space>j :SplitjoinJoin<CR>
" " nmap <Space>k :SplitjoinSplit<CR>
" nnoremap <Space>l :<C-u>Lines<CR>
" nnoremap <Space>m :<C-u>Marks<CR>
" nnoremap <silent> <Space>n :<C-u>write<CR>:QuickRun -mode n<CR>
nnoremap <silent><Space>o :<c-u>put =repeat(nr2char(10), v:count1)<cr>
nnoremap <silent><Space>O :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
" nnoremap <Space>p :<C-u>Format<CR>
" " nnoremap <Space>P :<C-u>Prettier<CR>
nnoremap <Space>q :<C-u>quit<CR>
" nnoremap <Space>Q :<C-u>only<CR>
" nnoremap <Space>r :<C-u>registers<CR>
" nnoremap <Space>s :<C-u>%s/
" nnoremap <Space>S :<C-u>&&<CR>
nnoremap <Space>t <C-^>
" nnoremap <Space>T <C-w><C-w>
" nnoremap <silent><Space>u mzviwg~`z:<C-u>delmarks z<CR>
" nnoremap <silent><Space>U mzviwbg~`z:<C-u>delmarks z<CR>
" nnoremap <Space>v :<C-u>Vista!!<CR>
" nnoremap <Space>V :<C-u>Vista finder fzf<CR>
nnoremap <Space>w :<C-u>write<CR>
nnoremap <Space>wq :<C-u>exit<CR>
" nnoremap <Space>x :<C-u>CocCommand explorer<CR>
" nnoremap <Silent> <Space>y  :<C-u>CocList -A --normal yank<CR>
" nnoremap <Space>z za
" nnoremap <Space>/ :<C-u>RgRaw -F -- $''<Left>
" nmap <Space>? <Plug>RgRawWordUnderCursor<Left>
" nnoremap <Space>; :<C-u>History/<CR>
" nnoremap <Space>: :<C-u>History:<CR>
" 
nnoremap <silent><expr> <C-k> ':<C-u>move-1-' . v:count1 . '<CR>=l'
nnoremap <silent><expr> <C-j> ':<C-u>move+' . v:count1 . '<CR>=l'
nnoremap <silent><C-l> :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
" nnoremap <C-w><C-q> <C-w>c
" 
" nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
" 
" " command
" cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-l> <C-r>+

" insert
inoremap <silent> jj <ESC>
inoremap <C-t> <Esc><Left>"zx"zpa

" visual
" xmap v <Plug>(expand_region_expand)
" xmap <C-v> <Plug>(expand_region_shrink)
xmap <Space>/ "zzy/<C-r>z
" vmap gx <Plug>(openbrowser-smart-search)
" xnoremap <silent> <Space>n :<C-u>write<CR>gv:QuickRun -mode n<CR>
" xnoremap <Space>w <Esc>:<C-u>write<CR>gv
" " xmap <Space>c <Plug>(caw:hatpos:toggle)
xnoremap <silent> <expr> p <sid>VisualPaste()
xnoremap <silent> y y`]
xnoremap x "_x
xnoremap < <gv
xnoremap > >gv

xnoremap <Space>g :t'>+0<CR>`[V`]
" xnoremap <silent><C-k> :m'<-2<CR>gv=gv
" xnoremap <silent><C-j> :m'>+1<CR>gv=gv
xnoremap <silent><C-k> :m'<-2<CR>gv
xnoremap <silent><C-j> :m'>+1<CR>gv

" operator
onoremap x d

" terminal
tnoremap <C-w><C-n> <C-w>N
tnoremap <Esc> <C-\><C-n>

"-----------------
" Abbreviations
"-----------------
cabbrev svs saveas %

"-----------------
" Appearances
"-----------------
syntax enable

" colorscheme sonokai

" tablineの項目はwinwidthを気にしなくて良い
" let g:lightline = {
"      \ 'colorscheme': 'sonokai',
"      \ 'active': {
"      \   'left': [['mode', 'paste'], ['coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok'],
"      \            ['gitgutter', 'filename', 'modified'], ['coc_status'], ['vista']],
"      \   'right': [['coc'], ['lineinfo', 'anzu'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
"      \ },
"      \ 'tabline': {
"      \  'left': [['tabs']],
"      \  'right': [['pwd']],
"      \ },
"      \ 'component': {
"      \   'fileencoding': '%{winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ""}',
"      \   'fileformat': '%{winwidth(0) > 70 ? &fileformat : ""}',
"      \   'filetype': '%{winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : "no ft") : ""}',
"      \   'mode': '%{winwidth(0) > 60 ? lightline#mode() : lightline#mode()[0]}',
"      \   'modified': '%{!&modifiable ? "RO" : &modified ? "+" : ""}',
"      \   'pwd': '%.35(%{fnamemodify(getcwd(), ":~")}%)',
"      \ },
"      \ 'component_function': {
"      \   'anzu': 'anzu#search_status',
"      \   'coc': 'coc#status',
"      \   'gitgutter': 'LightlineGitGutter',
"      \   'vista': 'LightlineVista',
"      \ },
"      \ }
" call lightline#coc#register()
" [lightline.vimをカスタマイズする - cafegale(LeafCage備忘録)](http://leafcage.hateblo.jp/entry/2013/10/21/lightlinevim-customize)
" [lightline.vim に乗り換えた - すぱぶろ](http://superbrothers.hatenablog.com/entry/2013/08/29/001326)
" function! LightlineGitGutter()
"   if !exists('*GitGutterGetHunkSummary')
"        \ || !get(g:, 'gitgutter_enabled', 0)
"     return ''
"   endif
"   let [a,m,r] = GitGutterGetHunkSummary()
"   let ret = ( a ? g:gitgutter_sign_added . a . ' ' : '' ) .
"        \ ( m ? g:gitgutter_sign_modified . m . ' ' : '' ) .
"        \ ( r ? g:gitgutter_sign_removed . r : '' )
"   return substitute(ret, " $", "", "")
" endfunction
" function! LightlineVista() abort
"   return get(b:, 'vista_nearest_method_or_function', '')
" endfunction

" 全角スペースの可視化 colorscheme以降に記述する
if has('syntax')
  let s:HighlightZenkakuSpace = {-> execute("highlight ZenkakuSpace cterm=reverse ctermfg=darkmagenta") }
  augroup vimrc_appearances
    autocmd!
    autocmd ColorScheme * call call( s:HighlightZenkakuSpace, [] )
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
  augroup END
  call call( s:HighlightZenkakuSpace, [] )
endif

highlight HighlightedyankRegion cterm=reverse gui=reverse

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  " plugin settings
  autocmd BufReadPost * silent! DoShowMarks
  " [lightline.vimとvim-anzuで検索ヒット数を表示する - Qiita](https://qiita.com/shiena/items/f53959d62085b7980cb5)
  " autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()

  " [vaffle.vim から netrw にお試しで移行してみた - bamch0h’s diary](https://bamch0h.hatenablog.com/entry/2019/06/24/004104)
  " autocmd FileType netrw nnoremap <buffer> h -
  " autocmd FileType netrw nnoremap <buffer> l <CR>
  " autocmd FileType netrw nnoremap <buffer> . gh

  " [close vista window automatically when it's the last window open](https://github.com/liuchengxu/vista.vim/issues/108)
  " autocmd BufEnter * if winnr("$") == 1 && vista#sidebar#IsOpen() | execute "normal! :q!\<CR>" | endif

  " autocmd BufWritePost $MYVIMRC source $MYVIMRC | echo 'vimrc is reloaded.'

  " 端末のバッファの名前を実行中プロセスを含むものに変更 https://qiita.com/acomagu/items/5f10ce7bcb2fcfc9732f
  autocmd BufLeave * if exists('b:term_title') && exists('b:terminal_job_pid') | execute ":file term" . b:terminal_job_pid . "/" . b:term_title

  " file type settings
  autocmd BufNewFile,BufRead .env* set filetype=env
  autocmd BufNewFile,BufRead git-__* set filetype=bash
  autocmd BufNewFile,BufRead [^.]*shrc set filetype=bash
  autocmd BufNewFile,BufRead .bashrc set filetype=bash
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.java setlocal tabstop=4 softtabstop=4 shiftwidth=4

  " " F4で現在のファイルを実行 https://qiita.com/i47_rozary/items/e02bd3b790a2d909ea9f
  " autocmd FileType go noremap <Space>n :!go run %:p<CR>
  " autocmd FileType javascript noremap <Space>n :!deno %:p<CR>
  " autocmd FileType ruby noremap <Space>n :!ruby %:p<CR>
  " autocmd FileType sh noremap <Space>n :!sh %:p<CR>

  " [vim-quickrun シンプルかつまともに使える設定 - Qiita](https://qiita.com/uplus_e10/items/2a75fbe3d80063eb9c18)
  " autocmd FileType qf nnoremap <silent><buffer>q :quit<CR>

  " autocmd BufNewFile,BufRead *.md,*.json nnoremap <Space>p :<C-u>w<CR>:DenoFmt<CR>

  " [NeovimのTerminalモードをちょっと使いやすくする](https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal)
  autocmd TermOpen * startinsert

  " 前回終了位置に移動
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute 'normal g`"' | endif
  autocmd BufReadPost * delmarks!

  " [vim-jp » Hack #202: 自動的にディレクトリを作成する](https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html)
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
          \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction

augroup END
