if filereadable(expand('~/dotfiles/.config/nvim/min-edit.vim'))
  source ~/dotfiles/.config/nvim/min-edit.vim
endif

let g:did_load_filetypes = 0
let g:do_filetype_lua = 1
set autoindent
set autoread
" set cmdheight=2
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
" set t_Co=256
set termguicolors
set textwidth=0
set title
set ttyfast
set updatetime=300
set wildmode=longest,full
let g:markdown_fenced_languages = ['ts=typescript', 'js=javascript']

source ~/dotfiles/.config/nvim/commands.vim
let g:my_vimrc = expand('<sfile>:p')
Keymap nx gz <Cmd>SmartOpen<CR>

"-----------------
" Plugs
"-----------------
" [Tips should also describe automatic installation for Neovim|junegunn/vim-plug](https://github.com/junegunn/vim-plug/issues/739)
let s:autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(s:autoload_plug_path)
  if !executable('curl')
    echoerr 'You have to install `curl` to install vim-plug.'
    execute 'quit!'
  endif
  silent execute '!curl -fL --create-dirs -o ' . s:autoload_plug_path .
      \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" [おい、NeoBundle もいいけど vim-plug 使えよ](https://qiita.com/b4b4r07/items/fa9c8cceb321edea5da0)
function! s:AutoPlugInstall() abort
  let s:not_installed_plugs = get(g:, 'plugs', {})->items()->copy()
      \  ->filter({_,item->!isdirectory(item[1].dir)})
      \  ->map({_,item->item[0]})
  if empty(s:not_installed_plugs)
    return
  endif
  echo 'Not installed plugs: ' . string(s:not_installed_plugs)
  if confirm('Install now?', "yes\nNo", 2) == 1
    PlugInstall --sync | close
  endif
endfunction
augroup vimrc_plug
  autocmd!
  autocmd VimEnter * call s:AutoPlugInstall()
augroup END

call plug#begin(stdpath('config') . '/plugged')
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

Plug 'junegunn/fzf', #{ do: { -> fzf#install() }, on: [] }
Plug 'yuki-yano/fzf-preview.vim', #{ branch: 'release/rpc', on: [] }
Plug 'junegunn/fzf.vim', #{ on: [] }
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

command! PlugSync PlugUpgrade | PlugClean! | PlugInstall | PlugUpdate

let g:lazygit_floating_window_scaling_factor = 1
" let g:lazygit_floating_window_winblend = 20
source ~/dotfiles/.config/nvim/plugin_config/silicon.vim

let s:plug_loaded = {}
function s:ensure_plug(...) abort
  for plug in a:000
    if !get(s:plug_loaded, plug)
      call plug#load(plug)
      let s:plug_loaded[plug] = 1
    endif
  endfor
endfunction
command! -nargs=+ -bang EnsurePlug call <sid>ensure_plug(<f-args>)

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
function s:lazy_plug() abort
  call <sid>treesitter_init()
  call <sid>lsp_init()

  call plug#load(
        \ 'denops.vim',
        \ 'skkeleton',
        \ 'fuzzy-motion.vim',
        \ 'ddc.vim',
        \ 'gin.vim',
        \ 'reword.vim',
        \ 'which-key.nvim',
        \ 'nvim-colorizer.lua',
        \ 'nvim-web-devicons',
        \ 'trouble.nvim',
        \ 'plenary.nvim',
        \ )

  source ~/dotfiles/.config/nvim/plugin_config/skkeleton.vim
  source ~/dotfiles/.config/nvim/plugin_config/skk_ddc_cmp.vim
  execute 'source' g:plug_home .. '/plenary.nvim/plugin/plenary.vim'
  lua require('which-key').setup()
  lua require('colorizer').setup()
  lua require('trouble').setup({auto_close = true})
endfunction
augroup lazy_plug
  autocmd!
  autocmd BufReadPost * call <sid>lazy_plug() | autocmd! lazy_plug
augroup END

" {{{ fuzzy-motion.vim
nnoremap s; <Cmd>FuzzyMotion<CR>
" }}}

" {{{ searchx
source ~/dotfiles/.config/nvim/plugin_config/searchx.vim
Keymap nx ? <Cmd>EnsurePlug vim-searchx<CR><Cmd>call searchx#start(#{ dir: 0 })<CR>
Keymap nx / <Cmd>EnsurePlug vim-searchx<CR><Cmd>call searchx#start(#{ dir: 1 })<CR>
Keymap nx N <Cmd>EnsurePlug vim-searchx<CR><Cmd>call searchx#prev()<CR>
Keymap nx n <Cmd>EnsurePlug vim-searchx<CR><Cmd>call searchx#next()<CR>
nnoremap <C-l> <Cmd>EnsurePlug vim-searchx<CR><Cmd>call searchx#clear()<CR><Cmd>nohlsearch<CR><C-l>
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
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
" }}}

" {{{ fzf-preview.vim
source ~/dotfiles/.config/nvim/plugin_config/fzf_preview.vim

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --hidden --trim -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
let g:fzf_preview_window = ['down:70%', 'ctrl-/']

command! EnsureFzf EnsurePlug fzf fzf.vim fzf-preview.vim vim-devicons
nnoremap <Space>a <Cmd>EnsureFzf<CR><Cmd>FzfPreviewGitActionsRpc<CR>
nnoremap <Space>b <Cmd>EnsureFzf<CR><Cmd>FzfPreviewBuffersRpc<CR>
nnoremap <Space>B <Cmd>EnsureFzf<CR><Cmd>FzfPreviewBufferLinesRpc<CR>
nnoremap <Space>f <Cmd>EnsureFzf<CR><Cmd>FzfPreviewProjectFilesRpc<CR>
nnoremap <Space>h <Cmd>EnsureFzf<CR><Cmd>FzfPreviewProjectMruFilesRpc<CR>
nnoremap <Space>H <Cmd>EnsureFzf<CR><Cmd>Helptags<CR>
nnoremap <Space>j <Cmd>EnsureFzf<CR><Cmd>FzfPreviewJumpsRpc<CR>
nnoremap <Space>l <Cmd>EnsureFzf<CR><Cmd>FzfPreviewLinesRpc<CR>
nnoremap <Space>m <Cmd>EnsureFzf<CR><Cmd>FzfPreviewMarksRpc<CR>
nnoremap <Space>/ <Cmd>EnsureFzf<CR>:<C-u>FzfPreviewProjectGrepRpc ""<Left>
nnoremap <Space>? <Cmd>EnsureFzf<CR>:<C-u>FzfPreviewProjectGrepRpc ""<Left><C-r><C-f>
nnoremap <Space>: <Cmd>EnsureFzf<CR><Cmd>FzfPreviewCommandPaletteRpc<CR>
xnoremap <Space>? <Cmd>EnsureFzf<CR>"zy:<C-u>FzfPreviewProjectGrepRpc "<C-r>z"<Left>
" }}}

" {{{ winresizer
nnoremap <C-e> <Cmd>WinResizerStartResize<CR>
" }}}

" {{{ user owned mappings
noremap [b <Cmd>bprevious<CR>
noremap ]b <Cmd>bnext<CR>
noremap [B <Cmd>bfirst<CR>
noremap ]B <Cmd>blast<CR>
noremap [q <Cmd>CCycle prev<CR>
noremap ]q <Cmd>CCycle next<CR>
noremap [Q <Cmd>cfirst<CR>
noremap ]Q <Cmd>clast<CR>
map M %

" Keymap nx <expr> ; getcharsearch().forward ? ';' : ','
" Keymap nx <expr> , getcharsearch().forward ? ',' : ';'

" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q qq
nnoremap Q @q
xnoremap <silent> Q :<C-u>normal! @q<CR>
nnoremap <sid>(q)b <Cmd>Gitsigns toggle_current_line_blame<CR>
nnoremap <sid>(q)c <Cmd>TroubleToggle quickfix<CR>
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

nnoremap <Space>d <Cmd>keepalt lua MiniBufremove.delete()<CR>
nnoremap <Space>L <Cmd>LazyGit<CR>
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
EOF

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
augroup END

set laststatus=3 " set on last line to avoid overwritten by plugins
