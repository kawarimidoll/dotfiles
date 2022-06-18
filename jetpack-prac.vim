let s:source = expand('~/dotfiles/.config/nvim/min-edit.vim')
if filereadable(s:source)
  execute 'source' s:source
endif

let g:did_load_filetypes = 0
let g:do_filetype_lua = 1
set autoindent
set autoread
set cmdheight=0
" set completeopt=longest,menu
set completeopt=menu,menuone,noselect
" set cursorline
set display=lastline
set formatoptions=tcqmMj1
set hidden
set history=2000
set incsearch
set infercase
" set laststatus=3 " set on last line to avoid overwritten by plugins
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
" set t_Co=256
set termguicolors
set textwidth=0
set title
set ttyfast
set updatetime=300
set wildmode=list:longest,full

let g:my_vimrc = expand('<sfile>:p')
command! RcEdit execute 'edit' g:my_vimrc
command! RcReload write | execute 'source' g:my_vimrc | nohlsearch | redraw | echo g:my_vimrc . ' is reloaded.'
command! CopyFullPath     let @*=expand('%:p') | echo 'copy full path'
command! CopyDirName      let @*=expand('%:h') | echo 'copy dir name'
command! CopyFileName     let @*=expand('%:t') | echo 'copy file name'
command! CopyRelativePath let @*=expand('%:h').'/'.expand('%:t') | echo 'copy relative path'
command! VimShowHlGroup echo synID(line('.'), col('.'), 1)->synIDtrans()->synIDattr('name')
command! -nargs=* T split | wincmd j | resize 12 | terminal <args>

if has('nvim')
  if !filereadable(expand('~/.config/nvim/plugin/jetpack.vim'))
    silent execute '!curl -fLo ~/.config/nvim/plugin/jetpack.vim --create-dirs'
          \ 'https://raw.githubusercontent.com/tani/vim-jetpack/master/autoload/jetpack.vim'
  endif
  if !isdirectory(expand('~/.local/share/nvim/site/pack/jetpack/src/vim-jetpack'))
    silent execute '!git clone --depth 1 https://github.com/tani/vim-jetpack ~/.local/share/nvim/site/pack/jetpack/src/vim-jetpack'
          \ '&& ln -s ~/.local/share/nvim/site/pack/jetpack/{src,opt}/vim-jetpack'
  endif
else
  if !filereadable(expand('~/.vim/autoload/jetpack.vim'))
    silent execute '!curl -fLo ~/.vim/autoload/jetpack.vim --create-dirs'
          \ 'https://raw.githubusercontent.com/tani/vim-jetpack/master/autoload/jetpack.vim'
  endif
  if !isdirectory(expand('~/.vim/pack/jetpack/src/vim-jetpack'))
    silent execute '!git clone --depth 1 https://github.com/tani/vim-jetpack ~/.vim/pack/jetpack/src/vim-jetpack'
          \ '&& ln -s ~/.vim/pack/jetpack/{src,opt}/vim-jetpack'
  endif
endif

call jetpack#begin()
call jetpack#add('tani/vim-jetpack', { 'opt': 1 })

call jetpack#add('junegunn/fzf.vim', #{ on: [] })
call jetpack#add('junegunn/fzf', { 'do': {-> fzf#install()} })

" Plug 'vim-skk/skkeleton'
" Plug 'Shougo/ddc.vim'
call jetpack#add('vim-denops/denops.vim')
call jetpack#add('yuki-yano/fuzzy-motion.vim')

call jetpack#add('lewis6991/impatient.nvim')
call jetpack#add('nvim-lualine/lualine.nvim')
call jetpack#add('nvim-lua/plenary.nvim')
call jetpack#add('norcalli/nvim-colorizer.lua')
call jetpack#add('nvim-treesitter/nvim-treesitter', #{ do: ':TSUpdate' })
call jetpack#add('nvim-treesitter/nvim-treesitter-refactor')
call jetpack#add('JoosepAlviste/nvim-ts-context-commentstring')
call jetpack#add('p00f/nvim-ts-rainbow')
call jetpack#add('romgrk/nvim-treesitter-context')
call jetpack#add('lukas-reineke/indent-blankline.nvim')
call jetpack#add('andymass/vim-matchup')
call jetpack#add('lewis6991/gitsigns.nvim')
call jetpack#add('kdheepak/lazygit.nvim', #{ on: 'LazyGit' })
call jetpack#add('tyru/open-browser.vim', #{ on: ['OpenBrowser', '<Plug>(openbrowser-'] })
call jetpack#add('tyru/capture.vim', #{ on: 'Capture' })
call jetpack#add('hrsh7th/vim-searchx', #{ on: [] })
call jetpack#add('monaqa/dps-dial.vim', #{ on: '<Plug>(dps-dial-' })
call jetpack#add('segeljakt/vim-silicon', #{ on: 'Silicon' })
call jetpack#add('simeji/winresizer', #{ on: 'WinResizerStartResize' })
call jetpack#add('echasnovski/mini.nvim')

call jetpack#add('sonph/onehalf', { 'rtp': 'vim/' })
call jetpack#add('vim-jp/vimdoc-ja')
call jetpack#end()

let g:lazygit_floating_window_scaling_factor = 1
let g:silicon = #{
  \   font:   'UDEV Gothic 35JPDOC',
  \   output: '~/Downloads/silicon-{time:%Y-%m-%d-%H%M%S}.png'
  \ }

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

" {{{ fzf.vim
let $FZF_DEFAULT_COMMAND = 'find_for_vim'
nnoremap <Space>a <Cmd>call <SID>ensure_plug('fzf.vim')<CR><Cmd>GFiles?<CR>
nnoremap <Space>b <Cmd>call <SID>ensure_plug('fzf.vim')<CR><Cmd>Buffers<CR>
nnoremap <Space>f <Cmd>call <SID>ensure_plug('fzf.vim')<CR><Cmd>Files<CR>
nnoremap <Space>h <Cmd>call <SID>ensure_plug('fzf.vim')<CR><Cmd>History<CR>
nnoremap <Space>/ <Cmd>call <SID>ensure_plug('fzf.vim')<CR>:<C-u>Rg ""<Left>
nnoremap <Space>? <Cmd>call <SID>ensure_plug('fzf.vim')<CR>:<C-u>Rg ""<Left><C-r><C-f>
nnoremap <Space>: <Cmd>call <SID>ensure_plug('fzf.vim')<CR><Cmd>Commands<CR>
xnoremap <Space>? <Cmd>call <SID>ensure_plug('fzf.vim')<CR>"zy:<C-u>Rg "<C-r>z"<Left>
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
let g:searchx.nohlsearch = #{ jump: v:false }
function g:searchx.convert(input) abort
  if a:input !~# '\k'
    return '\V' .. a:input
  endif
  return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
endfunction
" }}}

" {{{ dps-dial.vim
let g:dps_dial#augends = [
\  'decimal',
\  'date-hyphen',
\  'date-slash',
\  #{ kind: 'constant', opts: #{ elements: ['true', 'false'] } },
\  #{ kind: 'case', opts: #{
\    cases: ['camelCase', 'PascalCase', 'snake_case', 'kebab-case', 'SCREAMING_SNAKE_CASE']
\   } },
\ ]
xmap g<C-a> g<Plug>(dps-dial-increment)
xmap g<C-x> g<Plug>(dps-dial-decrement)
Keymap nx <C-a> <Plug>(dps-dial-increment)
Keymap nx <C-x> <Plug>(dps-dial-decrement)
" }}}

" {{{ openbrowser
Keymap nx gx <Plug>(openbrowser-smart-search)
" }}}

" {{{ winresizer
nnoremap <C-e> <Cmd>WinResizerStartResize<CR>
" }}}

" {{{ user owned mappings
noremap [b <Cmd>bprevious<CR>
noremap ]b <Cmd>bnext<CR>
noremap [B <Cmd>bfirst<CR>
noremap ]B <Cmd>blast<CR>
noremap [q <Cmd>cprevious<CR>
noremap ]q <Cmd>cnext<CR>
noremap [Q <Cmd>cfirst<CR>
noremap ]Q <Cmd>clast<CR>
map M %

" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q qq
nnoremap Q @q
nnoremap <sid>(q)b <Cmd>Gitsigns toggle_current_line_blame<CR>
nnoremap <sid>(q)c <Cmd>cclose<CR>
" nnoremap <sid>(q)m <Cmd>PreviewMarkdownToggle<CR>
nnoremap <sid>(q)o <Cmd>only<CR>
nnoremap <sid>(q)t <C-^>
nnoremap <sid>(q)z <Cmd>lua MiniMisc.zoom()<CR>
" nnoremap <sid>(q)i <Cmd>call <SID>half_move('center')<CR>
" nnoremap <sid>(q)h <Cmd>call <SID>half_move('left')<CR>
" nnoremap <sid>(q)j <Cmd>call <SID>half_move('down')<CR>
" nnoremap <sid>(q)k <Cmd>call <SID>half_move('up')<CR>
" nnoremap <sid>(q)l <Cmd>call <SID>half_move('right')<CR>

nnoremap <Space>d <Cmd>lua MiniBufremove.delete()<CR>
nnoremap <Space>L <Cmd>LazyGit<CR>

" xnoremap <silent> p <Cmd>call <SID>markdown_link_paste()<CR>
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/mappings.rc.vim#L179
" xnoremap <silent> P <Cmd>call <SID>visual_paste('p')<CR>
" }}}

colorscheme onehalfdark

lua << EOF
require('impatient')
require('nvim-treesitter.configs').setup({
  -- {{{ nvim-treesitter
  ensure_installed = {
    "bash", "css", "comment", "dart", "dockerfile", "go", "gomod", "gowork", "graphql",
    "help", "html", "http", "java", "javascript", "jsdoc", "json", "jsonc", "lua",
    "make", "markdown", "pug", "python", "query", "regex", "ruby", "rust", "scss",
    "solidity", "svelte", "todotxt", "toml", "tsx", "typescript", "vim", "vue", "yaml",
  },
  sync_install = false,
  indent = { enable = true },
  -- }}}

  -- {{{ nvim-treesitter-refactor
  refactor = {
    highlight_definitions = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "grd",
        list_definitions = "grD",
        list_definitions_toc = "grt",
        goto_previous_usage = "[u",
        goto_next_usage = "]u",
      },
    },
  },
  -- }}}

  -- {{{ nvim-ts-rainbow
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  -- }}}

  -- {{{ ts-context-commentstring
  context_commentstring = { enable = true },
  -- }}}

  -- {{{ vim-matchup
  matchup = { enable = true },
  -- }}}
})
require('lualine').setup()
require('colorizer').setup()
require('mini.bufremove').setup()
require('mini.comment').setup()
require('mini.cursorword').setup()
require('mini.surround').setup()
require('mini.trailspace').setup()
require('mini.tabline').setup()
require('mini.pairs').setup()
require('mini.misc').setup({ make_global = { 'put', 'put_text', 'zoom' } })
require("indent_blankline").setup({
  space_char_blankline = " ",
  show_current_context = true,
})
require('gitsigns').setup({
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~_' },
  },
  current_line_blame = true,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', gs.stage_hunk)
    map({'n', 'v'}, '<leader>hr', gs.reset_hunk)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})
EOF

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  " https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
  autocmd FileType gitcommit,gina-commit ++once normal! gg
  autocmd FileType gitcommit,gina-commit nnoremap <buffer> <CR> <Cmd>silent! execute 'normal! ^w"zdiw"_dip"zPA: ' <bar> startinsert!<CR>

  " [NeovimのTerminalモードをちょっと使いやすくする](https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal)
  autocmd TermOpen * startinsert

  autocmd BufNewFile,BufRead commonshrc setf bash

  " 前回終了位置に復帰
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | execute 'normal! g`"' | endif
  autocmd BufReadPost * delmarks!

  " [vim-jp » Hack #202: 自動的にディレクトリを作成する](https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html)
  autocmd BufWritePre * call s:ensure_dir(expand('<afile>:p:h'), v:cmdbang)
  function! s:ensure_dir(dir, force)
    if !isdirectory(a:dir) && (a:force || confirm('"' . a:dir . '" does not exist. Create?', "y\nN"))
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END

set laststatus=3 " set on last line to avoid overwritten by plugins
