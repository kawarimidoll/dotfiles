if filereadable(expand('~/dotfiles/.config/nvim/min-edit.vim'))
  source ~/dotfiles/.config/nvim/min-edit.vim
endif

" to get dictionary:
" curl -OL https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt
" mkdir -p ~/.cache/nvim
" mv ./google-10000-english-no-swears.txt ~/.cache/nvim

" let g:did_load_filetypes = 0
" let g:do_filetype_lua = 1
set autoindent
set autoread
" set cmdheight=2
" set completeopt=longest,menu
set completeopt=menu,menuone,noselect
set cursorline
set display=lastline
set dictionary=~/.cache/nvim/google-10000-english-no-swears.txt
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
set number
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
set wildmode=longest,full
let g:markdown_fenced_languages = ['ts=typescript', 'js=javascript']

source ~/dotfiles/.config/nvim/qfutils.vim
source ~/dotfiles/.config/nvim/commands.vim
let g:my_vimrc = expand('<sfile>:p')
Keymap nx gf <Cmd>SmartOpen<CR>

"-----------------
" Plugs
"-----------------
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let s:autoload_plug_path = has('nvim') ? stdpath('data') .. '/site' : '~/.vim'
if empty(glob(s:autoload_plug_path))
  silent execute '!curl --create-dirs -fLo ' .. s:autoload_plug_path ..
        \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \ |   PlugInstall --sync | source $MYVIMRC
      \ | endif

call plug#begin(stdpath('config') .. '/plugged')
Plug 'vim-denops/denops.vim', #{ on: [] }
Plug 'vim-skk/skkeleton', #{ on: [] }
Plug 'Shougo/ddc.vim', #{ on: [] }
Plug 'yuki-yano/fuzzy-motion.vim', #{ on: [] }

Plug 'hrsh7th/cmp-nvim-lsp', #{ on: [] }
Plug 'hrsh7th/cmp-buffer', #{ on: [] }
Plug 'hrsh7th/cmp-path', #{ on: [] }
Plug 'hrsh7th/cmp-cmdline', #{ on: [] }
Plug 'hrsh7th/nvim-cmp', #{ on: [] }

Plug 'hrsh7th/cmp-vsnip', #{ on: [] }
Plug 'hrsh7th/cmp-nvim-lua', #{ on: [] }
Plug 'ray-x/cmp-treesitter', #{ on: [] }
Plug 'tzachar/cmp-tabnine', #{ do: './install.sh', on: [] }
Plug 'lukas-reineke/cmp-rg', #{ on: [] }
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol', #{ on: [] }
Plug 'f3fora/cmp-spell', #{ on: [] }
Plug 'octaltree/cmp-look', #{ on: [] }
Plug 'rinx/cmp-skkeleton', #{ on: [] }
Plug 'onsails/lspkind-nvim', #{ on: [] }

Plug 'hrsh7th/vim-vsnip', #{ on: [] }
Plug 'hrsh7th/vim-vsnip-integ', #{ on: [] }
Plug 'rafamadriz/friendly-snippets', #{ on: [] }
Plug 'kevinhwang91/nvim-hclipboard', #{ on: [] }

Plug 'lewis6991/impatient.nvim'
Plug 'neovim/nvim-lspconfig', #{ on: [] }
Plug 'williamboman/nvim-lsp-installer', #{ on: [] }
Plug 'ray-x/lsp_signature.nvim', #{ on: [] }
Plug 'kyazdani42/nvim-web-devicons', #{ on: [] }
Plug 'tami5/lspsaga.nvim', #{ on: [] }
" Plug 'folke/lsp-colors.nvim'
Plug 'folke/trouble.nvim', #{ on: [] }
Plug 'folke/lua-dev.nvim', #{ for: 'lua' }

Plug 'nvim-treesitter/nvim-treesitter', #{ do: ':TSUpdate', on: [] }
Plug 'nvim-treesitter/nvim-treesitter-textobjects', #{ on: [] }
Plug 'nvim-treesitter/nvim-treesitter-refactor', #{ on: [] }
Plug 'JoosepAlviste/nvim-ts-context-commentstring', #{ on: [] }
Plug 'p00f/nvim-ts-rainbow', #{ on: [] }
Plug 'romgrk/nvim-treesitter-context', #{ on: [] }
Plug 'David-Kunz/treesitter-unit', #{ on: [] }
Plug 'mfussenegger/nvim-ts-hint-textobject', #{ on: [] }
Plug 'andymass/vim-matchup', #{ on: [] }

Plug 'ibhagwan/fzf-lua', #{ branch: 'main', on: 'FzfLua' }
Plug 'rlane/pounce.nvim', #{ on: 'Pounce' }
Plug 'kevinhwang91/nvim-bqf', #{ for: 'qf'}

Plug 'junegunn/fzf', #{ do: { -> fzf#install() }, on: [] }
Plug 'yuki-yano/fzf-preview.vim', #{ branch: 'release/rpc', on: [] }
Plug 'ryanoasis/vim-devicons', #{ on: [] }

Plug 'nvim-lua/plenary.nvim', #{ on: []}

Plug 'folke/which-key.nvim', #{ on: [] }
Plug 'echasnovski/mini.nvim'
Plug 'norcalli/nvim-colorizer.lua', #{ on: [] }
Plug 'lewis6991/gitsigns.nvim'
Plug 'kat0h/bufpreview.vim', #{ on: 'PreviewMarkdown' }
Plug 'lambdalisue/gin.vim', #{ on: [] }
Plug 'lambdalisue/reword.vim', #{ on: [] }
Plug 'kdheepak/lazygit.nvim', #{ on: 'LazyGit' }
Plug 'tyru/open-browser.vim', #{ on: ['OpenBrowser', '<Plug>(openbrowser-'] }
Plug 'tyru/capture.vim', #{ on: 'Capture' }
Plug 'hrsh7th/vim-searchx', #{ on: [] }
Plug 'haya14busa/vim-asterisk', #{ on: '<Plug>(asterisk-' }
Plug 'voldikss/vim-floaterm', #{ on: 'FloatermNew' }
" Plug 'monaqa/dps-dial.vim', #{ on: '<Plug>(dps-dial-' }
Plug 'segeljakt/vim-silicon', #{ on: 'Silicon' }
Plug 'monaqa/dial.nvim', #{ on: '<Plug>(dial-' }
Plug 'simeji/winresizer', #{ on: 'WinResizerStartResize' }
Plug 'vim-jp/vimdoc-ja'

call plug#end()

let g:lazygit_floating_window_scaling_factor = 1
" let g:lazygit_floating_window_winblend = 20
source ~/dotfiles/.config/nvim/plugin_config/silicon.vim

" let s:plug_loaded = {}
" function s:ensure_plug(...) abort
"   for plug in a:000
"     if !get(s:plug_loaded, plug)
"       call plug#load(plug)
"       let s:plug_loaded[plug] = 1
"     endif
"   endfor
" endfunction
" command! -nargs=+ -bang EnsurePlug call <sid>ensure_plug(<f-args>)

function! s:treesitter_init() abort
  " https://zenn.dev/kawarimidoll/articles/8e124a88dde820
  call plug#load(
        \ 'nvim-treesitter',
        \ 'nvim-treesitter-textobjects',
        \ 'nvim-treesitter-refactor',
        \ 'nvim-ts-context-commentstring',
        \ 'nvim-ts-rainbow',
        \ 'nvim-treesitter-context',
        \ 'treesitter-unit',
        \ 'nvim-ts-hint-textobject',
        \ 'vim-matchup',
        \ )
  execute 'luafile' g:plug_home .. '/nvim-treesitter/plugin/nvim-treesitter.lua'
  luafile ~/dotfiles/.config/nvim/plugin_config/treesitter.lua
  TSEnable highlight

  " do not replace to <cmd>
  omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
  vnoremap <silent> m :lua require('tsht').nodes()<CR>
  xnoremap iu :lua require"treesitter-unit".select()<CR>
  xnoremap au :lua require"treesitter-unit".select(true)<CR>
  onoremap iu :<c-u>lua require"treesitter-unit".select()<CR>
  onoremap au :<c-u>lua require"treesitter-unit".select(true)<CR>
endfunction

function s:vsnip_init() abort

  call plug#load(
        \ 'vim-vsnip',
        \ 'vim-vsnip-integ',
        \ 'friendly-snippets',
        \ 'nvim-hclipboard',
        \ )
  " execute 'source' g:plug_home .. '/vim-vsnip/plugin/vsnip.vim'
  " execute 'source' g:plug_home .. '/vim-vsnip-integ/plugin/vsnip_integ.vim'

  let g:vsnip_filetypes = {}
  let g:vsnip_filetypes.javascriptreact = ['javascript']
  let g:vsnip_filetypes.typescriptreact = ['typescript']
  " imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  " smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
  " smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
  " smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
  smap j <BS>j
  smap k <BS>k
  Keymap is <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  Keymap nx st <Plug>(vsnip-select-text)
  Keymap nx sT <Plug>(vsnip-cut-text)
  lua require('hclipboard').start()
endfunction

function s:cmp_init() abort
  call plug#load(
        \ 'cmp-nvim-lsp',
        \ 'cmp-buffer',
        \ 'cmp-path',
        \ 'cmp-cmdline',
        \ 'nvim-cmp',
        \ 'cmp-vsnip',
        \ 'cmp-nvim-lua',
        \ 'cmp-treesitter',
        \ 'cmp-tabnine',
        \ 'cmp-rg',
        \ 'cmp-nvim-lsp-document-symbol',
        \ 'cmp-spell',
        \ 'cmp-look',
        \ 'lspkind-nvim',
        \ )
  " \ 'cmp-skkeleton',
  " execute 'luafile' g:plug_home .. '/nvim-cmp/plugin/cmp.lua'
  luafile ~/dotfiles/.config/nvim/plugin_config/cmp.lua
endfunction

function s:lsp_init() abort
  call plug#load(
        \ 'nvim-lspconfig',
        \ 'nvim-lsp-installer',
        \ 'lsp_signature.nvim',
        \ 'cmp-nvim-lsp',
        \ 'lspsaga.nvim',
        \ )
  lua require("lsp_signature").setup()
  lua lsp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  luafile ~/dotfiles/.config/nvim/plugin_config/lsp.lua
endfunction

call <sid>vsnip_init()
call <sid>cmp_init()
function s:plug_buf_read_post() abort
  call <sid>treesitter_init()
  call <sid>lsp_init()

  call plug#load(
        \ 'gin.vim',
        \ 'reword.vim',
        \ 'which-key.nvim',
        \ 'nvim-colorizer.lua',
        \ 'nvim-web-devicons',
        \ 'trouble.nvim',
        \ 'plenary.nvim',
        \ 'vim-searchx',
        \ )

  source ~/dotfiles/.config/nvim/plugin_config/searchx.vim
  execute 'source' g:plug_home .. '/plenary.nvim/plugin/plenary.vim'
  luafile ~/dotfiles/.config/nvim/plugin_config/which-key.lua
  lua require('colorizer').setup()
  lua require('trouble').setup({auto_close = true})
endfunction
augroup plug_buf_read_post
  autocmd!
  autocmd BufReadPost * call <sid>plug_buf_read_post() | autocmd! plug_buf_read_post
augroup END

function s:plug_vim_enter() abort
  call plug#load(
        \ 'denops.vim',
        \ 'skkeleton',
        \ 'fuzzy-motion.vim',
        \ 'ddc.vim',
        \ 'fzf',
        \ 'fzf-preview.vim',
        \ 'vim-devicons',
        \ )

  source ~/dotfiles/.config/nvim/plugin_config/skkeleton.vim
  source ~/dotfiles/.config/nvim/plugin_config/skk_ddc_cmp.vim
  source ~/dotfiles/.config/nvim/plugin_config/fzf_preview.vim
endfunction
augroup plug_vim_enter
  autocmd!
  autocmd BufReadPost * call <sid>plug_vim_enter() | autocmd! plug_vim_enter
augroup END

" {{{ fuzzy-motion.vim
let g:fuzzy_motion_labels = split('JFKDLSAHGNUVRBYTMICEOXWPQZ', '.\zs')
Keymap nx s; <Cmd>FuzzyMotion<CR>
" }}}

" {{{ searchx
Keymap nx ? <Cmd>call searchx#start(#{ dir: 0 })<CR>
Keymap nx / <Cmd>call searchx#start(#{ dir: 1 })<CR>
Keymap nx N <Cmd>call searchx#prev()<CR>
Keymap nx n <Cmd>call searchx#next()<CR>
nnoremap <C-l> <Cmd>call searchx#clear()<CR><Cmd>nohlsearch<CR><C-l>
" }}}

" {{{ dial.nvim
function s:dial_init() abort
  luafile ~/dotfiles/.config/nvim/plugin_config/dial.lua
endfunction
xmap g<C-a> g<Plug>(dial-increment)
xmap g<C-x> g<Plug>(dial-decrement)
Keymap nx <C-a> <Plug>(dial-increment)
Keymap nx <C-x> <Plug>(dial-decrement)
autocmd User dial.nvim ++once call <sid>dial_init()
" }}}

" {{{ vim-asterisk
let g:asterisk#keeppos = 1
Keymap nx *  <Plug>(asterisk-z*)
Keymap nx #  <Plug>(asterisk-z#)
Keymap nx g* <Plug>(asterisk-gz*)
Keymap nx g# <Plug>(asterisk-gz#)
" }}}

" {{{ pounce.nvim
Keymap nx s' <Cmd>Pounce<CR>
function s:pounce_init() abort
  highlight PounceMatch      cterm=underline,bold ctermfg=gray ctermbg=214 gui=underline,bold guifg=#555555 guibg=#FFAF60
  highlight PounceGap        cterm=underline,bold ctermfg=gray ctermbg=209 gui=underline,bold guifg=#555555 guibg=#E27878
  highlight PounceAccept     cterm=underline,bold ctermfg=214 ctermbg=gray gui=underline,bold guifg=#FFAF60 guibg=#555555
  highlight PounceAcceptBest cterm=underline,bold ctermfg=196 ctermbg=gray gui=underline,bold guifg=#EE2513 guibg=#555555
endfunction
autocmd User pounce.nvim ++once call <sid>pounce_init()
" }}}

" {{{ fzf-preview.vim
" nnoremap <Space>a <Cmd>EnsureFzf<CR><Cmd>FzfPreviewGitActionsRpc<CR>
nnoremap <Space>f <Cmd>FzfPreviewProjectFilesRpc<CR>
nnoremap <Space>h <Cmd>FzfPreviewProjectMruFilesRpc<CR>
nnoremap <Space>/ :<C-u>FzfPreviewProjectGrepRpc ""<Left>
nnoremap <Space>? :<C-u>FzfPreviewProjectGrepRpc ""<Left><C-r><C-f>
xnoremap <Space>? "zy:<C-u>FzfPreviewProjectGrepRpc "<C-r>z"<Left>
" }}}

" {{{ fzf-lua
autocmd User fzf-lua ++once luafile ~/dotfiles/.config/nvim/plugin_config/fzf_lua.lua

nnoremap <Space>a <Cmd>FzfLua git_status<CR>
nnoremap <Space>b <Cmd>FzfLua buffers<CR>
nnoremap <Space>B <Cmd>FzfLua blines<CR>
nnoremap <Space>c <Cmd>FzfLua quickfix<CR>
nnoremap <Space>H <Cmd>FzfLua help_tags<CR>
nnoremap <Space>j <Cmd>FzfLua jumps<CR>
nnoremap <Space>l <Cmd>FzfLua lines<CR>
nnoremap <Space>m <Cmd>FzfLua marks<CR>
nnoremap <Space>z <Cmd>FzfLua live_grep<CR>
nnoremap <Space>: <Cmd>FzfLua commands<CR>
" }}}

" {{{ winresizer
nnoremap <C-e> <Cmd>WinResizerStartResize<CR>
" }}}

" {{{ user owned mappings
Keymap n <expr> [b '<Cmd>BCycle -' .. v:count1 .. '<CR>'
Keymap n <expr> ]b '<Cmd>BCycle '  .. v:count1 .. '<CR>'
Keymap n [B <Cmd>bfirst<CR>
Keymap n ]B <Cmd>blast<CR>
Keymap n <expr> [q '<Cmd>CCycle -' .. v:count1 .. '<CR>'
Keymap n <expr> ]q '<Cmd>CCycle '  .. v:count1 .. '<CR>'
Keymap n [Q <Cmd>cfirst<CR>
Keymap n ]Q <Cmd>clast<CR>
map M %

" Keymap nx <expr> ; getcharsearch().forward ? ';' : ','
" Keymap nx <expr> , getcharsearch().forward ? ',' : ';'

" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q qq
nnoremap Q @q
" xnoremap <silent> Q :<C-u>normal! @q<CR>
nnoremap <sid>(q)a <Cmd>CAdd<CR>
nnoremap <sid>(q)b <Cmd>Gitsigns toggle_current_line_blame<CR>
nnoremap <sid>(q)c <Cmd>CToggle<CR>
nnoremap <sid>(q)d <Cmd>TroubleToggle<CR>
nnoremap <sid>(q)m <Cmd>PreviewMarkdownToggle<CR>
nnoremap <sid>(q)o <Cmd>only<CR>
nnoremap <sid>(q)t <C-^>
nnoremap <sid>(q)z <Cmd>lua MiniMisc.zoom()<CR>
nnoremap <sid>(q)i <Cmd>HalfMove center<CR>
nnoremap <sid>(q)h <Cmd>HalfMove left<CR>
nnoremap <sid>(q)j <Cmd>HalfMove down<CR>
nnoremap <sid>(q)k <Cmd>HalfMove up<CR>
nnoremap <sid>(q)l <Cmd>HalfMove right<CR>
nnoremap <sid>(q)x <Cmd>CClear<CR>

nnoremap <Space>d <Cmd>keepalt lua MiniBufremove.delete()<CR>
nnoremap <Space>L <Cmd>LazyGit<CR>
" }}}

" {{{ lspsaga
nnoremap gh <Cmd>Lspsaga lsp_finder<CR>
nnoremap grr <Cmd>Lspsaga rename<CR>
nnoremap gD <Cmd>Lspsaga preview_definition<CR>
nnoremap <leader>ca <Cmd>Lspsaga code_action<CR>
vnoremap <leader>ca <Cmd>Lspsaga range_code_action<CR>

nnoremap <leader>cd <Cmd>Lspsaga show_line_diagnostics<CR>
nnoremap <leader>cc <Cmd>Lspsaga show_cursor_diagnostics<CR>
nnoremap [d <Cmd>Lspsaga diagnostic_jump_prev<CR>
nnoremap ]d <Cmd>Lspsaga diagnostic_jump_next<CR>

nnoremap <expr> K &filetype=~'vim\\|help' ? 'K' : '<Cmd>Lspsaga hover_doc<CR>'

nnoremap <C-f> <Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<C-f>')<CR>
nnoremap <C-b> <Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<C-b>')<CR>
" }}}

lua require('impatient')

luafile ~/dotfiles/.config/nvim/plugin_config/gitsigns.lua
luafile ~/dotfiles/.config/nvim/plugin_config/mini.lua

"-----------------
" Commands and Functions
"-----------------
command! Nyancat FloatermNew --autoclose=2 nyancat
command! -bang GhGraph if !exists('g:loaded_floaterm') | call plug#load('vim-floaterm') | endif |
  \ execute 'FloatermNew' '--title=contributions' '--height=13'
  \ '--width=55' 'gh' 'graph' (v:cmdbang ? '--scheme=random' : '')
command! Croc execute '!croc send' expand('%:p')

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  " https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
  autocmd FileType gitcommit,gina-commit nnoremap <buffer> <CR> <Cmd>silent! execute 'normal! ^w"zdiw"_dip"zPA: ' <bar> startinsert!<CR>

  " [NeovimのTerminalモードをちょっと使いやすくする](https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal)
  autocmd TermOpen * startinsert

  " autocmd BufNewFile,BufRead .env* setf env
  autocmd BufNewFile,BufRead commonshrc setf bash

  autocmd BufReadPost * delmarks!

  autocmd ModeChanged [vV\x16]*:* let &l:rnu = mode() =~# '^[vV\x16]'
  autocmd ModeChanged *:[vV\x16]* let &l:rnu = mode() =~# '^[vV\x16]'
  autocmd WinEnter,WinLeave * let &l:rnu = mode() =~# '^[vV\x16]'
augroup END

set laststatus=3 " set on last line to avoid overwritten by plugins
