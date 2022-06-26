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
set wildmode=list:longest,full
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
Plug 'yuki-yano/fuzzy-motion.vim', #{ on: [] }

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'ray-x/cmp-treesitter'
Plug 'tzachar/cmp-tabnine', #{ do: './install.sh' }
Plug 'lukas-reineke/cmp-rg'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'f3fora/cmp-spell'
Plug 'octaltree/cmp-look'
Plug 'rinx/cmp-skkeleton'
Plug 'onsails/lspkind-nvim'

Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

Plug 'lewis6991/impatient.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-colors.nvim'
Plug 'folke/trouble.nvim', #{ on: [] }
Plug 'folke/lua-dev.nvim', #{ for: 'lua' }

Plug 'nvim-treesitter/nvim-treesitter', #{ do: ':TSUpdate', on: [] }
Plug 'nvim-treesitter/nvim-treesitter-textobjects', #{ on: [] }
Plug 'nvim-treesitter/nvim-treesitter-refactor', #{ on: [] }
Plug 'JoosepAlviste/nvim-ts-context-commentstring', #{ on: [] }
Plug 'p00f/nvim-ts-rainbow', #{ on: [] }
Plug 'romgrk/nvim-treesitter-context', #{ on: [] }
" Plug 'lukas-reineke/indent-blankline.nvim', #{ on: [] }
Plug 'mfussenegger/nvim-ts-hint-textobject', #{ on: [] }
Plug 'andymass/vim-matchup', #{ on: [] }

Plug 'junegunn/fzf', #{ do: { -> fzf#install() }, on: [] }
Plug 'yuki-yano/fzf-preview.vim', #{ branch: 'release/rpc', on: [] }
Plug 'junegunn/fzf.vim', #{ on: [] }
Plug 'ryanoasis/vim-devicons', #{ on: [] }

Plug 'nvim-lua/plenary.nvim'

Plug 'folke/which-key.nvim', #{ on: [] }
Plug 'echasnovski/mini.nvim'
Plug 'norcalli/nvim-colorizer.lua', #{ on: [] }
Plug 'lewis6991/gitsigns.nvim'
Plug 'kat0h/bufpreview.vim', #{ on: 'PreviewMarkdown' }
Plug 'lambdalisue/gin.vim', #{ on: [] }
Plug 'kdheepak/lazygit.nvim', #{ on: 'LazyGit' }
Plug 'tyru/open-browser.vim', #{ on: ['OpenBrowser', '<Plug>(openbrowser-'] }
Plug 'tyru/capture.vim', #{ on: 'Capture' }
Plug 'hrsh7th/vim-searchx', #{ on: [] }
Plug 'haya14busa/vim-asterisk', #{ on: '<Plug>(asterisk-' }
Plug 'voldikss/vim-floaterm', #{ on: 'FloatermNew' }
Plug 'monaqa/dps-dial.vim', #{ on: '<Plug>(dps-dial-' }
Plug 'segeljakt/vim-silicon', #{ on: 'Silicon' }
Plug 'simeji/winresizer', #{ on: 'WinResizerStartResize' }
Plug 'vim-jp/vimdoc-ja'

Plug 'lambdalisue/reword.vim'
call plug#end()

command! PlugSync PlugUpdate | PlugClean | PlugInstall | PlugUpdate

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
        \ 'nvim-ts-hint-textobject',
        \ 'vim-matchup',
        \ )
  let setup_file = g:plug_home .. '/nvim-treesitter/plugin/nvim-treesitter.lua'
  execute 'luafile' setup_file
  luafile ~/dotfiles/.config/nvim/plugin_config/treesitter.lua
  TSEnable highlight
endfunction

function s:lazy_plug() abort
  call plug#load(
        \ 'denops.vim',
        \ 'skkeleton',
        \ 'fuzzy-motion.vim',
        \ 'gin.vim',
        \ 'which-key.nvim',
        \ 'nvim-colorizer.lua',
        \ 'trouble.nvim',
        \ )

  source ~/dotfiles/.config/nvim/plugin_config/skkeleton.vim
  lua require('which-key').setup()
  lua require('colorizer').setup()
  lua require('trouble').setup({auto_close = true})
endfunction
augroup lazy_plug
  autocmd!
  autocmd BufReadPost * call <sid>lazy_plug() | call <sid>treesitter_init() | autocmd! lazy_plug
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

" {{{ vsnip
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

" {{{ nvim-ts-hint-textobject
Keymap ov m <Cmd>lua require('tsht').nodes()<CR>
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
noremap [q <Cmd>cprevious<CR>
noremap ]q <Cmd>cnext<CR>
noremap [Q <Cmd>cfirst<CR>
noremap ]Q <Cmd>clast<CR>
map M %

" Keymap nx <expr> ; getcharsearch().forward ? ';' : ','
" Keymap nx <expr> , getcharsearch().forward ? ',' : ';'

" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
nnoremap <sid>(q)q qq
nnoremap Q @q
nnoremap <sid>(q)b <Cmd>Gitsigns toggle_current_line_blame<CR>
nnoremap <sid>(q)c <Cmd>cclose<CR>
nnoremap <sid>(q)m <Cmd>PreviewMarkdownToggle<CR>
nnoremap <sid>(q)o <Cmd>only<CR>
nnoremap <sid>(q)t <C-^>
nnoremap <sid>(q)z <Cmd>lua MiniMisc.zoom()<CR>
nnoremap <sid>(q)i <Cmd>call <SID>half_move('center')<CR>
nnoremap <sid>(q)h <Cmd>call <SID>half_move('left')<CR>
nnoremap <sid>(q)j <Cmd>call <SID>half_move('down')<CR>
nnoremap <sid>(q)k <Cmd>call <SID>half_move('up')<CR>
nnoremap <sid>(q)l <Cmd>call <SID>half_move('right')<CR>

nnoremap <Space>d <Cmd>lua MiniBufremove.delete()<CR>
nnoremap <Space>L <Cmd>LazyGit<CR>
" }}}

xnoremap <silent> Q :normal @q<CR>

function! s:help_or_hover() abort
  if ['vim','help']->index(&filetype) >= 0
    execute 'help' expand('<cword>')
  else
    lua vim.lsp.buf.hover()
  endif
endfunction

nnoremap K <Cmd>call <SID>help_or_hover()<CR>

nnoremap gD        <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap gd        <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap gi        <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap gr        <cmd>lua vim.lsp.buf.references()<CR>
nnoremap gt        <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap gT        <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <space>ta <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <space>tr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <space>tl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <space>tn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <space>tc <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <space>to <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap [d        <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap ]d        <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap sx        <cmd>lua vim.diagnostic.setloclist()<CR>
nnoremap <space>p  <cmd>lua vim.lsp.buf.format({ async = true })<CR>

nnoremap <leader>df <cmd>lua PeekDefinition()<CR>

lua << EOF
require('impatient')

-- https://github.com/hrsh7th/nvim-cmp
-- Setup nvim-cmp.
local cmp = require('cmp')
local lspkind = require('lspkind')
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
cmp.setup({
  formatting = {
    format = lspkind.cmp_format(),
  },
  snippet = {
    expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'cmp_tabnine' },
    { name = 'treesitter' },
    { name = 'buffer' },
    { name = 'nvim_lua' },
    { name = 'rg' },
    { name = 'spell' },
    { name = 'skkeleton' },
    { name = 'look', keyword_length = 2, option = { convert_case = true, loud = true } },
  }),
})

cmp.setup.cmdline('/', {
  sources = cmp.config.sources({
    { name = 'nvim_lsp_document_symbol' }
  }, {
    { name = 'buffer' }
  }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' },
  }),
})

lsp_capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- [User contributed tips: Peek Definition](https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#peek-definition)
function PeekDefinition()
  local function callback(_, result)
    if result == nil or vim.tbl_isempty(result) then
      return nil
    end
    vim.lsp.util.preview_location(result[1])
  end

  return vim.lsp.buf_request(0, 'textDocument/definition', vim.lsp.util.make_position_params(), callback)
end

require("lsp_signature").setup()

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

luafile ~/dotfiles/.config/nvim/plugin_config/lsp.lua
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
