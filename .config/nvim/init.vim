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
" Disable default plugins
"-----------------
let g:loaded_gzip               = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:loaded_rrhelper           = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_netrw              = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_netrwSettings      = 1
let g:loaded_netrwFileHandlers  = 1
let g:did_install_default_menus = 1
let g:skip_loading_mswin        = 1
let g:did_install_syntax_menu   = 1

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
if has('termguicolors')
  set termguicolors
endif

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
      \   filter(
      \     copy(
      \       items(get(g:, 'plugs', {}))
      \     ),
      \     {_,item->!isdirectory(item[1].dir)}
      \   ),
      \   {_,item->item[0]}
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
Plug 'bronson/vim-trailing-whitespace'
" Plug 'cocopon/iceberg.vim'
Plug 'easymotion/vim-easymotion'
Plug 'gko/vim-coloresque'
Plug 'glidenote/memolist.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'itchyny/lightline.vim'
Plug 'jacquesbh/vim-showmarks'
Plug 'jesseleite/vim-agriculture'
Plug 'josa42/vim-lightline-coc'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'lambdalisue/gina.vim'
Plug 'markonm/traces.vim'
Plug 'machakann/vim-sandwich'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'osyo-manga/vim-anzu'
Plug 'segeljakt/vim-silicon'
Plug 'sainnhe/sonokai'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tyru/caw.vim'
Plug 'tyru/open-browser.vim'
" Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'vim-denops/denops.vim'
Plug 'vim-jp/vimdoc-ja'
call plug#end()

let g:asterisk#keeppos = 1

let g:coc_global_extensions = [
      \ 'coc-highlight',
      \ 'coc-json',
      \ 'coc-spell-checker',
      \ 'coc-word',
      \ 'coc-yank',
      \ ]
let g:qs_buftype_blacklist = ['terminal', 'nofile']
let g:memolist_memo_suffix = "md"
let g:memolist_fzf = 1
let g:netrw_nogx = 1 " disable netrw's gx mapping for openbrowser
let g:silicon = {}
let g:silicon['output'] = '~/Downloads/silicon-{time:%Y-%m-%d-%H%M%S}.png'

let g:fzf_preview_fzf_preview_window_option = 'down:70%'
let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_default_fzf_options = {
      \ '--reverse': v:true,
      \ '--preview-window': 'wrap',
      \ '--exact': v:true,
      \ '--no-sort': v:true,
      \ }
let g:sonokai_style = 'shusia' " default,atlantis,andromeda,shusia,maia,espresso

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

" Make <CR> auto-select the first completion item and notify coc.nvim to format on enter
" https://github.com/tpope/vim-endwise/issues/125#issuecomment-743921576
inoremap <silent> <CR> <C-r>=<SID>coc_confirm()<CR>
function! s:coc_confirm() abort
  if pumvisible()
    return coc#_select_confirm()
  else
    return "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"
  endif
endfunction

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
nnoremap <silent><nowait> <space>A  :<C-u>CocList diagnostics<CR>
" Manage extensions.
nnoremap <silent><nowait> <space>E  :<C-u>CocList extensions<CR>
" Show commands.
nnoremap <silent><nowait> <space>C  :<C-u>CocList commands<CR>
" Find symbol of current document.
nnoremap <silent><nowait> <space>O  :<C-u>CocList outline<CR>
" Search workspace symbols.
nnoremap <silent><nowait> <space>S  :<C-u>CocList -I symbols<CR>
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
command! Rcreload write | source $MYVIMRC | nohlsearch | redraw | echo 'init.vim is reloaded.'
command! LazyGit tab terminal lazygit
command! Lg LazyGit
command! FmtTabTrail retab | FixWhitespace
command! DenoFmt echo system("deno fmt --quiet ".expand("%:p")) | edit | echo 'deno fmt current file'
command! CopyFullPath let @*=expand('%:p') | echo 'copy full path'
command! CopyDirName  let @*=expand('%:h') | echo 'copy dir name'
command! CopyFileName let @*=expand('%:t') | echo 'copy file name'
command! -nargs=* T split | wincmd j | resize 12 | terminal <args>

" command! CocFlutter CocList --input=flutter commands
" command! CocGo CocList --input=go commands
" command! GoRun !go run %:p
" command! CocMarkmap CocCommand markmap.create

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

" [neovim terminal](https://gist.github.com/pocari/fd0622fb5ec6946a368e8ee0603979ae)
" terminalの終了時にバッファを消すフック
function! s:onTermExit(job_id, code, event) dict
  " Process Exitが表示されたその後cr打つとバッファが無くなるので
  " それと同じようにする
  call feedkeys("\<CR>")
endfun

" function! s:DenoRepl() abort
"   only | echo 'deno repl' | split | wincmd j | resize 12 | execute 'terminal deno'
" endfun
" command! -bang DenoRepl call s:DenoRepl()

function! s:DenoTerm() abort
  let l:filename = expand('%:p')
  let l:cmd = l:filename =~ '^\(.*\.\|.*_\)\?test\.\(ts\|tsx\|js\|mjs\|jsx\)$'
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
map n <Plug>(anzu-n)zz
map N <Plug>(anzu-N)zz
map M %

nmap s <Nop>
xmap s <Nop>
map ss <Plug>(asterisk-z*)<Plug>(anzu-update-search-status)zz
map sg <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status)zz
map <Space>ef <Plug>(easymotion-bd-f)
map <Space>el <Plug>(easymotion-bd-jk)
map <Space>ew <Plug>(easymotion-bd-w)

" normal
" nnoremap mm :<C-u>call <sid>AutoMark()<CR>
" nnoremap m, :<C-u>call <sid>AutoJump()<CR>
nnoremap S :%s/\V<C-r>///g<Left><Left>
" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
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
nnoremap ' `

nmap gx <Plug>(openbrowser-smart-search)

nnoremap <Space>a :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <Space>b :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <Space>B :<C-u>CocCommand fzf-previewBufferLines<CR>
" nmap <Space>c <Plug>(caw:hatpos:toggle)
nnoremap <Space>d :<C-u>Sayonara!<CR>
nmap <Space>ef <Plug>(easymotion-overwin-f)
nmap <Space>el <Plug>(easymotion-overwin-jk)
nmap <Space>es <Plug>(easymotion-overwin-f2)
nmap <Space>ew <Plug>(easymotion-overwin-w)
nnoremap <Space>f :<C-u>CocCommand fzf-preview.ProjectFiles<CR>
nnoremap <silent><Space>g :<C-u>copy.<CR>
nnoremap <silent><Space>G :<C-u>copy-1<CR>
nnoremap <Space>h :<C-u>History<CR>
nnoremap <Space>j :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <Space>l :<C-u>CocCommand fzf-preview.Lines<CR>
nnoremap <Space>m :<C-u>CocCommand fzf-preview.Marks<CR>
nnoremap <silent><Space>o :<c-u>put =repeat(nr2char(10), v:count1)<cr>
nnoremap <silent><Space>O :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
nnoremap <Space>p :<C-u>Format<CR>
nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>Q :<C-u>only<CR>
nnoremap <Space>r :<C-u>registers<CR>
nnoremap <Space>s :<C-u>%s/
nnoremap <Space>S :<C-u>&&<CR>
nnoremap <Space>t <C-^>
nnoremap <Space>T <C-w><C-w>
nnoremap <silent><Space>u mzviwg~`z:<C-u>delmarks z<CR>
nnoremap <silent><Space>U mzviwbg~`z:<C-u>delmarks z<CR>
nnoremap <Space>w :<C-u>write<CR>
nnoremap <Space>wq :<C-u>exit<CR>
nnoremap <Space>x :<C-u>CocCommand explorer<CR>
nnoremap <Silent> <Space>y  :<C-u>CocList -A --normal yank<CR>
nnoremap <Space>z za
nnoremap <Space>/ :<C-u>RgRaw -F -- $''<Left>
nmap <Space>? <Plug>RgRawWordUnderCursor<Left>
nnoremap <Space>; :<C-u>History/<CR>
nnoremap <Space>: :<C-u>History:<CR>

nnoremap <silent><expr> <C-k> ':<C-u>move-1-' . v:count1 . '<CR>=l'
nnoremap <silent><expr> <C-j> ':<C-u>move+' . v:count1 . '<CR>=l'
nnoremap <silent><C-l> :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
nnoremap <C-w><C-q> <C-w>c

" command
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

" insert
inoremap <silent> jj <ESC>

" visual
xmap v <Plug>(expand_region_expand)
xmap <C-v> <Plug>(expand_region_shrink)
xmap <Space>/ <Plug>RgRawVisualSelection<Left>
vmap gx <Plug>(openbrowser-smart-search)
xnoremap <Space>w <Esc>:<C-u>write<CR>gv
" xmap <Space>c <Plug>(caw:hatpos:toggle)
xnoremap <silent> <expr> p <sid>VisualPaste()
xnoremap <silent> y y`]
xnoremap x "_x

xnoremap < <gv
xnoremap > >gv

xnoremap <silent><C-k> :m'<-2<CR>gv=gv
xnoremap <silent><C-j> :m'>+1<CR>gv=gv

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

colorscheme sonokai

" tablineの項目はwinwidthを気にしなくて良い
let g:lightline = {
      \ 'colorscheme': 'sonokai',
      \ 'active': {
      \   'left': [['mode', 'paste'], ['coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok'],
      \            ['gitgutter', 'filename', 'modified'], ['coc_status'], ['vista']],
      \   'right': [['coc'], ['lineinfo', 'anzu'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
      \ },
      \ 'tabline': {
      \  'left': [['tabs']],
      \  'right': [['pwd']],
      \ },
      \ 'component': {
      \   'fileencoding': '%{winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ""}',
      \   'fileformat': '%{winwidth(0) > 70 ? &fileformat : ""}',
      \   'filetype': '%{winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : "no ft") : ""}',
      \   'mode': '%{winwidth(0) > 60 ? lightline#mode() : lightline#mode()[0]}',
      \   'modified': '%{!&modifiable ? "RO" : &modified ? "+" : ""}',
      \   'pwd': '%.35(%{fnamemodify(getcwd(), ":~")}%)',
      \ },
      \ 'component_function': {
      \   'anzu': 'anzu#search_status',
      \   'coc': 'coc#status',
      \   'gitgutter': 'LightlineGitGutter',
      \   'vista': 'LightlineVista',
      \ },
      \ }
call lightline#coc#register()
" [lightline.vimをカスタマイズする - cafegale(LeafCage備忘録)](http://leafcage.hateblo.jp/entry/2013/10/21/lightlinevim-customize)
" [lightline.vim に乗り換えた - すぱぶろ](http://superbrothers.hatenablog.com/entry/2013/08/29/001326)
function! LightlineGitGutter()
  if !exists('*GitGutterGetHunkSummary')
        \ || !get(g:, 'gitgutter_enabled', 0)
    return ''
  endif
  let [a,m,r] = GitGutterGetHunkSummary()
  let ret = ( a ? g:gitgutter_sign_added . a . ' ' : '' ) .
        \ ( m ? g:gitgutter_sign_modified . m . ' ' : '' ) .
        \ ( r ? g:gitgutter_sign_removed . r : '' )
  return substitute(ret, " $", "", "")
endfunction
function! LightlineVista() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

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
  autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()

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

  autocmd BufNewFile,BufRead *.md,*.json nnoremap <Space>p :<C-u>w<CR>:DenoFmt<CR>

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
