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
" let g:did_indent_on             = 1
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_load_filetypes        = 1
let g:loaded_2html_plugin       = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_gtags              = 1
let g:loaded_gtags_cscope       = 1
let g:loaded_gzip               = 1
let g:loaded_logiPat            = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrw              = 1
let g:loaded_netrwFileHandlers  = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_netrwSettings      = 1
let g:loaded_remote_plugins     = 1
let g:loaded_rrhelper           = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

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
set termguicolors
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
  " nvim does not support arrow methods
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
" Plug 'glidenote/memolist.vim'
Plug 'vim-denops/denops.vim', { 'on': [] }
Plug 'kat0h/bufpreview.vim', { 'on': 'PreviewMarkdown' }

Plug 'arthurxavierx/vim-caser', { 'on': [] }
Plug 'echasnovski/mini.nvim'
Plug 'folke/which-key.nvim', { 'on': [] }
Plug 'haya14busa/vim-asterisk', { 'on': [] }
Plug 'hoob3rt/lualine.nvim'
Plug 'jacquesbh/vim-showmarks', { 'on': 'DoShowMarks' }
Plug 'junegunn/fzf', { 'on': [], 'do': { -> fzf#install() } }
Plug 'kdheepak/lazygit.nvim', { 'on': 'LazyGit' }
Plug 'kevinhwang91/nvim-hlslens', { 'on': [] }
Plug 'kyazdani42/nvim-web-devicons', { 'on': [] }
Plug 'lambdalisue/gina.vim', { 'on': 'Gina' }
Plug 'lewis6991/gitsigns.nvim', { 'on': [] }
Plug 'lewis6991/impatient.nvim'
Plug 'nathom/filetype.nvim'
Plug 'neoclide/coc.nvim', { 'on': [], 'branch': 'release' }
Plug 'norcalli/nvim-colorizer.lua', { 'on': [] }
Plug 'nvim-lua/plenary.nvim', { 'on': [] }
Plug 'phaazon/hop.nvim', { 'on': ['HopChar1', 'HopChar2', 'HopLine', 'HopWord'] }
Plug 'segeljakt/vim-silicon', { 'on': 'Silicon' }
Plug 'simeji/winresizer', { 'on': 'WinResizerStartResize' }
Plug 'terryma/vim-expand-region', { 'on': '<Plug>(expand_region_' }
Plug 'tyru/capture.vim', { 'on': 'Capture' }
Plug 'tyru/open-browser.vim', { 'on': ['OpenBrowser', '<Plug>(openbrowser-'] }
Plug 'vim-jp/vimdoc-ja'
call plug#end()

" set runtimepath^=$DOT_DIR/dps-open

" https://qiita.com/Alice_ecilA/items/d251a90e4a71d67444dd#vim%E3%81%AE%E3%82%BF%E3%82%A4%E3%83%9E%E3%83%BC%E6%A9%9F%E8%83%BD%E3%81%A7%E9%81%85%E5%BB%B6%E8%AA%AD%E3%81%BF%E8%BE%BC%E3%81%BF
" load plugins by timer
function! s:LazyLoadPlugs(timer) abort
  " save current position by marking Z because plug#load reloads current buffer
  normal! mZ
  call plug#load(
        \   'denops.vim',
        \   'coc.nvim',
        \   'fzf',
        \   'gitsigns.nvim',
        \   'nvim-colorizer.lua',
        \   'nvim-hlslens',
        \   'nvim-web-devicons',
        \   'plenary.nvim',
        \   'vim-asterisk',
        \   'vim-caser',
        \   'which-key.nvim',
        \ )
  normal! g`Z
  delmarks Z
endfunction
call timer_start(200, function("s:LazyLoadPlugs"))

lua << EOF
require('impatient')
require('which-key').setup()
require('colorizer').setup()
require('hop').setup()
require('hlslens').setup({ calm_down = true })
require('gitsigns').setup {
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~_' },
  },
  current_line_blame = true,
}
require('filetype').setup({
  overrides = {
    extensions = {
      bashrc = 'bash',
      env = 'env',
    },
    complex = {
      ["%.env.*"] = "env",
      ["%.zshrc.*"] = "zsh",
      [".*shrc"] = "bash",
      ["git--__.+"] = "bash",
    },
  }
})

require('mini.bufremove').setup()
require('mini.comment').setup()
require('mini.surround').setup()
require('mini.trailspace').setup()
require('mini.tabline').setup()
require('mini.pairs').setup()
EOF

let g:asterisk#keeppos = 1
let g:coc_global_extensions = [
      \ 'coc-fzf-preview',
      \ 'coc-highlight',
      \ 'coc-spell-checker',
      \ 'coc-word',
      \ 'coc-yank',
      \ ]
let g:lazygit_floating_window_scaling_factor = 1
let g:lazygit_floating_window_winblend = 20
" let g:memolist_memo_suffix = "md"
" let g:memolist_fzf = 1
let g:netrw_nogx = 1 " disable netrw's gx mapping for openbrowser
let g:silicon = {}
let g:silicon['output'] = '~/Downloads/silicon-{time:%Y-%m-%d-%H%M%S}.png'

let g:fzf_preview_fzf_preview_window_option = 'down:70%'
let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_default_fzf_options = {
      \ '--reverse': v:true,
      \ '--preview-window': 'wrap',
      \ '--cycle': v:true,
      \ '--no-sort': v:true,
      \ }

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

"-----------------
" Commands and Functions
"-----------------
command! RcEdit edit $MYVIMRC
command! RcReload write | source $MYVIMRC | nohlsearch | redraw | echo 'init.vim is reloaded.'
command! DenoFmt write | echo system("deno fmt -q ".expand("%:p")) | edit | echo 'deno fmt current file'
command! CopyFullPath     let @*=expand('%:p') | echo 'copy full path'
command! CopyDirName      let @*=expand('%:h') | echo 'copy dir name'
command! CopyFileName     let @*=expand('%:t') | echo 'copy file name'
command! CopyRelativePath let @*=expand('%:h').'/'.expand('%:t') | echo 'copy relative path'
command! -nargs=* T split | wincmd j | resize 12 | terminal <args>

" command! CocFlutter CocList --input=flutter commands
" command! CocGo CocList --input=go commands
" command! GoRun !go run %:p
" command! CocMarkmap CocCommand markmap.create

command! Trim lua MiniTrailspace.trim()
command! BaTrim retab | Trim

" https://github.com/neovim/neovim/pull/12383#issuecomment-695768082
" https://github.com/Shougo/shougo-s-github/blob/master/vim/autoload/vimrc.vim#L84
function! init#visual_paste(direction) range abort
  let registers = {}

  for name in ['"', '0']
    let registers[name] = {'type': getregtype(name), 'value': getreg(name)}
  endfor

  execute 'normal!' a:direction

  for [name, register] in items(registers)
    call setreg(name, register.value, register.type)
  endfor
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
" exitフックを指定して:terminalを開く
function! s:termopen_wrapper(cmd) abort
  " terminalの終了時にバッファを消すフック
  function! OnTermExit(job_id, code, event) dict
    " Process Exit表示後の<CR>押下を自動化する
    call feedkeys("\<CR>")
  endfunction

  call termopen(a:cmd =~ '^\s*$' ? $SHELL : a:cmd, {'on_exit': function('OnTermExit')})
  " call termopen(a:cmd =~ '^\s*$' ? $SHELL : a:cmd)
endfunction

function! TermHelper(h_or_v, size, cmd) abort
  " echo a:cmd

  if a:h_or_v == 'h'
    topleft new | execute 'Eterminal ' . a:cmd
    execute 'resize ' . a:size
  else
    vertical botright new | execute 'Eterminal ' . a:cmd
    execute 'vertical resize ' . a:size
  endif
endfunction

" 水平ウィンドウ分割してターミナル表示 引数はwindowの行数指定(Horizontal terminal)
command! -count=15 -nargs=* Hterminal :call TermHelper('h', <count>, <q-args>)
" 垂直ウィンドウ分割してターミナル表示 引数はwindowの行数指定(Vertical terminal)
command! -count=80 -nargs=* Vterminal :call TermHelper('v', <count>, <q-args>)
" ウィンドウ分割なしでターミナル表示(Extended Terminal)
command! -nargs=* Eterminal :call s:termopen_wrapper(<q-args>)

" command! DenoRepl silent only | botright 12 new | execute 'terminal deno'

command! -nargs=* -bang Dex silent only! | botright 12 split |
    \ execute 'terminal' (has('nvim') ? '' : '++curwin') 'dex'
    \   (<bang>0 ? '--clear ' : '') <q-args> ' ' expand('%:p') |
    \ stopinsert | execute 'normal! G' | set bufhidden=wipe |
    \ execute 'autocmd BufEnter <buffer> if winnr("$") == 1 | quit! | endif' |
    \ wincmd k

lua << EOF
-- [url-encode.lua](https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99)
-- [string/gsub - Lua Memo](https://aoikujira.com/wiki/lua/index.php?string%252Fgsub)
function urlencode(url)
  if url == nil then
    return
  end

  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w _%%%-%.~])",
          function(c) return string.format("%%%02X", string.byte(c)) end)
  url = url:gsub(" ", "+")
  return url
end
EOF

" https://github.com/kristijanhusak/vim-carbon-now-sh/blob/master/plugin/vim-carbon-now-sh.vim
command! -range=% CarbonNowSh <line1>,<line2>call s:carbonNowSh()

function! s:carbonNowSh() range "{{{
  if !exists('g:loaded_openbrowser')
    call plug#load('open-browser.vim')
  endif

  let l:code = s:urlEncode(s:getVisualSelection())
  let l:url = 'https://carbon.now.sh/?l=' .. &filetype .. '&code=' .. l:code
  call openbrowser#open(l:url)
endfunction "}}}

function! s:urlEncode(string) "{{{
  return v:lua.urlencode(a:string)
endfunction "}}}

function! s:getVisualSelection() "{{{
  let [l:line_start, l:column_start] = getpos("'<")[1:2]
  let [l:line_end, l:column_end] = getpos("'>")[1:2]
  let l:lines = getline(l:line_start, l:line_end)

  if len(l:lines) == 0
    return ''
  endif

  let l:lines[-1] = l:lines[-1][:l:column_end - (&selection ==? 'inclusive' ? 1 : 2)]
  let l:lines[0] = l:lines[0][l:column_start - 1:]

  return join(l:lines, "\n")
endfunction "}}}

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
map M %

nmap s <Nop>
xmap s <Nop>
nnoremap so :<C-u>HopChar1<CR>
nnoremap st :<C-u>HopChar2<CR>
nnoremap sl <Cmd>HopLine<CR>
nnoremap sw <Cmd>HopWord<CR>

noremap n <Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>
noremap N <Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>
map * <Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>
map # <Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>

" normal
nnoremap <silent><C-e> :<C-u>WinResizerStartResize<CR>
" nnoremap mm :<C-u>call <sid>AutoMark()<CR>
" nnoremap m, :<C-u>call <sid>AutoJump()<CR>
nnoremap S :%s/\V<C-r>///g<Left><Left>
" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q qq
nnoremap Q @q
nnoremap <sid>(q)b <Cmd>GitSigns toggle_current_line_blame<CR>
nnoremap <sid>(q)m <Cmd>PreviewMarkdownToggle<CR>
nnoremap <sid>(q)o <Cmd>only<CR>
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

nnoremap <Space>a <Cmd>CocCommand fzf-preview.GitActions<CR>
nnoremap <space>A <Cmd>CocList diagnostics<CR>
nnoremap <Space>b <Cmd>CocCommand fzf-preview.Buffers<CR>
nnoremap <Space>B <Cmd>CocCommand fzf-preview.BufferLines<CR>
nnoremap <space>C <Cmd>CocList commands<CR>
nnoremap <Space>d <Cmd>lua MiniBufremove.delete()<CR>
nnoremap <space>D <Cmd>CocList outline<CR>
" nnoremap <Space>ef :<C-u>HopChar1<CR>
" nnoremap <Space>el <Cmd>HopLine<CR>
" nnoremap <Space>es :<C-u>HopChar2<CR>
" nnoremap <Space>ew <Cmd>HopWord<CR>
nnoremap <space>E <Cmd>CocList extensions<CR>
nnoremap <Space>f <Cmd>CocCommand fzf-preview.ProjectFiles<CR>
nnoremap <Space>g <Cmd>copy.<CR>
nnoremap <Space>G <Cmd>copy-1<CR>
nnoremap <Space>h <Cmd>CocCommand fzf-preview.ProjectMruFiles<CR>
nnoremap <Space>j <Cmd>CocCommand fzf-preview.Jumps<CR>
nnoremap <space>J <Cmd>CocNext<CR>
nnoremap <space>K <Cmd>CocPrev<CR>
nnoremap <Space>l <Cmd>CocCommand fzf-preview.Lines<CR>
nnoremap <Space>L <Cmd>LazyGit<CR>
nnoremap <Space>m <Cmd>CocCommand fzf-preview.Marks<CR>
nnoremap <silent><Space>o :<C-u>put =repeat(nr2char(10), v:count1)<CR>
nnoremap <silent><Space>O :<C-u>put! =repeat(nr2char(10), v:count1)<CR>'[
nnoremap <Space>p <cmd>execute (expand('%:e') == 'md' ? "DenoFmt" : "Format")<CR>
" nnoremap <space>P <Cmd>CocListResume<CR>
nnoremap <Space>q <cmd>quit<CR>
nnoremap <Space>Q <cmd>quitall!<CR>
" nnoremap <Space>r :<C-u>registers<CR>
nnoremap <Space>s :<C-u>%s/
nnoremap <space>S <Cmd>CocList -I symbols<CR>
nnoremap <Space>t <C-^>
nnoremap <Space>T <C-w><C-w>
nnoremap <Space>u mzg~iw`z<Cmd>delmarks z<CR>
nnoremap <Space>U mzlbg~l`z<Cmd>delmarks z<CR>
nnoremap <Space>w <cmd>write<CR>
nnoremap <Space>wq <cmd>wq<CR>
nnoremap <Space>x <Cmd>CocCommand explorer<CR>
nnoremap <Space>y <Cmd>CocList -A --normal yank<CR>
nnoremap <Space>/ :<C-u>CocCommand fzf-preview.ProjectGrep ""<Left>
nnoremap <Space>? :<C-u>CocCommand fzf-preview.ProjectGrep ""<Left><C-r><C-f>
nnoremap <Space>: <Cmd>CocCommand fzf-preview.CommandPalette<CR>

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
cnoremap <C-r><C-r> <C-r><C-r>*

" insert
inoremap <silent> jj <ESC>
inoremap <silent> <C-r><C-r> <C-r><C-r>*

" visual
xmap v <Plug>(expand_region_expand)
xmap <C-v> <Plug>(expand_region_shrink)
xmap <Space>/ <Esc>gv"zy:<C-u>CocCommand fzf-preview.ProjectGrep "<C-r>z"<Left>
xmap gx <Plug>(openbrowser-smart-search)
xnoremap <Space>w <Esc>:<C-u>write<CR>gv
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/mappings.rc.vim#L179
xnoremap <silent> p <Cmd>call init#visual_paste('p')<CR>
xnoremap <silent> P <Cmd>call init#visual_paste('P')<CR>
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
command! VimShowHlGroup echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')

lua << EOF
-- https://github.com/sainnhe/sonokai/blob/master/alacritty/README.md shusia
-- https://github.com/chriskempson/base16/blob/master/styling.md
require('mini.base16').setup({
  palette = {
    -- Default Background
    base00 = "#2d2a2e",
    -- Lighter Background (Used for status bars, line number and folding marks)
    base01 = "#37343a",
    -- Selection Background
    base02 = "#423f46",
    -- Comments, Invisible, Line Highlighting
    base03 = "#848089",
    -- Dark Foreground (Used for status bars)
    base04 = "#66d9ef",
    -- Default Foreground, Caret, Delimiters, Operators
    base05 = "#e3e1e4",
    -- Light Foreground (Not often used)
    base06 = "#a1efe4",
    -- Light Background (Not often used)
    base07 = "#f8f8f2",
    -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base08 = "#f85e84",
    -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base09 = "#ef9062",
    -- Classes, Markup Bold, Search Text Background
    base0A = "#a6e22e",
    -- Strings, Inherited Class, Markup Code, Diff Inserted
    base0B = "#e5c463",
    -- Support, Regular Expressions, Escape Characters, Markup Quotes
    base0C = "#66d9ef",
    -- Functions, Methods, Attribute IDs, Headings
    base0D = "#9ecd6f",
    -- Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0E = "#a1efe4",
    -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    base0F = "#f9f8f5",
  },
  use_cterm = true,
})

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'jellybeans',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      {
        'diagnostics',
        sources = {'coc'},
        symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'}
      },
      'b:gitsigns_status',
      'g:coc_status'
      },
    lualine_c = {'filename'},
    lualine_x = {
      'encoding',
      'fileformat',
      {'filetype', colored = false}
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
}
EOF

if has('syntax')
  augroup vimrc_syntax
    autocmd!
    highlight default ExtraWhitespace ctermbg=darkmagenta guibg=darkmagenta
    highlight! link MiniTrailspace ExtraWhitespace

    " visualize whitespace characters
    " original: https://vim-jp.org/vim-users-jp/2009/07/12/Hack-40.html

    " u2000 ' ' en quad
    " u2001 ' ' em quad
    " u2002 ' ' en space
    " u2003 ' ' em space
    " u2004 ' ' three-per em space
    " u2005 ' ' four-per em space
    " u2006 ' ' six-per em space
    " u2007 ' ' figure space
    " u2008 ' ' punctuation space
    " u2009 ' ' thin space
    " u200A ' ' hair space
    " u200B '​' zero-width space
    " u3000 '　' ideographic (zenkaku) space
    autocmd VimEnter,WinEnter,BufRead *
          \ call matchadd('ExtraWhitespace', "[\u00A0\u2000-\u200B\u3000]")

    highlight HighlightedyankRegion cterm=reverse gui=reverse
    highlight! link GitSignsChange Keyword
    highlight! link GitSignsCurrentLineBlame Comment

    highlight Red ctermfg=203 guifg=#f85e84
    highlight Orange ctermfg=215 guifg=#ef9062
    highlight Yellow ctermfg=179 guifg=#e5c463
    highlight Green ctermfg=107 guifg=#9ecd6f
    highlight Blue ctermfg=110 guifg=#7accd7
    highlight Purple ctermfg=176 guifg=#ab9df2
    highlight Gray ctermfg=246 guifg=#848089
    highlight markdownH1 cterm=bold ctermfg=203 gui=bold guifg=#f85e84
    highlight markdownH2 cterm=bold ctermfg=215 gui=bold guifg=#ef9062
    highlight markdownH3 cterm=bold ctermfg=179 gui=bold guifg=#e5c463
    highlight markdownH4 cterm=bold ctermfg=107 gui=bold guifg=#9ecd6f
    highlight markdownH5 cterm=bold ctermfg=110 gui=bold guifg=#7accd7
    highlight markdownH6 cterm=bold ctermfg=176 gui=bold guifg=#ab9df2
    highlight markdownItalic cterm=italic gui=italic
    highlight markdownBold cterm=bold gui=bold
    highlight markdownItalicDelimiter cterm=italic ctermfg=246 gui=italic guifg=#848089
    highlight link markdownCode Green
    highlight link markdownCodeBlock markdownCode
    highlight link markdownCodeDelimiter markdownCode
    highlight link markdownBlockquote Grey
    highlight link markdownListMarker Red
    highlight link markdownOrderedListMarker Red
    highlight link markdownRule Purple
    highlight link markdownHeadingRule Grey
    highlight link markdownUrlDelimiter Grey
    highlight link markdownLinkDelimiter Grey
    highlight link markdownLinkTextDelimiter Grey
    highlight link markdownHeadingDelimiter Grey
    highlight link markdownLinkText Red
    highlight link markdownUrlTitleDelimiter Green
    highlight link markdownIdDeclaration markdownLinkText
    highlight link markdownBoldDelimiter Grey
    highlight link markdownId Yellow
  augroup END
endif

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  " plugin settings
  autocmd BufReadPost * silent! DoShowMarks

  " 端末のバッファの名前を実行中プロセスを含むものに変更 https://qiita.com/acomagu/items/5f10ce7bcb2fcfc9732f
  autocmd BufLeave * if exists('b:term_title') && exists('b:terminal_job_pid') | execute ":file term" . b:terminal_job_pid . "/" . b:term_title

  " file type settings
  " autocmd BufNewFile,BufRead .env* set filetype=env
  " autocmd BufNewFile,BufRead git-__* set filetype=bash
  " autocmd BufNewFile,BufRead [^.]*shrc set filetype=bash
  " autocmd BufNewFile,BufRead .bashrc set filetype=bash
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.go setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.java setlocal tabstop=4 softtabstop=4 shiftwidth=4

  " https://stackoverflow.com/questions/19137601/turn-off-highlighting-a-certain-pattern-in-vim
  autocmd VimEnter,WinEnter,BufReadPost *.md syntax match Error "\w\@<=\w\@="

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
