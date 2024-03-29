let s:source = expand('~/dotfiles/.config/nvim/min-edit.vim')
if filereadable(s:source)
  execute 'source' s:source
endif

" let g:did_load_filetypes = 0
" let g:do_filetype_lua = 1
set autoindent
set autoread
" "set cmdheight=0
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

source ~/dotfiles/.config/nvim/commands.vim
let g:my_vimrc = expand('<sfile>:p')

let s:jetpackfile = (has('nvim') ? '~/.local/share/nvim/site' : '~/.vim') ..
      \ '/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
let s:jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if !filereadable(s:jetpackfile)
  call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpackfile, s:jetpackurl))
endif

packadd vim-jetpack
call jetpack#begin()
call jetpack#add('tani/vim-jetpack', { 'opt': 1 })

let s:fzf_preview_commands = [
      \ 'Buffers',
      \ 'CommandPalette',
      \ 'GitStatus',
      \ 'Jumps',
      \ 'Lines',
      \ 'Marks',
      \ 'ProjectFiles',
      \ 'ProjectGrep',
      \ 'ProjectMruFiles',
      \ ]->map({_,name -> 'FzfPreview' .. name .. 'Rpc'})
call jetpack#add('yuki-yano/fzf-preview.vim', #{ branch: 'release/rpc', on: s:fzf_preview_commands })
call jetpack#add('junegunn/fzf', #{ do: {-> fzf#install()}, on: s:fzf_preview_commands })
call jetpack#add('ryanoasis/vim-devicons', #{ on: s:fzf_preview_commands })

call jetpack#add('vim-denops/denops.vim', #{ on: 'BufReadPost' })
call jetpack#add('yuki-yano/fuzzy-motion.vim', #{ on: 'BufReadPost' })

call jetpack#add('neovim/nvim-lspconfig', #{ on: 'BufReadPost' })
call jetpack#add('williamboman/nvim-lsp-installer', #{ on: 'BufReadPost' })
call jetpack#add('folke/trouble.nvim', #{ on: 'TroubleToggle' })
call jetpack#add('tami5/lspsaga.nvim', #{ on: 'Lspsaga' })

call jetpack#add('Shougo/ddc.vim', #{ on: 'BufReadPost' })
call jetpack#add('Shougo/pum.vim', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('Shougo/ddc-around', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('Shougo/ddc-nvim-lsp', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('LumaKernel/ddc-file', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('octaltree/cmp-look', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('LumaKernel/ddc-tabnine')
call jetpack#add('Shougo/ddc-cmdline', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('Shougo/ddc-cmdline-history', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('Shougo/ddc-matcher_head', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('Shougo/ddc-sorter_rank', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('Shougo/ddc-converter_remove_overlap', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('tani/ddc-fuzzy', #{ on: ['InsertEnter', 'CmdlineEnter'] })
call jetpack#add('matsui54/denops-signature_help', #{ on: 'BufReadPost' })
call jetpack#add('matsui54/denops-popup-preview.vim', #{ on: 'BufReadPost' })
call jetpack#add('vim-skk/skkeleton', #{ on: 'BufReadPost' })

call jetpack#add('lewis6991/impatient.nvim')
call jetpack#add('nvim-telescope/telescope.nvim', #{ on: 'Telescope' })
call jetpack#add('folke/which-key.nvim', #{ on: 'LazyLoadPlugs' })
call jetpack#add('nvim-lua/plenary.nvim', #{ on: 'LazyLoadPlugs' })
call jetpack#add('norcalli/nvim-colorizer.lua', #{ on: 'LazyLoadPlugs' })
call jetpack#add('nvim-treesitter/nvim-treesitter', #{ do: ':TSUpdate', on: 'BufReadPost' })
call jetpack#add('nvim-treesitter/nvim-treesitter-refactor', #{ on: 'BufReadPost' })
call jetpack#add('JoosepAlviste/nvim-ts-context-commentstring', #{ on: 'BufReadPost' })
call jetpack#add('p00f/nvim-ts-rainbow', #{ on: 'BufReadPost' })
call jetpack#add('romgrk/nvim-treesitter-context', #{ on: 'BufReadPost' })
call jetpack#add('andymass/vim-matchup', #{ on: 'BufReadPost' })
call jetpack#add('lewis6991/gitsigns.nvim')
call jetpack#add('kdheepak/lazygit.nvim', #{ on: 'LazyGit' })
call jetpack#add('tyru/open-browser.vim', #{ on: ['OpenBrowser', '<Plug>(openbrowser-'] })
call jetpack#add('tyru/capture.vim', #{ on: 'Capture' })
call jetpack#add('hrsh7th/vim-searchx', #{ on: ['CursorHold', 'CmdlineEnter'] })
call jetpack#add('monaqa/dial.nvim', #{ on: '<Plug>(dial-' })
call jetpack#add('segeljakt/vim-silicon', #{ on: 'Silicon' })
call jetpack#add('simeji/winresizer', #{ on: 'WinResizerStartResize' })
call jetpack#add('echasnovski/mini.nvim')

" call jetpack#add('sonph/onehalf', #{ rtp: 'vim/' })
call jetpack#add('sainnhe/edge')
call jetpack#add('vim-jp/vimdoc-ja')
call jetpack#end()

let g:lazygit_floating_window_scaling_factor = 1
source ~/dotfiles/.config/nvim/plugin_config/silicon.vim

function! s:lazy_load_plugs(timer) abort
  doautocmd User LazyLoadPlugs
  lua require('which-key').setup()
  lua require('colorizer').setup()
endfunction
if !exists('g:loaded_plugs')
  call timer_start(20, function("s:lazy_load_plugs"))
endif
let g:loaded_plugs = 1
autocmd User JetpackTroubleNvimPost ++once lua require('trouble').setup({auto_close = true})
autocmd User JetpackLspsagaNvimPost ++once lua require('lspsaga').setup()

" auto install plugs
" for name in jetpack#names()
"   if !jetpack#tap(name)
"     call jetpack#sync()
"     break
"   endif
" endfor
command! Plugs echo jetpack#names()->copy()->sort()

" {{{ skkeleton
function! s:skkeleton_init() abort
  source ~/dotfiles/.config/nvim/plugin_config/skkeleton.vim
endfunction
autocmd User DenopsStarted ++once call <sid>skkeleton_init()

function! s:skkeleton_enable() abort
  let restore = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer(#{
    \   sources: ['skkeleton'],
    \   sourceOptions: #{ skkeleton: #{
    \     matchers: ['skkeleton'],
    \     sorters: [],
    \   } },
    \ })

  autocmd User skkeleton-disable-pre ++once call ddc#custom#set_buffer(restore)
endfunction

augroup skkeleton-in-vimrc
  autocmd!
  autocmd User skkeleton-enable-pre call <SID>skkeleton_enable()
augroup END
" }}}

" {{{ ddc.vim
function! s:ddc_init() abort
  source ~/dotfiles/.config/nvim/plugin_config/ddc.vim
  call ddc#enable()
endfunction
autocmd User DenopsStarted ++once call <sid>ddc_init()
" }}}

" {{{ fuzzy-motion.vim
nnoremap s; <Cmd>FuzzyMotion<CR>
let g:fuzzy_motion_auto_jump = v:true
" }}}

" " {{{ telescope.nvim
" function! s:telescope_init() abort
"   luafile ~/dotfiles/.config/nvim/plugin_config/telescope.lua
" endfunction
" autocmd User JetpackTelescopeNvimPost ++once call <sid>telescope_init()
" nnoremap <Space>a <cmd>Telescope git_status<cr>
" nnoremap <Space>b <cmd>Telescope buffers<cr>
" nnoremap <Space>f <cmd>Telescope find_files<cr>
" nnoremap <Space>h <cmd>Telescope oldfiles only_cwd=true<cr>
" nnoremap <Space>H <cmd>Telescope help_tags<cr>
" nnoremap <Space>: <cmd>Telescope commands<cr>
" nnoremap <Space>/ <cmd>Telescope live_grep<cr>
" nnoremap <Space>? :<C-u>Telescope grep_string search=<C-r><C-f>
" xnoremap <Space>? "zy:<C-u>Telescope grep_string search=<C-r>=substitute(@z, ' ', '\\ ', 'g')<cr>
" " }}}

" {{{ fzf-preview.vim
source ~/dotfiles/.config/nvim/plugin_config/fzf_preview.vim

nnoremap <Space>a <Cmd>FzfPreviewGitStatusRpc<CR>
nnoremap <Space>b <Cmd>FzfPreviewBuffersRpc<CR>
nnoremap <Space>f <Cmd>FzfPreviewProjectFilesRpc<CR>
nnoremap <Space>h <Cmd>FzfPreviewProjectMruFilesRpc<CR>
nnoremap <Space>j <Cmd>FzfPreviewJumpsRpc<CR>
nnoremap <Space>l <Cmd>FzfPreviewLinesRpc<CR>
nnoremap <Space>m <Cmd>FzfPreviewMarksRpc<CR>
nnoremap <Space>/ :<C-u>FzfPreviewProjectGrepRpc ""<Left>
nnoremap <Space>? :<C-u>FzfPreviewProjectGrepRpc ""<Left><C-r><C-f>
nnoremap <Space>: <Cmd>FzfPreviewCommandPaletteRpc<CR>
xnoremap <Space>? "zy:<C-u>FzfPreviewProjectGrepRpc "<C-r>z"<Left>
" }}}

" {{{ searchx
function s:searchx_init() abort
  Keymap nx ? <Cmd>call searchx#start(#{ dir: 0 })<CR>
  Keymap nx / <Cmd>call searchx#start(#{ dir: 1 })<CR>
  Keymap nx N <Cmd>call searchx#prev()<CR>
  Keymap nx n <Cmd>call searchx#next()<CR>
  nnoremap <C-l> <Cmd>call searchx#clear()<CR><Cmd>nohlsearch<CR><C-l>
  source ~/dotfiles/.config/nvim/plugin_config/searchx.vim
endfunction
autocmd User JetpackVimSearchxPost ++once call <sid>searchx_init()
" }}}

" {{{ dial.vim
function s:dial_init() abort
  luafile ~/dotfiles/.config/nvim/plugin_config/dial.lua
endfunction
xmap g<C-a> g<Plug>(dial-increment)
xmap g<C-x> g<Plug>(dial-decrement)
Keymap nx <C-a> <Plug>(dial-increment)
Keymap nx <C-x> <Plug>(dial-decrement)
autocmd User JetpackDialNvimPost ++once call <sid>dial_init()
" }}}

" {{{ openbrowser
Keymap nx gx <Cmd>SmartOpen<CR>
" Keymap nx gx <Plug>(openbrowser-smart-search)
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
nnoremap <sid>(q)d <Cmd>TroubleToggle<CR>
nnoremap <sid>(q)o <Cmd>only<CR>
nnoremap <sid>(q)t <C-^>
nnoremap <sid>(q)z <Cmd>lua MiniMisc.zoom()<CR>
nnoremap <sid>(q)k <Cmd>syntax off<CR><Cmd>lua MiniJump2d.start(MiniJump2d.builtin_opts.single_character)<CR>
nnoremap <sid>(q)u <Cmd>TroubleToggle lsp_references<CR>
" nnoremap <sid>(q)i <Cmd>call <SID>half_move('center')<CR>
" nnoremap <sid>(q)h <Cmd>call <SID>half_move('left')<CR>
" nnoremap <sid>(q)j <Cmd>call <SID>half_move('down')<CR>
" nnoremap <sid>(q)k <Cmd>call <SID>half_move('up')<CR>
" nnoremap <sid>(q)l <Cmd>call <SID>half_move('right')<CR>

nnoremap <Space>d <Cmd>keepalt lua MiniBufremove.delete()<CR>
nnoremap <Space>L <Cmd>LazyGit<CR>
" }}}

" {{{ colorscheme
let g:edge_style = 'aura'
let g:edge_better_performance = 1
let g:edge_dim_foreground = 1
colorscheme edge
" colorscheme onehalfdark
" }}}

" {{{ lspsaga
nnoremap <silent> gh <Cmd>Lspsaga lsp_finder<CR>
nnoremap <silent> grr <Cmd>Lspsaga rename<CR>
nnoremap <silent> gD <Cmd>Lspsaga preview_definition<CR>
nnoremap <silent> <leader>ca <Cmd>Lspsaga code_action<CR>
vnoremap <silent> <leader>ca <Cmd>Lspsaga range_code_action<CR>

nnoremap <silent> <leader>cd <Cmd>Lspsaga show_line_diagnostics<CR>
nnoremap <silent> <leader>cc <Cmd>Lspsaga show_cursor_diagnostics<CR>
nnoremap <silent> [d <Cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]d <Cmd>Lspsaga diagnostic_jump_prev<CR>

nnoremap <silent><expr> K
      \ &filetype=~'vim\\|help' ? 'K' : '<Cmd>Lspsaga hover_doc<CR>'

nnoremap <silent> <C-f> <Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<C-f>')<CR>
nnoremap <silent> <C-b> <Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<C-b>')<CR>
" }}}

lua require('impatient')

luafile ~/dotfiles/.config/nvim/plugin_config/lsp.lua
luafile ~/dotfiles/.config/nvim/plugin_config/treesitter.lua
luafile ~/dotfiles/.config/nvim/plugin_config/gitsigns.lua
luafile ~/dotfiles/.config/nvim/plugin_config/mini.lua

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  " https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
  autocmd FileType gitcommit,gina-commit nnoremap <buffer> <CR> <Cmd>silent! execute 'normal! ^w"zdiw"_dip"zPA: ' <bar> startinsert!<CR>

  " [NeovimのTerminalモードをちょっと使いやすくする](https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal)
  autocmd TermOpen * startinsert

  autocmd BufNewFile,BufRead commonshrc setf bash

  autocmd BufReadPost * delmarks!
augroup END

highlight WinSeparator ctermfg=250 ctermbg=NONE guifg=#97a4b5 guibg=NONE
set laststatus=3 " set on last line to avoid overwritten by plugins
