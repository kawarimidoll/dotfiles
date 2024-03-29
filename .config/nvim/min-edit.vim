let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_indent_on             = 1
" load ftplugin to set commentstring
" let g:did_load_ftplugin         = 1
let g:loaded_2html_plugin       = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_gzip               = 1
let g:loaded_logiPat            = 1
let g:loaded_logipat            = 1
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
let g:loaded_sql_completion     = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1
let g:vimsyn_embed              = 1

let s:word_1000_dict_path = '~/.cache/nvim/google-10000-english-no-swears.txt'
if !filereadable(expand(s:word_1000_dict_path))
  silent execute '!curl --create-dirs -fLo ' .. s:word_1000_dict_path ..
    \ 'https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt'
endif
execute 'set dictionary+=' .. s:word_1000_dict_path

let s:dotfiles_dict_path = '~/dotfiles/.config/cspell/dotfiles.txt'
if filereadable(expand(s:dotfiles_dict_path))
  execute 'set dictionary+=' .. s:dotfiles_dict_path
endif

set ambiwidth=single
set breakindent
set breakindentopt=min:50,shift:4,sbr,list:-1
set cedit=\<C-Q>
set clipboard&
set clipboard^=unnamed
set clipboard^=unnamedplus
set expandtab
set foldcolumn=0
set formatoptions+=mM1
set ignorecase
set laststatus=1
set nobackup
set nolist
set nomodeline
set nonumber
set noshowmode
set noswapfile
set nowritebackup
set scrolloff=5
set shiftround
set shiftwidth=2
set shortmess+=scI
set showbreak=↪
set showtabline=0
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set title
set whichwrap=b,s,h,l,<,>,[,],~
set wildmenu
set wrap
set wrapscan
if executable('rg')
  set grepprg=rg\ --line-number\ --column\ --no-heading\ --color=never\ --hidden\ --trim\ --glob\ '!**/.git/*'
  set grepformat=%f:%l:%c:%m
endif

let g:alpha_lower = 'abcdefghijklmnopqrstuvwxyz'
let g:alpha_upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let g:digits = '0123456789'
let g:alpha_all = g:alpha_lower .. g:alpha_upper
let g:alnum = g:alpha_all .. g:digits

command! -nargs=+ Grep silent grep! <args>
command! -nargs=+ GrepF silent grep! --fixed-strings -- <args>
command! -nargs=+ LGrep silent lgrep! <args>
command! -nargs=+ LGrepF silent lgrep! --fixed-strings -- <args>

command! -nargs=1 -complete=file VDiff vertical diffsplit <args>
command! VDiffAlt execute 'vertical diffsplit' expand('#')

noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap gV `[v`]
noremap H ^
noremap L $
map M %
nnoremap / /\v

nnoremap s <NOP>
nnoremap s/ :%s/
nnoremap S :%s/\V\<<C-r><C-w>\>//g<Left><Left>
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
for c in g:alpha_all->split('\zs')
  execute 'nnoremap <sid>(q)' .. c '<NOP>'
endfor
nnoremap <sid>(q)q qq
nnoremap Q @q

nnoremap p ]p`]
nnoremap P [P`]
nnoremap gp p
nnoremap gP P
nnoremap x "_d
nnoremap X "_D
nnoremap ' `

nnoremap [b <Cmd>bprevious<CR>
nnoremap ]b <Cmd>bnext<CR>
nnoremap [B <Cmd>bfirst<CR>
nnoremap ]B <Cmd>blast<CR>
nnoremap [q <Cmd>cprevious<CR>
nnoremap ]q <Cmd>cnext<CR>
nnoremap [Q <Cmd>cfirst<CR>
nnoremap ]Q <Cmd>clast<CR>

" https://twitter.com/mo_naqa/status/1467626946293284865
nnoremap gf gFzz
nnoremap gx :<C-u>!open <C-r><C-a>

for c in g:alpha_all->split('\zs')
  execute 'nnoremap <Space>' .. c '<NOP>'
endfor
nnoremap <Space>d <Cmd>bdelete<CR>
nnoremap <Space>g <Cmd>copy.<CR>
nnoremap <Space>G <Cmd>copy-1<CR>
nnoremap <Space>o <Cmd>put =repeat(nr2char(10), v:count1)<CR>
nnoremap <Space>O <Cmd>put! =repeat(nr2char(10), v:count1)<CR>'[
nnoremap <Space>p gg=G<C-o>
nnoremap <Space>q <cmd>confirm quit<CR>
nnoremap <Space>Q <cmd>quitall!<CR>
nnoremap <Space>w <cmd>w<CR>
nnoremap <Space>wq <cmd>confirm wq<CR>
nnoremap <Space>; @:
nnoremap <Space>/ :<C-u>Grep ''<Left>
nnoremap <Space>? :<C-u>GrepF ''<Left><C-r><C-w>
xnoremap <Space>? "zy:<C-u>GrepF ''<Left><C-r>z
nnoremap <silent><expr> <C-k> '<Cmd>move-1-' . v:count1 . '<CR>=l'
nnoremap <silent><expr> <C-j> '<Cmd>move+'   . v:count1 . '<CR>=l'
nnoremap <silent><C-l> :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>

nnoremap <C-f> <Cmd>set scroll=0<CR><Cmd>execute 'normal!' repeat("\<C-d>", v:count1 * 2)<CR>
nnoremap <C-b> <Cmd>set scroll=0<CR><Cmd>execute 'normal!' repeat("\<C-u>", v:count1 * 2)<CR>

" command
cnoremap <expr> s getcmdtype() == ':' && getcmdline() == 's' ? '<BS>%s/' : 's'
cnoremap <expr> % getcmdtype() == ':' && getcmdpos() > 2 && getcmdline()[getcmdpos()-2] == '%' ?
      \ '<BS>' .. expand('%:h') .. '/' : '%'
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-r><C-r> <C-r><C-r>*
cnoremap <C-g> <C-c>
cnoremap <expr> <C-k> repeat("\<Del>", strchars(getcmdline()[getcmdpos() - 1:]))

" insert
inoremap <silent> <C-r><C-r> <C-r><C-r>*
" https://github.com/Shougo/shougo-s-github/blob/c327993df755cda22b80d7ee74d131542ef7136c/vim/rc/mappings.rc.vim#L32-L37
" inoremap <C-t> <C-v><TAB>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-k> <C-o>D
inoremap <expr> <Tab>   pumvisible() ? '<C-n>' : '<Tab>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" visual
xnoremap p P
xnoremap <silent> y y`]
xnoremap x "_x
xnoremap < <gv
xnoremap > >gv
xnoremap <silent><C-k> :m'<-2<CR>gv=gv
xnoremap <silent><C-j> :m'>+1<CR>gv=gv
xnoremap S "zy:%s/<C-r>z//gce<Left><Left><Left><Left>
" ref: github.com/monaqa/dotfiles/blob/master/.config/nvim/scripts/keymap.vim#L65-L66
xnoremap * "zy/\V<C-r><C-r>=substitute(escape(@z, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>N
xnoremap R "zy:,$s//<C-r><C-r>=escape(@z, '/\&~')<CR>/gce<Bar>1,''-&&<CR>

" operator
onoremap x d

" terminal
tnoremap <C-w><C-n> <C-\><C-n>
tnoremap <C-p> <Up>
tnoremap <C-n> <Down>

" colorscheme industry

highlight Reverse    cterm=reverse gui=reverse
highlight Pmenu      ctermfg=254 ctermbg=237 guifg=#e3e1e4 guibg=#37343a
highlight PmenuSel   ctermfg=237 ctermbg=254 guifg=#37343a guibg=#e3e1e4
highlight PmenuSbar  ctermbg=238 guibg=#423f46
highlight PmenuThumb ctermbg=255 guibg=#f8f8f2

" https://qiita.com/monaqa/items/dcd43a53d3040293142a
digraphs aa 12354  " あ
digraphs ii 12356  " い
digraphs uu 12358  " う
digraphs ee 12360  " え
digraphs oo 12362  " お
digraphs nn 12435  " ん
digraphs aA 12353  " ぁ
digraphs iI 12355  " ぃ
digraphs uU 12357  " ぅ
digraphs eE 12359  " ぇ
digraphs oO 12361  " ぉ
digraphs Aa 12350  " ア
digraphs Ii 12452  " イ
digraphs Uu 12454  " ウ
digraphs Ee 12456  " エ
digraphs Oo 12458  " オ
digraphs Nn 12531  " ン
digraphs AA 12349  " ァ
digraphs II 12451  " ィ
digraphs UU 12453  " ゥ
digraphs EE 12455  " ェ
digraphs OO 12457  " ォ
digraphs j( 65288  " （
digraphs j) 65289  " ）
digraphs j[ 12300  " 「
digraphs j] 12301  " 」
digraphs j{ 12302  " 『
digraphs j} 12303  " 』
digraphs j< 12304  " 【
digraphs j> 12305  " 】
digraphs j, 12289  " 、
digraphs j. 12290  " 。
digraphs j! 65281  " ！
digraphs j? 65311  " ？
digraphs j: 65306  " ：
digraphs j0 65296  " ０
digraphs j1 65297  " １
digraphs j2 65298  " ２
digraphs j3 65299  " ３
digraphs j4 65300  " ４
digraphs j5 65301  " ５
digraphs j6 65302  " ６
digraphs j7 65303  " ７
digraphs j8 65304  " ８
digraphs j9 65305  " ９
digraphs j~ 12316  " 〜
digraphs j/ 12539  " ・
digraphs js 12288  " 　
" digraphs jj 106    " j
noremap f<C-j> f<C-k>j
noremap F<C-j> F<C-k>j
noremap t<C-j> t<C-k>j
noremap T<C-j> T<C-k>j

" https://zenn.dev/kawarimidoll/articles/665dbd860c72cd
function! s:textobject_outline(...) abort
  let from_parent = index(a:000, 'from_parent') >= 0
  let with_blank = index(a:000, 'with_blank') >= 0

  " get current line and indent
  let from = line('.')
  let indent = indent(from)
  if indent < 0
    return
  endif
  let to = from

  " search first parent
  if from_parent && from > 1 && indent > 0
    let lnum = from - 1
    while indent <= indent(lnum) || (with_blank && getline(lnum) =~ '^\s*$')
      let lnum -= 1
    endwhile

    " update current line and indent
    let from = lnum
    call cursor(from, 0)
    let indent = indent(from)
  endif

  " search last child
  let lnum = to + 1
  while indent < indent(lnum) || (with_blank && getline(lnum) =~ '^\s*$')
    let to = lnum
    let lnum += 1
  endwhile

  " exit visual mode
  let m = mode()
  if m ==# 'v' || m ==# 'V' || m == "\<C-v>"
    execute 'normal! ' .. m
  endif

  " select with line-visual mode
  normal! V
  call cursor(to, 0)
  normal! o
endfunction
command! -nargs=* TextobjectOutline call s:textobject_outline(<f-args>)

xnoremap io <Cmd>TextobjectOutline<CR>
xnoremap ao <Cmd>TextobjectOutline from_parent<CR>
xnoremap iO <Cmd>TextobjectOutline with_blank<CR>
xnoremap aO <Cmd>TextobjectOutline from_parent with_blank<CR>
onoremap io <Cmd>TextobjectOutline<CR>
onoremap ao <Cmd>TextobjectOutline from_parent<CR>
onoremap iO <Cmd>TextobjectOutline with_blank<CR>
onoremap aO <Cmd>TextobjectOutline from_parent with_blank<CR>

augroup min-edit
  autocmd!
  " visualize autocmds
  " autocmd FileType * echomsg 'au FileType '.. expand('<amatch>')
  " autocmd BufEnter * echomsg 'au BufEnter '.. expand('<amatch>')
  " autocmd BufRead * echomsg 'au BufRead '.. expand('<amatch>')
  " autocmd BufWinEnter * echomsg 'au BufWinEnter '.. expand('<amatch>')
  " autocmd WinEnter * echomsg 'au WinEnter '.. expand('<amatch>')
  " autocmd TabEnter * echomsg 'au TabEnter '.. expand('<amatch>')
  " autocmd WinNew * echomsg 'au WinNew '.. expand('<amatch>')
  " autocmd TabNew * echomsg 'au TabNew '.. expand('<amatch>')
  " autocmd VimEnter * echomsg 'au VimEnter '.. expand('<amatch>')

  " Highlight extra whitespaces
  " https://zenn.dev/kawarimidoll/articles/450a1c7754bde6
  " u00A0 ' ' no-break space
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
  autocmd VimEnter * ++once
        \ call matchadd('ExtraWhitespace', "[\u00A0\u2000-\u200B\u3000]")
        \ | highlight default ExtraWhitespace ctermbg=darkmagenta guibg=darkmagenta

  autocmd QuickfixCmdPost make,grep,grepadd,vimgrep if len(getqflist()) != 0 | copen | endif
  autocmd QuickfixCmdPost lmake,grep,lgrepadd,lvimgrep if len(getloclist(0)) != 0 | lopen | endif

  if has('nvim')
    " https://jdhao.github.io/2020/05/22/highlight_yank_region_nvim/
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout=500 })
    " autocmd TermOpen <buffer> highlight clear ExtraWhitespace
  else
    " autocmd TerminalOpen <buffer> highlight clear ExtraWhitespace
  endif
augroup END
