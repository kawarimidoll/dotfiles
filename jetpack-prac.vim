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
command! Trim lua MiniTrailspace.trim()
command! VimShowHlGroup echo synID(line('.'), col('.'), 1)->synIDtrans()->synIDattr('name')
command! -nargs=* T split | wincmd j | resize 12 | terminal <args>
function s:DexComplete(A,L,P)
  return ['--quiet', '--compat']
endfunction
command! -nargs=* -bang -complete=customlist,s:DexComplete Dex silent only! | botright 12 split |
  \ execute 'terminal' (has('nvim') ? '' : '++curwin') 'deno run --no-check --allow-all'
  \    '--unstable --watch' (<bang>0 ? '' : '--no-clear-screen') <q-args> expand('%:p') |
  \ stopinsert | execute 'normal! G' | set bufhidden=wipe |
  \ execute 'autocmd BufEnter <buffer> if winnr("$") == 1 | quit! | endif' |
  \ file Dex<bang> | wincmd k

if has('nvim')
  " if !filereadable(expand('~/.config/nvim/plugin/jetpack.vim'))
  "   silent execute '!curl -fLo ~/.config/nvim/plugin/jetpack.vim --create-dirs'
  "         \ 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
  " endif
  if !isdirectory(expand('~/.local/share/nvim/site/pack/jetpack/src/vim-jetpack'))
    silent execute '!git clone --depth 1 https://github.com/tani/vim-jetpack ~/.local/share/nvim/site/pack/jetpack/src/vim-jetpack'
          \ '&& ln -s ~/.local/share/nvim/site/pack/jetpack/{src,opt}/vim-jetpack'
  endif
else
  " if !filereadable(expand('~/.vim/plugin/jetpack.vim'))
  "   silent execute '!curl -fLo ~/.vim/plugin/jetpack.vim --create-dirs'
  "         \ 'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
  " endif
  if !isdirectory(expand('~/.vim/pack/jetpack/src/vim-jetpack'))
    silent execute '!git clone --depth 1 https://github.com/tani/vim-jetpack ~/.vim/pack/jetpack/src/vim-jetpack'
          \ '&& ln -s ~/.vim/pack/jetpack/{src,opt}/vim-jetpack'
  endif
endif

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

call jetpack#add('vim-denops/denops.vim')
call jetpack#add('yuki-yano/fuzzy-motion.vim')

call jetpack#add('neovim/nvim-lspconfig')
call jetpack#add('williamboman/nvim-lsp-installer')
call jetpack#add('folke/trouble.nvim', #{ on: 'TroubleToggle' })
call jetpack#add('tami5/lspsaga.nvim', #{ on: 'Lspsaga' })

call jetpack#add('Shougo/ddc.vim')
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
call jetpack#add('matsui54/denops-signature_help')
call jetpack#add('matsui54/denops-popup-preview.vim')
call jetpack#add('vim-skk/skkeleton')

call jetpack#add('lewis6991/impatient.nvim')
call jetpack#add('folke/which-key.nvim', #{ on: 'LazyLoadPlugs' })
call jetpack#add('nvim-lua/plenary.nvim', #{ on: 'LazyLoadPlugs' })
call jetpack#add('norcalli/nvim-colorizer.lua', #{ on: 'LazyLoadPlugs' })
call jetpack#add('nvim-treesitter/nvim-treesitter', #{ do: ':TSUpdate' })
call jetpack#add('nvim-treesitter/nvim-treesitter-refactor')
call jetpack#add('JoosepAlviste/nvim-ts-context-commentstring')
call jetpack#add('p00f/nvim-ts-rainbow')
call jetpack#add('romgrk/nvim-treesitter-context')
call jetpack#add('andymass/vim-matchup')
call jetpack#add('lewis6991/gitsigns.nvim')
call jetpack#add('kdheepak/lazygit.nvim', #{ on: 'LazyGit' })
call jetpack#add('tyru/open-browser.vim', #{ on: ['OpenBrowser', '<Plug>(openbrowser-'] })
call jetpack#add('tyru/capture.vim', #{ on: 'Capture' })
call jetpack#add('hrsh7th/vim-searchx', #{ on: 'CmdlineEnter' })
call jetpack#add('monaqa/dial.nvim', #{ on: '<Plug>(dial-' })
call jetpack#add('segeljakt/vim-silicon', #{ on: 'Silicon' })
call jetpack#add('simeji/winresizer', #{ on: 'WinResizerStartResize' })
call jetpack#add('echasnovski/mini.nvim')

" call jetpack#add('sonph/onehalf', #{ rtp: 'vim/' })
call jetpack#add('sainnhe/edge')
call jetpack#add('vim-jp/vimdoc-ja')
call jetpack#end()

let g:lazygit_floating_window_scaling_factor = 1
let g:silicon = #{
  \   font:   'UDEV Gothic 35JPDOC',
  \   output: '~/Downloads/silicon-{time:%Y-%m-%d-%H%M%S}.png'
  \ }

function! s:lazy_load_plugs(timer) abort
  doautocmd User LazyLoadPlugs
  lua require('which-key').setup()
  lua require('colorizer').setup()
endfunction
if !exists('g:loaded_plugs')
  call timer_start(20, function("s:lazy_load_plugs"))
endif
let g:loaded_plugs = 1
autocmd User JetpackTroubleNvimPost lua require('trouble').setup({auto_close = true})
autocmd User JetpackLspsagaNvimPost lua require('lspsaga').setup()

" auto install plugs
" for name in jetpack#names()
"   if !jetpack#tap(name)
"     call jetpack#sync()
"     break
"   endif
" endfor
command! Plugs echo jetpack#names()->copy()->sort()

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
" }}}

" {{{ skkeleton
map! <C-j> <Plug>(skkeleton-enable)

let s:jisyo_dir = stdpath('config')
let s:jisyo_name = 'SKK-JISYO.L'
let s:jisyo_path = expand(s:jisyo_dir . '/' . s:jisyo_name)
if !filereadable(s:jisyo_path)
  echo "SSK Jisyo does not exists! '" . s:jisyo_path . "' is required!"
  let s:skk_setup_cmds = [
    \   "curl -OL https://skk-dev.github.io/dict/SKK-JISYO.L.gz",
    \   "gunzip SKK-JISYO.L.gz",
    \   "mkdir -p " . s:jisyo_dir,
    \   "mv ./SKK-JISYO.L " . s:jisyo_dir,
    \ ]
  echo (["To get Jisyo, run:"] + s:skk_setup_cmds + [""])->join("\n")

  if confirm("Run automatically?", "y\nN") == 1
    echo "Running..."
    call system(s:skk_setup_cmds->join(" && "))
    echo "Done."
  endif
endif

function! s:skkeleton_init() abort
  let l:rom_table = {
    \   'z9': ['（', ''],
    \   'z0': ['）', ''],
    \   "z\<Space>": ["\u3000", ''],
    \ }
  for char in split('abcdefghijklmnopqrstuvwxyz,._-!?', '.\zs')
    let l:rom_table['c'.char] = [char, '']
  endfor

  call skkeleton#config(#{
    \   eggLikeNewline: v:true,
    \   globalJisyo: s:jisyo_path,
    \   immediatelyCancel: v:false,
    \   registerConvertResult: v:true,
    \   selectCandidateKeys: '1234567',
    \   showCandidatesCount: 1,
    \ })
  call skkeleton#register_kanatable('rom', l:rom_table)
endfunction

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

augroup skkeleton
  autocmd!
  autocmd User skkeleton-enable-pre call <SID>skkeleton_enable()
  autocmd User skkeleton-initialize-pre call <SID>skkeleton_init()
augroup END
" }}}

" {{{ ddc.vim
call ddc#custom#patch_global('completionMenu', 'pum.vim')
call ddc#custom#patch_global('autoCompleteEvents',
    \ ['InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged'])
call ddc#custom#patch_global('sources', [
  \ 'nvim-lsp',
  \ 'tabnine',
  \ 'around',
  \ 'file',
  \ 'look',
  \ ])
call ddc#custom#patch_global('sourceOptions', {
  \ '_': {
  \   'matchers': ['matcher_head'],
  \   'sorters': ['sorter_rank'],
  \   'converters': ['converter_remove_overlap'],
  \   'minAutoCompleteLength': 2,
  \ },
  \ 'nvim-lsp': {
  \   'mark': 'LSP',
  \   'forceCompletionPattern': '\.\w*|:\w*|->\w*',
  \ },
  \ 'tabnine': {
  \   'mark': 'TN',
  \   'maxItems': 5,
  \   'isVolatile': v:true,
  \ },
  \ 'look': {
  \   'mark': 'look',
  \   'maxItems': 5,
  \   'isVolatile': v:true,
  \ },
  \ 'file': {
  \   'mark': 'F',
  \   'isVolatile': v:true,
  \   'forceCompletionPattern': '\S/\S*',
  \   'ignoreCase': v:true,
  \   'matchers': ['matcher_fuzzy'],
  \   'sorters': ['sorter_fuzzy'],
  \   'converters': ['converter_fuzzy']
  \ },
  \ 'around': {'mark': 'A'},
  \ 'cmdline': {
  \   'mark': 'CMD',
  \   'forceCompletionPattern': '\S/\S*',
  \   'ignoreCase': v:true,
  \   'matchers': ['matcher_fuzzy'],
  \   'sorters': ['sorter_fuzzy'],
  \   'converters': ['converter_fuzzy']
  \ },
  \ 'cmdline-history': {
  \   'mark': 'H',
  \   'ignoreCase': v:true,
  \   'sorters': [],
  \ },
  \ })

nnoremap : <Cmd>call <sid>ddc_commandline_pre()<CR>:

function! s:ddc_commandline_pre() abort
  " Overwrite sources
  if !exists('b:prev_buffer_config')
    let b:prev_buffer_config = ddc#custom#get_buffer()
  endif
  call ddc#custom#patch_buffer('cmdlineSources', ['cmdline', 'cmdline-history', 'around', 'file', 'look'])

  autocmd User DDCCmdlineLeave ++once call <sid>ddc_commandline_post()
  autocmd InsertEnter <buffer> ++once call <sid>ddc_commandline_post()

  " Enable command line completion
  call ddc#enable_cmdline_completion()
endfunction
function! s:ddc_commandline_post() abort
  " Restore sources
  if exists('b:prev_buffer_config')
    call ddc#custom#set_buffer(b:prev_buffer_config)
    unlet b:prev_buffer_config
  else
    call ddc#custom#set_buffer({})
  endif
endfunction

call ddc#enable()
call popup_preview#enable()
call signature_help#enable()
Keymap ic <silent><expr> <Tab>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<Tab>'
Keymap ic <silent><expr> <S-Tab>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<S-Tab>'
" Keymap ic <silent><expr> <C-n>
"       \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<Down>'
" Keymap ic <silent><expr> <C-p>
"       \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<Up>'
Keymap ic <silent><expr> <C-y>
      \ pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<C-y>'
Keymap ic <silent><expr> <C-e>
      \ pum#visible() ? '<Cmd>call pum#map#cancel()<CR>'  : '<C-e>'
Keymap i <silent><expr> <CR>
      \ pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" }}}

" {{{ fuzzy-motion.vim
nnoremap s; <Cmd>FuzzyMotion<CR>
let g:fuzzy_motion_auto_jump = v:true
" }}}

" {{{ fzf-preview.vim
let g:fzf_preview_filelist_command = 'find_for_vim'
let g:fzf_preview_fzf_preview_window_option = 'down:70%'
let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_default_fzf_options = {
      \ '--reverse': v:true,
      \ '--preview-window': 'wrap',
      \ '--cycle': v:true,
      \ '--no-sort': v:true,
      \ }

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
endfunction
autocmd User JetpackVimSearchxPost ++once call <sid>searchx_init()

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

" {{{ dial.vim
function s:dial_init() abort
lua << EOF
local augend = require("dial.augend")
require("dial.config").augends:register_group{
  default = {
    augend.integer.alias.decimal,
    augend.semver.alias.semver,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%m/%d"],
    augend.date.alias["%-m/%-d"],
    augend.date.alias["%H:%M:%S"],
    augend.date.alias["%H:%M"],
    augend.constant.alias.bool,
    augend.constant.alias.ja_weekday,
    augend.constant.alias.ja_weekday_full,
    augend.constant.new{ elements = {"and", "or"}, },
    augend.constant.new{
      elements = {"&&", "||"},
      word = false,
    },
    augend.constant.new{ elements = {"let", "const"}, },
    augend.user.new{
      find = require("dial.augend.common").find_pattern("%u+"),
      add = function(text, _, cursor)
        text = text:lower()
        return {text = text, cursor = #text}
      end
    },
    augend.user.new{
      find = require("dial.augend.common").find_pattern("%u%l+"),
      add = function(text, _, cursor)
        text = text:upper()
        return {text = text, cursor = #text}
      end
    },
    augend.user.new{
      find = require("dial.augend.common").find_pattern("%l+"),
      add = function(text, _, cursor)
        text = text:sub(1,1):upper() .. text:sub(2)
        return {text = text, cursor = #text}
      end
    },
    augend.case.new{
      types = {"camelCase", "PascalCase", "snake_case", "kebab-case", "SCREAMING_SNAKE_CASE"},
    },
  },
}
EOF
endfunction
xmap g<C-a> g<Plug>(dial-increment)
xmap g<C-x> g<Plug>(dial-decrement)
Keymap nx <C-a> <Plug>(dial-increment)
Keymap nx <C-x> <Plug>(dial-decrement)
autocmd User JetpackDialNvimPost ++once call <sid>dial_init()
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

nnoremap <Space>d <Cmd>lua MiniBufremove.delete()<CR>
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
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "gd",
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
local nvim_lsp = require('lspconfig')
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {}
  if server.name == "tsserver" then
    opts.root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
    opts.settings = { documentFormatting = false }
    opts.init_options = { hostInfo = "neovim" }
  elseif server.name == "eslint" then
    opts.root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
  elseif server.name == "denols" then
    opts.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
    opts.init_options = {
      lint = true,
      unstable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
            ["https://cdn.nest.land"] = true,
            ["https://crux.land"] = true
          }
        }
      }
    }
  end

  opts.on_attach = function(client, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>p', vim.lsp.buf.formatting, bufopts)
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)
require('mini.bufremove').setup()
require('mini.comment').setup()
require('mini.cursorword').setup()
require('mini.indentscope').setup()
require('mini.jump2d').setup({
  hooks = { after_jump = function() vim.cmd('syntax on') end },
  mappings = { start_jumping = '' },
})
require('mini.surround').setup()
require('mini.statusline').setup({
  set_vim_settings = false,
})
require('mini.trailspace').setup()
require('mini.tabline').setup()
require('mini.pairs').setup()
require('mini.misc').setup({ make_global = { 'put', 'put_text', 'zoom' } })
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
    -- map('n', '<leader>hR', gs.reset_buffer)
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

function! EditProjectMru() abort
  let cmd = 'git rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1'
  let root = system(cmd)->trim()->expand()
  if root == ''
    return
  endif
  for file in v:oldfiles
    if file =~ root && file !~ '\.git/' && filereadable(file)
      execute 'edit' file
      break
    endif
  endfor
endfunction

function! s:collect_yank_history() abort
  " regs should be start with double quote
  let regs = '"abcde'->split('\zs')
  for index in range(len(regs)-1, 1, -1)
    call setreg(regs[index], getreginfo(regs[index-1]))
  endfor
endfunction
function! s:clear_regs() abort
  for r in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/'->split('\zs')
    call setreg(r, [])
  endfor
endfunction
command! ClearRegs call <SID>clear_regs()

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  autocmd TextYankPost * call <SID>collect_yank_history()
  autocmd VimEnter * ClearRegs
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

highlight MiniJump2dSpot ctermfg=209 ctermbg=NONE cterm=underline,bold guifg=#E27878 guibg=NONE gui=underline,bold
highlight link MiniStatuslineDevinfo String
highlight WinSeparator ctermfg=250 ctermbg=NONE guifg=#97a4b5 guibg=NONE
set laststatus=3 " set on last line to avoid overwritten by plugins
