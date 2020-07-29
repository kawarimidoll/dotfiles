set encoding=utf-8
scriptencoding utf-8
"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
" (_)_/ |_|_| |_| |_|_|  \___|
"
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
set completeopt=longest,menuone
set cursorline
set display=lastline
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
set whichwrap=b,s,h,l,<,>,[,],~
set wildmenu
set wildmode=list:longest,full
set wrap
set wrapscan

"-----------------
" Plugins
"-----------------
filetype plugin indent on
runtime macros/matchit.vim

" [vim-plug Wiki: Automatic installation](https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation)
if empty(glob('~/.vim/autoload/plug.vim'))
  if !executable('curl')
    echoerr 'You have to install curl.'
    execute 'quit!'
  endif
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
else
  " [おい、NeoBundle もいいけど vim-plug 使えよ](https://qiita.com/b4b4r07/items/fa9c8cceb321edea5da0)
  function! s:AutoPlugInstall() abort
    let list = get(g:, 'plugs', {})->items()->copy()
          \ ->filter({_,item->!isdirectory(item[1].dir)})
          \ ->map({_,item->item[0]})
    if empty(list)
      return
    endif
    echo 'Not installed plugs: ' . list->string()
    if confirm('Install plugs?', "yes\nno", 2) == 1
      PlugInstall --sync | close
    endif
  endfunction
  " command! AutoPlugInstall call s:AutoPlugInstall()
  augroup vimrc_plug
    autocmd VimEnter * call s:AutoPlugInstall()
  augroup END
endif

call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'bronson/vim-trailing-whitespace'
Plug 'dense-analysis/ale'
Plug 'ervandew/supertab'
Plug 'haya14busa/is.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'itchyny/lightline.vim'
Plug 'jacquesbh/vim-showmarks'
Plug 'jesseleite/vim-agriculture'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'
if empty(glob('/usr/local/opt/fzf'))
  Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install -all'}
else
  Plug '/usr/local/opt/fzf'
endif
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'lifepillar/vim-gruvbox8'
Plug 'markonm/traces.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'mhinz/vim-startify'
Plug 'nelstrom/vim-qargs'
Plug 'osyo-manga/vim-anzu'
Plug 'plasticboy/vim-markdown'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'previm/previm' " :PrevimOpenでmarkdownファイルをブラウザで表示、HMRつき
Plug 'qpkorr/vim-bufkill'
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
" Plug 'morhetz/gruvbox'
" Plug 'nanotech/jellybeans.vim'
" Plug 'romainl/Apprentice'
" Plug 'sainnhe/sonokai'
" Plug 'sjl/badwolf'
" Plug 'tomasr/molokai'
" Plug 'volment/vim-colorblind-colorscheme'
" Plug 'w0ng/vim-hybrid'

call plug#end()

let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:closetag_filenames = '*.html,*.vue,*.html.erb'
let g:fzf_buffers_jump = 1
let g:gruvbox_italics = 0
let g:gruvbox_italicize_strings = 0
let g:indentLine_leadingSpaceEnabled = 1
let g:netrw_alto = 1
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_list_hide = '^\.[^\.]'
let g:netrw_liststyle = 3
let g:netrw_nogx = 1 " netrwではopen-browserを無効化
let g:netrw_preview = 1
let g:netrw_winsize = 85
let g:tcomment#replacements_xml = {}
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_toc_autofit = 1

let $FZF_DEFAULT_COMMAND = 'rg --files --follow --glob "!**/{vendor,images,fonts,node_modules}/*" 2> /dev/null'
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case -g "!{*.lock,*-lock.json}"'.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:40%')
      \           : fzf#vim#with_preview('right:50%:hidden','?'),
      \   <bang>0)
" avoid to search file name: fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:40%')

"-----------------
" Commands and Functions
"-----------------
if !exists('*s:ImproveVimrc')
  " [Function to source .vimrc and .gvimrc](https://stackoverflow.com/questions/7114744/function-to-source-vimrc-and-gvimrc)
  function! s:ImproveVimrc()
    if &filetype == 'vim'
      source $MYVIMRC | nohlsearch | redraw | echo 'vimrc is reloaded.'
    else
      edit $MYVIMRC
    endif
  endfunction
  command! Vimrc call s:ImproveVimrc()
endif
command! Terminal terminal ++rows=12
command! LazyGit tab terminal ++close lazygit
command! FmtTabTrail retab | FixWhitespace

" [:SyntaxInfoでカラースキーム確認](http://cohama.hateblo.jp/entry/2013/08/11/020849)
function! s:get_syn_info()
  let GetCollorAttr = {synid ->
        \ "name: " . synIDattr(synid, "name") .
        \ ", ctermfg: " . synIDattr(synid, "fg", "cterm") .
        \ ", ctermbg: " . synIDattr(synid, "bg", "cterm") .
        \ ", guifg: " . synIDattr(synid, "fg", "gui") .
        \ ", guibg: " . synIDattr(synid, "bg", "gui")
        \ }
  let currentSyn = synID(line("."), col("."), 1)
  echo GetCollorAttr(currentSyn)
  echo "link to"
  echo GetCollorAttr(synIDtrans(currentSyn))
endfunction
command! SyntaxInfo call s:get_syn_info()

function! s:SelectorWithNum(list, options = {})
  function! NumKeyFilter(id, key) closure
    let idx = str2nr(a:key)
    if 0 < idx && idx <= len(a:list)
      call popup_close(a:id, idx)
      return 1
    endif
    return popup_filter_menu(a:id, a:key)
  endfunction
  let a:options.filter = 'NumKeyFilter'
  call popup_menu(copy(a:list)->map({key, val -> (key < 9 ? key + 1 : ' ') . ' ' . val}), a:options)
endfunction

" [What are the new "popup windows" in Vim 8.2?](https://vi.stackexchange.com/questions/24462/what-are-the-new-popup-windows-in-vim-8-2)

" [JavaScript で snake_case とか camelCase とか変換する | 忘れていくかわりに](https://kawarimidoll.netlify.app/2020/04/19/)
" いずれはテストを足したい…
" ['theString', 'the_string'],
" ['the string', 'the_string'],
" ['the/string', 'the_string'],
" ['theSTRING', 'the_string'],
" ['The-String', 'the_string'],
" ['TheString', 'the_string'],
" ['TheID', 'the_id'],
" ['THE-ID', 'the_id'],
" ['TheURLParser', 'the_url_parser'],
" ['TheConf2020', 'the_conf_2020'],
" ['TheHTML5', 'the_html_5'],
" ['CSS3Designer', 'css_3_designer'],
let s:WordsSeparate = {str, separator -> str
      \ ->substitute("\\W\\+", "_", "g")
      \ ->substitute("\\(\\u\\+\\)\\(\\u\\l\\)", "_\\L\\1_\\L\\2", "g")
      \ ->substitute("\\u\\+\\|\\d\\+", "_\\L\\0", "g")
      \ ->substitute("^_\\+\\|_\\+$\\", "", "g")
      \ ->substitute("_\\+", separator, "g")
      \ }
let s:CaseTo = [
      \ ['Snake' , {str -> s:WordsSeparate(str, '_')}],
      \ ['Camel' , {str -> s:WordsSeparate(str, '_')->substitute("_\\(\\l\\)", "\\u\\1", "g")}],
      \ ['Pascal', {str -> s:WordsSeparate(str, '_')->substitute("\\(\\l\\+\\)_\\?", "\\u\\1", "g")}],
      \ ['Const' , {str -> s:WordsSeparate(str, '_')->toupper()}],
      \ ['Kebab' , {str -> s:WordsSeparate(str, '-')}],
      \ ['Dot'   , {str -> s:WordsSeparate(str, '.')}],
      \ ['Slash' , {str -> s:WordsSeparate(str, '/')}],
      \ ['Words' , {str -> s:WordsSeparate(str, ' ')}],
      \ ['Header', {str -> s:WordsSeparate(str, '-')->substitute("\\w\\+", "\\u\\0", "g")}],
      \ ]
function! s:CaseToSelected(key = 0, mode = 'n') abort
  let case_menu = s:CaseTo->copy()->map({_, v -> v[1](v[0] . "Case")})

  function! ChangeCase(id, selection) closure
    if a:selection < 1
      echo 'canceled.'
      return
    endif
    echo case_menu[a:selection - 1]
    " visual modeから呼び出したときにnormalに戻ったり戻らなかったりするのでgvしたりしなかったりする必要がある
    if a:mode == 'n'
      normal! viw"zy
    elseif mode() == 'n'
      normal! gv"zy
    else
      normal! "zy
    endif
    let @z = s:CaseTo[a:selection - 1][1](@z)
    normal! gv"zp
    let @z = ''
  endfunction

  if a:key < 1
    call s:SelectorWithNum(case_menu, #{title: ' Change to... ', callback: 'ChangeCase'})
  else
    call ChangeCase(0, a:key)
  endif
endfunction
command! CaseToSelected call s:CaseToSelected()
for [s:key, s:name] in s:CaseTo->copy()->map({idx, elm -> [idx+1, elm[0]]})
  execute "command! CaseTo" . s:name . " call s:CaseToSelected(" . s:key . ")"
endfor

function! s:ToggleCase() abort
  let str = expand('<cword>')
  let type = stridx(str, "_") >= 0 ? 2 :
        \ match(str, "^\\u") == 0 ? 1 :
        \ 3
  call s:CaseToSelected(type)
endfunction
command! ToggleCase call s:ToggleCase()

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
let g:mark_chars = ['h', 'j', 'k', 'l'] "とりあえず4つあれば十分では…？
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
" q: mと同様に使うキーを絞る
" #,?: *,/とNで事足りるのでデフォルトの挙動は潰しても良い
" leader: let mapleader="\<Space>"していたけど<Space>をそのまま書くようにして<Leader>はデフォルトの\のままにしておこう

" disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" global
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap H ^
noremap L $
noremap M %
map n <Plug>(is-nohl)<Plug>(anzu-n)zz
map N <Plug>(is-nohl)<Plug>(anzu-N)zz
map s <Plug>(asterisk-z*)<Plug>(is-nohl-1)<Plug>(anzu-update-search-status)zz
map gs <Plug>(asterisk-gz*)<Plug>(is-nohl-1)<Plug>(anzu-update-search-status)zz

" normal
nmap gx <Plug>(openbrowser-smart-search)
nnoremap mm :<C-u>call <sid>AutoMark()<CR>
nnoremap m, :<C-u>call <sid>AutoJump()<CR>
nnoremap S :%s/\V<C-r>///g<Left><Left>
nnoremap x "_x
nnoremap X V"_d
nnoremap Q @
nnoremap ' `
nnoremap ? /\v
nnoremap == gg=G''
nnoremap p ]p`]
nnoremap P ]P`]
nnoremap ]p p
nnoremap ]P P
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap <Space>a <C-w><C-w>
nnoremap <Space>b :<C-u>Buffers<CR>
nnoremap <Space>c :<C-u>ToggleCase<CR>
nnoremap <Space>C :<C-u>CaseToSelected<CR>
nnoremap <Space>d :<C-u>bdelete<CR>
nnoremap <Space>f :<C-u>Files<CR>
nnoremap <Space>g :<C-u>copy .<CR>
nnoremap <Space>h :<C-u>History<CR>
nnoremap <Space>i mzviwbg~`z:<C-u>delmarks z<CR>
nnoremap <Space>l :<C-u>BLines<CR>
nnoremap <Space>m :<C-u>Marks<CR>
nnoremap <Space>r :<C-u>registers<CR>
nnoremap <Space>t :<C-u>edit #<CR>
nnoremap <Space>q :<C-u>quit<CR>
nnoremap <Space>s :<C-u>&&<CR>
nnoremap <Space>u mzviwg~`z:<C-u>delmarks z<CR>
nnoremap <Space>w :<C-u>write<CR>
nnoremap <Space>wq :<C-u>wq<CR>
nnoremap <Space>z :<C-u>za<CR>
nnoremap <Space>/ :<C-u>RgRaw -F -- $''<Left>
nnoremap <Space>? :<C-u>RgRaw

nnoremap <C-k> "zdd<Up>"zP==
nnoremap <C-j> "zdd"zp==
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
inoremap <expr> <C-x><C-k> fzf#vim#complete#word({'left': '15%'})
inoremap <expr> <C-x><C-f> fzf#vim#complete#path('rg --files')
inoremap <expr> <C-x><C-x> fzf#vim#complete#line()
inoremap <C-]> <Esc><Right>
inoremap <C-t> <Esc><Left>"zx"pa
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>" vim-endwiseと相性が悪いのでオフ

" visual
xmap gx <Plug>(openbrowser-smart-search)
xmap v <Plug>(expand_region_expand)
xmap <C-v> <Plug>(expand_region_shrink)
xnoremap <silent> <expr> p <sid>VisualPaste()
xnoremap <silent> y y`]
xnoremap x "_x
xnoremap z zf

xnoremap <C-k> "zd<Up>"z]P`[V`]
xnoremap <C-j> "zd"z]p`[V`]
xnoremap <Space>/ "zy:<C-u>RgRaw -F -- $'<C-r>z'<CR>
xnoremap <expr> <Space>c <sid>CaseToSelected(0, 'v')

" terminal
tnoremap <C-w><C-n> <C-w>N

"-----------------
" Appearances
"-----------------
syntax enable

colorscheme gruvbox8
" [Add Lightline support. by zlianon · Pull Request #16 · lifepillar/vim-gruvbox8](https://github.com/lifepillar/vim-gruvbox8/pull/16)
let s:bg0 = [ '#282828', 235 ]
let s:bg1 = [ '#3C3836', 237 ]
let s:bg2 = [ '#504945', 239 ]
let s:bg4 = [ '#7C6F64', 243 ]
let s:fg1 = [ '#EBDBB2', 223 ]
let s:fg4 = [ '#A89984', 246 ]
let s:green  = [ '#98971A', 106 ]
let s:yellow = [ '#D79921', 172 ]
let s:blue   = [ '#458588', 66 ]
let s:aqua   = [ '#689D6A', 72 ]
let s:orange = [ '#D65D0E', 166 ]
let s:p = { 'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}, 'terminal': {} }
let s:p.normal.left   = [ [ s:bg0, s:fg4, 'bold' ], [ s:fg4, s:bg2 ] ]
let s:p.normal.right  = [ [ s:bg0, s:fg4 ], [ s:fg4, s:bg2 ] ]
let s:p.normal.middle = [ [ s:fg4, s:bg1 ] ]
let s:p.inactive.left   = [ [ s:bg4, s:bg1 ], [ s:bg4, s:bg1 ] ]
let s:p.inactive.right  = [ [ s:bg4, s:bg1 ], [ s:bg4, s:bg1 ] ]
let s:p.inactive.middle = [ [ s:bg4, s:bg1 ] ]
let s:p.insert.left   = [ [ s:bg0, s:blue, 'bold' ], [ s:fg1, s:bg2 ] ]
let s:p.insert.right  = [ [ s:bg0, s:blue ], [ s:fg1, s:bg2 ] ]
let s:p.insert.middle = [ [ s:fg4, s:bg2 ] ]
let s:p.terminal.left   = [ [ s:bg0, s:green, 'bold' ], [ s:fg1, s:bg2 ] ]
let s:p.terminal.right  = [ [ s:bg0, s:green ], [ s:fg1, s:bg2 ] ]
let s:p.terminal.middle = [ [ s:fg4, s:bg2 ] ]
let s:p.replace.left   = [ [ s:bg0, s:aqua, 'bold' ], [ s:fg1, s:bg2 ] ]
let s:p.replace.right  = [ [ s:bg0, s:aqua ], [ s:fg1, s:bg2 ] ]
let s:p.replace.middle = [ [ s:fg4, s:bg2 ] ]
let s:p.visual.left   = [ [ s:bg0, s:orange, 'bold' ], [ s:bg0, s:bg4 ] ]
let s:p.visual.right  = [ [ s:bg0, s:orange ], [ s:bg0, s:bg4 ] ]
let s:p.visual.middle = [ [ s:fg4, s:bg1 ] ]
let s:p.tabline.left   = [ [ s:fg4, s:bg2 ] ]
let s:p.tabline.right  = [ [ s:bg0, s:orange ] ]
let s:p.tabline.middle = [ [ s:bg0, s:bg0 ] ]
let s:p.tabline.tabsel = [ [ s:bg0, s:fg4 ] ]
let s:p.normal.error   = [ [ s:bg0, s:orange ] ]
let s:p.normal.warning = [ [ s:bg2, s:yellow ] ]
let g:lightline#colorscheme#gruvbox8#palette = lightline#colorscheme#flatten(s:p)
" tablineの項目はwinwidthを気にしなくて良い
let g:lightline = {
      \ 'colorscheme': 'gruvbox8',
      \ 'mode_map': { 'c': 'SEARCH' },
      \ 'active': {
      \   'left': [['mode', 'paste'], ['gitgutter', 'filename', 'modified']],
      \   'right': [['lineinfo', 'anzu', 'ale'], ['percent'], ['fileformat', 'fileencoding', 'filetype']]
      \ },
      \ 'tabline': {
      \  'left': [['tabs']],
      \  'right': [['clock', 'pwd', 'gitbranch']],
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
      \   'ale': 'ALEGetStatuLine',
      \   'anzu': 'anzu#search_status',
      \   'gitbranch': 'FugitiveHead',
      \   'gitgutter': 'LightlineGitGutter',
      \ },
      \ }
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

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  " plugin settings
  autocmd BufReadPost * silent! DoShowMarks
  " [lightline.vimとvim-anzuで検索ヒット数を表示する - Qiita](https://qiita.com/shiena/items/f53959d62085b7980cb5)
  autocmd CursorHold,CursorHoldI,WinLeave,TabLeave * call anzu#clear_search_status()

  " file type settings
  autocmd BufNewFile,BufRead *.md set filetype=markdown
  autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd BufNewFile,BufRead *.java setlocal tabstop=4 softtabstop=4 shiftwidth=4

  " 前回終了位置に移動
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute 'normal g`"' | endif
  autocmd BufReadPost * delmarks!
augroup END
