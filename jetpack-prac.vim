let s:source = expand('~/dotfiles/.config/nvim/min-edit.vim')
if filereadable(s:source)
  execute 'source' s:source
endif

set autoindent
set autoread
set cmdheight=2
" set completeopt=longest,menu
set completeopt=menu,menuone,noselect
" set cursorline
set display=lastline
set formatoptions=tcqmMj1
set hidden
set history=2000
set incsearch
set infercase
set laststatus=3
set lazyredraw
set linebreak
set list
set listchars=tab:^-,trail:~,extends:»,precedes:«,nbsp:%
set matchtime=1
" set number
set shiftround
set shortmess+=c
set signcolumn=yes
set splitbelow
set splitright
set switchbuf=usetab
set t_Co=256
set termguicolors
set textwidth=0
set title
set ttyfast
set updatetime=300
set wildmode=list:longest,full

let g:my_vimrc = expand('<sfile>:p')
command! RcEdit execute 'edit' g:my_vimrc
command! RcReload write | execute 'source' g:my_vimrc | nohlsearch | redraw | echo g:my_vimrc . ' is reloaded.'

if !filereadable(expand('~/.vim/autoload/jetpack.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/jetpack.vim --create-dirs'
        \ 'https://raw.githubusercontent.com/tani/vim-jetpack/master/autoload/jetpack.vim'
endif
if !isdirectory(expand('~/.vim/pack/jetpack/src/vim-jetpack'))
  silent execute '!git clone --depth 1 https://github.com/tani/vim-jetpack ~/.vim/pack/jetpack/src/vim-jetpack'
        \ '&& ln -s ~/.vim/pack/jetpack/{src,opt}/vim-jetpack'
endif

call jetpack#begin()
call jetpack#add('tani/vim-jetpack', { 'opt': 1 })

call jetpack#add('junegunn/fzf.vim')
call jetpack#add('junegunn/fzf', { 'do': {-> fzf#install()} })

" Plug 'vim-denops/denops.vim'
" Plug 'vim-skk/skkeleton'
" Plug 'Shougo/ddc.vim'
call jetpack#add('hrsh7th/vim-searchx')
call jetpack#add('sonph/onehalf', { 'rtp': 'vim/' })
call jetpack#add('vim-jp/vimdoc-ja')
call jetpack#end()

function! s:auto_plug_install() abort
  let s:not_installed_plugs = jetpack#names()->copy()
        \ ->filter({_,name->!jetpack#tap(name)})
  if empty(s:not_installed_plugs)
    return
  endif
  echo 'Not installed plugs: ' . string(s:not_installed_plugs)
  if confirm('Install now?', "yes\nno", 2) == 1
    JetpackSync | close | RcReload
  endif
endfunction
augroup vimrc_plug
  autocmd!
  autocmd VimEnter * call s:auto_plug_install()
augroup END
command! Plugs echo jetpack#names()

" {{{ keymap()
function! s:keymap(force_map, modes, ...) abort
  let arg = join(a:000, ' ')
  let cmd = (a:force_map || arg =~? '<Plug>') ? 'map' : 'noremap'
  for mode in split(a:modes, '.\zs')
    if index(split('nvsxoilct', '.\zs'), mode) < 0
      echoerr 'Invalid mode is detected: ' . mode
      continue
    endif
    execute mode .. cmd arg
  endfor
endfunction
command! -nargs=+ -bang Keymap call <SID>keymap(<bang>0, <f-args>)

let s:plug_loaded = {}
function s:ensure_plug(plug_name) abort
  if get(s:plug_loaded, a:plug_name)
    return
  endif
  call plug#load(a:plug_name)
  let s:plug_loaded[a:plug_name] = 1
endfunction
" }}}

" {{{ fuzzy-motion.vim
nnoremap s; <Cmd>FuzzyMotion<CR>
let g:fuzzy_motion_auto_jump = v:true
" }}}

" {{{ searchx
Keymap nx ? <Cmd>call <SID>ensure_plug('vim-searchx')<CR><Cmd>call searchx#start(#{ dir: 0 })<CR>
Keymap nx / <Cmd>call <SID>ensure_plug('vim-searchx')<CR><Cmd>call searchx#start(#{ dir: 1 })<CR>
Keymap nx N <Cmd>call <SID>ensure_plug('vim-searchx')<CR><Cmd>call searchx#prev()<CR>
Keymap nx n <Cmd>call <SID>ensure_plug('vim-searchx')<CR><Cmd>call searchx#next()<CR>
nnoremap <C-l> <Cmd>call <SID>ensure_plug('vim-searchx')<CR><Cmd>call searchx#clear()<CR><Cmd>nohlsearch<CR><C-l>

let g:searchx = {}
let g:searchx.auto_accept = v:true
let g:searchx.scrolloff = &scrolloff
let g:searchx.scrolltime = 500
let g:searchx.markers = split('ASDFGHJKLQWERTYUIOPZXCVBNM', '.\zs')
function g:searchx.convert(input) abort
  if a:input !~# '\k'
    return '\V' .. a:input
  endif
  return a:input->split(' ')->join('.\{-}')
endfunction
" }}}

colorscheme onehalfdark
