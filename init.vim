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

"-----------------
" Options
"-----------------
set ambiwidth=single
set autoindent
set autoread
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

" [Tips should also describe automatic installation for Neovim|junegunn/vim-plug](https://github.com/junegunn/vim-plug/issues/739)
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  if !executable('curl')
    echoerr 'You have to install curl.'
    execute 'quit!'
  endif
  silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path .
      \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
else
  " [おい、NeoBundle もいいけど vim-plug 使えよ](https://qiita.com/b4b4r07/items/fa9c8cceb321edea5da0)
  " nvimではarrow method使えない…？
  function! s:AutoPlugInstall() abort
    let list = map(
          \ filter(
          \ copy(
          \ items(get(g:, 'plugs', {}))
          \ ),
          \ {_,item->!isdirectory(item[1].dir)}
          \ ),
          \ {_,item->item[0]}
          \ )
    if empty(list)
      return
    endif
    echo 'Not installed plugs: ' . string(list)
    if confirm('Install plugs?', "yes\nno", 2) == 1
      PlugInstall --sync | close
    endif
  endfunction
  augroup vimrc_plug
    autocmd VimEnter * call s:AutoPlugInstall()
  augroup END
endif
unlet autoload_plug_path

call plug#begin(stdpath('config') . '/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dart-lang/dart-vim-plugin'
" Plug 'dbeniamine/cheat.sh-vim'
Plug 'haya14busa/vim-asterisk'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'markonm/traces.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'terryma/vim-expand-region'
Plug 'reireias/vim-cheatsheet'
Plug 'sainnhe/sonokai'
Plug 'thosakwe/vim-flutter'
Plug 'tpope/vim-endwise'
" Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tyru/caw.vim'
" Plug 'tyru/open-browser.vim'
Plug 'vim-jp/vimdoc-ja'
call plug#end()

let g:cheatsheet#cheat_file = '~/.vim-cheatsheet.md'

"-----------------
" coc.nvim configuration
" https://github.com/neoclide/coc.nvim#example-vim-configuration
"-----------------
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>A  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>E  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>C  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>O  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>S  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>J  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>K  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>P  :<C-u>CocListResume<CR>

"-----------------
" Commands and Functions
"-----------------
command! Rcedit edit $MYVIMRC
command! Rcreload source $MYVIMRC | nohlsearch | redraw | echo 'init.vim is reloaded.'
command! MyTerminal terminal ++rows=12
command! LazyGit tab terminal ++close lazygit
command! Lg LazyGit
command! FmtTabTrail retab | FixWhiteSpace

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

" [vimのマーク機能をできるだけ活用してみる - Make 鮫 noise](http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908)
let g:mark_chars = ['h', 'j', 'k', 'l']
function! s:AutoMark() abort
  let b:mark_pos = exists('b:mark_pos') ? (b:mark_pos + 1) % len(g:mark_chars) : 0
  execute 'normal! m' . g:mark_chars[b:mark_pos]
  echo 'auto-marked' g:mark_chars[b:mark_pos]
endfunction
function! s:AutoJump() abort
  if !exists('b:mark_pos')
    echo 'not auto-marked yet.'
    return
  endif
  execute 'normal! `' . g:mark_chars[b:mark_pos]
  echo 'jumped to mark' g:mark_chars[b:mark_pos]
endfunction

let g:reg_chars = ['q', 'w', 'e', 'r', 't', 'y']
function! s:AutoRec() abort
  let b:reg_pos = exists('b:reg_pos') ? (b:reg_pos + 1) % len(g:reg_chars) : 0
  execute 'normal! q' . g:reg_chars[b:reg_pos]
  echo 'auto-reged' g:reg_chars[b:reg_pos]
endfunction
function! s:AutoPlay() abort
  " echo 'played reg' g:reg_chars[b:reg_pos]
  return exists('b:reg_pos') ? '@' . g:reg_chars[b:reg_pos] : ''
endfunction
function! s:ClearAutoRec() abort
  for reg_char in g:reg_chars
    execute 'let @' . reg_char . " = ''"
  endfor
endfunction

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
noremap H ^
noremap L $
noremap M %
noremap n nzz
noremap N Nzz
map s <Plug>(asterisk-*)
map gs <Plug>(asterisk-g*)

" normal
nnoremap mm :<C-u>call <sid>AutoMark()<CR>
nnoremap m, :<C-u>call <sid>AutoJump()<CR>
nnoremap S :%s/\V<C-r>///g<Left><Left>
" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q :<C-u>call <sid>AutoRec()<CR>
nnoremap <expr> Q <sid>AutoPlay()
nnoremap p ]p`]
nnoremap P ]P`]
nnoremap ]p p
nnoremap ]P P
nnoremap x "_d
nnoremap xx "_dd
nnoremap X "_D
nnoremap Y y$
nnoremap ' `
nnoremap ? /\v
nnoremap == gg=G''

nnoremap <Space>a <C-w><C-w>
nnoremap <Space>b :<C-u>Buffers<CR>
nnoremap <Space>B :<C-u>BLines<CR>
" nmap <Space>c <Plug>(caw:hatpos:toggle)
" nnoremap <Space>C :<C-u>CaseToSelected<CR>
nnoremap <Space>d :<C-u>bdelete<CR>
" nnoremap <Space>e
nnoremap <Space>f :<C-u>Files<CR>
nnoremap <silent><Space>g :<C-u>copy.<CR>
nnoremap <Space>h :<C-u>History<CR>
nnoremap <silent><Space>i mzviwbg~`z:<C-u>delmarks z<CR>
" nnoremap <Space>j
" nnoremap <Space>k
" nnoremap <Space>l :<C-u>LspDocumentDiagnostics<CR>
nnoremap <Space>m :<C-u>Marks<CR>
" nnoremap <Space>n
" nnoremap <Space>o o<Esc>
" nnoremap <Space>O O<Esc>
" nnoremap <Space>p :<C-u>LspDocumentFormat<CR>
" nnoremap <Space>P :<C-u>Prettier<CR>
nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>r :<C-u>registers<CR>
nnoremap <Space>s :<C-u>&&<CR>
nnoremap <Space>t <C-^>
nnoremap <silent><Space>u mzviwg~`z:<C-u>delmarks z<CR>
" nnoremap <Space>v
nnoremap <Space>w :<C-u>write<CR>
nnoremap <Space>wq :<C-u>wq<CR>
" nnoremap <Space>x
" nnoremap <Space>y
nnoremap <Space>z :<C-u>za<CR>
" nnoremap <Space>/ :<C-u>RgRaw -F -- $''<Left>
" nnoremap <Space>? :<C-u>RgRaw -F -- $'<C-r><C-w>'<Left>
nnoremap <Space>; :<C-u>History/<CR>
nnoremap <Space>: :<C-u>History:<CR>

" nnoremap <silent><C-k> :m-2<CR>=l
" nnoremap <silent><C-j> :m+1<CR>=l
nnoremap <silent><C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap <C-w><C-q> <C-w>c

" command
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

" insert
inoremap <silent> jj <ESC>
inoremap <silent> っj <ESC>

" visual
xmap v <Plug>(expand_region_expand)
xmap <C-v> <Plug>(expand_region_shrink)
" xmap <Space>c <Plug>(caw:hatpos:toggle)
xnoremap <silent> <expr> p <sid>VisualPaste()
xnoremap <silent> y y`]
xnoremap x "_x
xnoremap z zf

xnoremap <silent><C-k> :m'<-2<CR>gv=gv
xnoremap <silent><C-j> :m'>+1<CR>gv=gv

" operator
onoremap x d

" terminal
tnoremap <C-w><C-n> <C-w>N

"-----------------
" Appearances
"-----------------
syntax enable

colorscheme sonokai

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  " plugin settings
  " autocmd BufReadPost * silent! DoShowMarks

  " [vaffle.vim から netrw にお試しで移行してみた - bamch0h’s diary](https://bamch0h.hatenablog.com/entry/2019/06/24/004104)
  " autocmd FileType netrw nnoremap <buffer> h -
  " autocmd FileType netrw nnoremap <buffer> l <CR>
  " autocmd FileType netrw nnoremap <buffer> . gh

  " file type settings
  " autocmd BufNewFile,BufRead *.md set filetype=markdown
  " autocmd BufNewFile,BufRead .env* set filetype=env
  " autocmd BufNewFile,BufRead git-__* set filetype=bash
  " autocmd BufNewFile,BufRead [^.]*shrc set filetype=bash
  " autocmd BufNewFile,BufRead .bashrc set filetype=bash
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.java setlocal tabstop=4 softtabstop=4 shiftwidth=4

  " 前回終了位置に移動
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute 'normal g`"' | endif
  autocmd BufReadPost * delmarks!

  autocmd VimLeavePre * call s:ClearAutoRec()
augroup END
