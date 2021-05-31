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
" Plug 'dbeniamine/cheat.sh-vim'
" Plug 'machakann/vim-highlightedyank'
" Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-unimpaired'
" Plug 'tyru/open-browser.vim'
" Plug 'unblevable/quick-scope'

Plug 'AndrewRadev/splitjoin.vim'
Plug 'Lunarwatcher/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dart-lang/dart-vim-plugin'
Plug 'easymotion/vim-easymotion'
Plug 'gko/vim-coloresque'
Plug 'glidenote/memolist.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'itchyny/lightline.vim'
Plug 'jacquesbh/vim-showmarks'
Plug 'jesseleite/vim-agriculture'
Plug 'josa42/vim-lightline-coc'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vista.vim'
Plug 'markonm/traces.vim'
Plug 'machakann/vim-sandwich'
Plug 'mattn/vim-goaddtags'
Plug 'mattn/vim-goimpl'
Plug 'mattn/vim-goimports'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'osyo-manga/vim-anzu'
Plug 'reireias/vim-cheatsheet', { 'on': 'Cheat' }
Plug 'sainnhe/sonokai'
Plug 'segeljakt/vim-silicon'
Plug 'terryma/vim-expand-region'
Plug 'thinca/vim-quickrun'
Plug 'thosakwe/vim-flutter'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tyru/caw.vim'
Plug 'vim-jp/vimdoc-ja'
call plug#end()

let g:AutoPairsCompatibleMaps = 0
let g:asterisk#keeppos = 1
let g:cheatsheet#cheat_file = '~/.vim-cheatsheet.md'

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
let g:silicon = {}
let g:silicon['output'] = '~/Pictures/silicon/silicon-{time:%Y-%m-%d-%H%M%S}.png'

let g:which_key_map = {}
call which_key#register('<Space>', "g:which_key_map")

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
" vista.vim configuration
" https://github.com/liuchengxu/vista.vim#options
"-----------------
" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works for the kind renderer, not the tree renderer.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'

" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['right:50%']

" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
let g:vista#renderer#enable_icon = 1
" let g:vista_stay_on_open = 0

" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
" let g:vista#renderer#icons = {
"      \   "function": "\uf794",
"      \   "variable": "\uf71b",
"      \  }

"-----------------
" Commands and Functions
"-----------------
command! Rcedit edit $MYVIMRC
command! Rcreload write | source $MYVIMRC | nohlsearch | redraw | echo 'init.vim is reloaded.'
command! MyTerminal terminal ++rows=12
command! LazyGit tab terminal ++close lazygit
command! Lg LazyGit
command! FmtTabTrail retab | FixWhitespace
" command! Silicon !silicon %:p --output %:p:t.png

command! CocFlutter CocList --input=flutter commands
command! CocGo CocList --input=go commands
command! GoRun !go run %:p
command! CocMarkmap CocCommand markmap.create

let g:blog_dir = $OBSIDIAN_VAULT . '/blog/'
command! -bang BlogList
      \ call fzf#vim#files(g:blog_dir, {'options': ['--layout=reverse', '--info=inline', '--preview', 'cat {}']}, <bang>0)

function! s:warn(message)
  echohl WarningMsg
  echom a:message
  echohl None
  return 0
endfunction

function! s:BlogNew()
  let title = input("Blog title: ", "")
  " echo "\nCreate blog: " . title

  let filepath = $OBSIDIAN_VAULT . '/blog/' . strftime("%Y-%m-%d-") .
        \ substitute(title, ' ', '-', 'g') . '.md'
  if filereadable(filepath)
    return s:warn('The file is already exists!')
  endif

  let templatepath = $OBSIDIAN_VAULT . '/templates/blog-template.md'
  if !filereadable(templatepath)
    return s:warn('The template file does not exists!')
  endif

  execute "edit" templatepath
  execute "write" filepath
  execute "edit" filepath
  execute "0,3substitute/title: /title: " . title . "/"
  write
  " echo "\nCreate blog: " . filepath . " from " . templatepath
endfunction
command! -bang BlogNew call s:BlogNew()

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
" z*はssにマッピングするが通常のsの動作を潰すため1個の場合も登録しておく
map s <Plug>(asterisk-z*)<Plug>(anzu-update-search-status)zz
map ss <Plug>(asterisk-z*)<Plug>(anzu-update-search-status)zz
map sg <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status)zz
map <Space>ef <Plug>(easymotion-bd-f)
map <Space>el <Plug>(easymotion-bd-jk)
map <Space>ew <Plug>(easymotion-bd-w)

" normal
nnoremap mm :<C-u>call <sid>AutoMark()<CR>
nnoremap m, :<C-u>call <sid>AutoJump()<CR>
nnoremap S :%s/\V<C-r>///g<Left><Left>
" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q :<C-u>call <sid>AutoRec()<CR>
nnoremap <expr> Q <sid>AutoPlay()
nnoremap p p`[v`]=`]
nnoremap P P`[v`]=`]
nnoremap ]p p
nnoremap ]P P
nnoremap x "_d
nnoremap xx "_dd
nnoremap X "_D
nnoremap Y y$
nnoremap ' `
nnoremap ? /\v
nnoremap == gg=G''

nnoremap <leader><leader> :<C-u>WhichKey '<leader>'<CR>
nnoremap <Space><Space> :<C-u>WhichKey '<Space>'<CR>
" nnoremap <Space>a <C-w><C-w>
nnoremap <Space>b :<C-u>Buffers<CR>
nnoremap <Space>B :<C-u>BLines<CR>
" nmap <Space>c <Plug>(caw:hatpos:toggle)
" nnoremap <Space>C :<C-u>CaseToSelected<CR>
nnoremap <Space>d :<C-u>Sayonara!<CR>
nmap <Space>ef <Plug>(easymotion-overwin-f)
nmap <Space>el <Plug>(easymotion-overwin-jk)
nmap <Space>es <Plug>(easymotion-overwin-f2)
nmap <Space>ew <Plug>(easymotion-overwin-w)
nmap <Space>sj :SplitjoinJoin<CR>
nmap <Space>sk :SplitjoinSplit<CR>
nnoremap <Space>f :<C-u>Files<CR>
nnoremap <silent><Space>g :<C-u>copy.<CR>
let g:which_key_map.g = "Duplicate line to down"
nnoremap <silent><Space>G :<C-u>copy-1<CR>
let g:which_key_map.G = "Duplicate line to up"
nnoremap <Space>h :<C-u>History<CR>
" nnoremap <silent><Space>i mzviwbg~`z:<C-u>delmarks z<CR>
" nnoremap <Space>j
" nnoremap <Space>k
nnoremap <Space>l :<C-u>Lines<CR>
nnoremap <Space>m :<C-u>Marks<CR>
nnoremap <silent> <Space>n :<C-u>write<CR>:QuickRun -mode n<CR>
nnoremap <silent><Space>o :<c-u>put =repeat(nr2char(10), v:count1)<cr>
let g:which_key_map.o = "Insert line to down"
nnoremap <silent><Space>O :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
let g:which_key_map.O = "Insert line to up"
nnoremap <Space>p :<C-u>Format<CR>
" nnoremap <Space>P :<C-u>Prettier<CR>
nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>r :<C-u>registers<CR>
nnoremap <Space>s :<C-u>%s/
nnoremap <Space>S :<C-u>&&<CR>
nnoremap <Space>t <C-^>
let g:which_key_map.t = "Toggle buffers"
nnoremap <Space>T <C-w><C-w>
let g:which_key_map.T = "Toggle windows"
nnoremap <silent><Space>u mzviwg~`z:<C-u>delmarks z<CR>
nnoremap <silent><Space>U mzviwbg~`z:<C-u>delmarks z<CR>
nnoremap <Space>v :<C-u>Vista!!<CR>
nnoremap <Space>V :<C-u>Vista finder fzf<CR>
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

nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

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
xnoremap <silent> <Space>n :<C-u>write<CR>gv:QuickRun -mode n<CR>
xnoremap <Space>w <Esc>:<C-u>write<CR>gv
" xmap <Space>c <Plug>(caw:hatpos:toggle)
xnoremap <silent> <expr> p <sid>VisualPaste()
xnoremap <silent> y y`]
xnoremap x "_x
xnoremap z zf
xnoremap < <gv
xnoremap > >gv

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
      \  'right': [['clock', 'pwd']],
      \ },
      \ 'component': {
      \   'clock': '%{strftime("%F %R")}',
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

  " [vaffle.vim から netrw にお試しで移行してみた - bamch0h’s diary](https://bamch0h.hatenablog.com/entry/2019/06/24/004104)
  " autocmd FileType netrw nnoremap <buffer> h -
  " autocmd FileType netrw nnoremap <buffer> l <CR>
  " autocmd FileType netrw nnoremap <buffer> . gh

  " [close vista window automatically when it's the last window open](https://github.com/liuchengxu/vista.vim/issues/108)
  autocmd BufEnter * if winnr("$") == 1 && vista#sidebar#IsOpen() | execute "normal! :q!\<CR>" | endif

  autocmd BufWritePost $MYVIMRC source $MYVIMRC | echo 'vimrc is reloaded.'

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

  " 前回終了位置に移動
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute 'normal g`"' | endif
  autocmd BufReadPost * delmarks!

  autocmd VimLeavePre * call s:ClearAutoRec()
augroup END
