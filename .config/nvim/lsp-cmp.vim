if filereadable(expand('~/dotfiles/.config/nvim/min-edit.vim'))
  source ~/dotfiles/.config/nvim/min-edit.vim
endif

let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
let g:did_indent_on             = 1
let g:did_load_filetypes        = 1
" load ftplugin to set commentstring
" let g:did_load_ftplugin         = 1
let g:loaded_2html_plugin       = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
let g:loaded_matchparen         = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_remote_plugins     = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

set autoindent
set autoread
" set cmdheight=2
" set completeopt=longest,menu
set completeopt=menu,menuone,noselect
" set cursorline
set display=lastline
set formatoptions=tcqmMj1
set history=2000
set incsearch
set infercase
" set laststatus=2
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

"-----------------
" Plugs
"-----------------
" " [Tips should also describe automatic installation for Neovim|junegunn/vim-plug](https://github.com/junegunn/vim-plug/issues/739)
" let s:autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
" if !filereadable(s:autoload_plug_path)
"   if !executable('curl')
"     echoerr 'You have to install `curl` to install vim-plug.'
"     execute 'quit!'
"   endif
"   silent execute '!curl -fL --create-dirs -o ' . s:autoload_plug_path .
"       \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
" endif
"
" " [おい、NeoBundle もいいけど vim-plug 使えよ](https://qiita.com/b4b4r07/items/fa9c8cceb321edea5da0)
" function! s:AutoPlugInstall() abort
"   let s:not_installed_plugs = get(g:, 'plugs', {})->items()->copy()
"       \  ->filter({_,item->!isdirectory(item[1].dir)})
"       \  ->map({_,item->item[0]})
"   if empty(s:not_installed_plugs)
"     return
"   endif
"   echo 'Not installed plugs: ' . string(s:not_installed_plugs)
"   if confirm('Install now?', "yes\nNo", 2) == 1
"     PlugInstall --sync | close
"   endif
" endfunction
" augroup vimrc_plug
"   autocmd!
"   autocmd VimEnter * call s:AutoPlugInstall()
" augroup END

" bootstrap for jetpack
let s:jetpack_dir = (has('nvim') ? stdpath('data') . '/site' : '~/.vim') . '/autoload/jetpack.vim'
command! JetpackUpgrade silent execute '!curl -fLo' s:jetpack_dir '--create-dirs'
    \ ' https://raw.githubusercontent.com/tani/vim-jetpack/master/autoload/jetpack.vim'
if empty(glob(s:jetpack_dir))
  JetpackUpgrade
  autocmd VimEnter * JetpackSync "| source $MYVIMRC
endif

call jetpack#begin()
Jetpack 'vim-denops/denops.vim'
Jetpack 'vim-skk/skkeleton'
Jetpack 'Shougo/ddc.vim'

Jetpack 'hrsh7th/cmp-nvim-lsp'
Jetpack 'hrsh7th/cmp-buffer'
Jetpack 'hrsh7th/cmp-path'
Jetpack 'hrsh7th/cmp-cmdline'
Jetpack 'hrsh7th/nvim-cmp'
Jetpack 'hrsh7th/cmp-vsnip'
Jetpack 'hrsh7th/cmp-nvim-lua'
Jetpack 'ray-x/cmp-treesitter'
Jetpack 'tzachar/cmp-tabnine', #{ do: './install.sh' }
Jetpack 'lukas-reineke/cmp-rg'
Jetpack 'hrsh7th/cmp-nvim-lsp-document-symbol'
Jetpack 'f3fora/cmp-spell'
Jetpack 'octaltree/cmp-look'
Jetpack 'onsails/lspkind-nvim'

Jetpack 'ray-x/lsp_signature.nvim'
Jetpack 'hrsh7th/vim-vsnip'
Jetpack 'hrsh7th/vim-vsnip-integ'
Jetpack 'rafamadriz/friendly-snippets'

Jetpack 'lewis6991/impatient.nvim'
Jetpack 'neovim/nvim-lspconfig'
Jetpack 'williamboman/nvim-lsp-installer'
Jetpack 'kyazdani42/nvim-web-devicons'
Jetpack 'folke/lsp-colors.nvim'
Jetpack 'folke/trouble.nvim'
Jetpack 'folke/lua-dev.nvim', #{ for: 'lua' }

Jetpack 'nvim-treesitter/nvim-treesitter', #{ do: ':TSUpdate' }
Jetpack 'nvim-treesitter/nvim-treesitter-textobjects'
Jetpack 'nvim-treesitter/nvim-treesitter-refactor'
Jetpack 'JoosepAlviste/nvim-ts-context-commentstring'
Jetpack 'p00f/nvim-ts-rainbow'
Jetpack 'romgrk/nvim-treesitter-context'
Jetpack 'lukas-reineke/indent-blankline.nvim'
Jetpack 'mfussenegger/nvim-ts-hint-textobject'
Jetpack 'lewis6991/spellsitter.nvim'
Jetpack 'andymass/vim-matchup'

Jetpack 'junegunn/fzf', #{ do: { -> fzf#install() } }
Jetpack 'yuki-yano/fzf-preview.vim', #{ branch: 'release/rpc' }

Jetpack 'nvim-lua/plenary.nvim'
Jetpack 'nvim-lualine/lualine.nvim'

Jetpack 'folke/which-key.nvim'
Jetpack 'echasnovski/mini.nvim'
Jetpack 'norcalli/nvim-colorizer.lua'
Jetpack 'lewis6991/gitsigns.nvim'
Jetpack 'kat0h/bufpreview.vim', #{ on: 'PreviewMarkdown' }
Jetpack 'lambdalisue/gina.vim', #{ on: 'Gina' }
Jetpack 'kdheepak/lazygit.nvim', #{ on: 'LazyGit' }
Jetpack 'tyru/open-browser.vim', #{ on: ['OpenBrowser', '<Plug>(openbrowser-'] }
Jetpack 'tyru/capture.vim', #{ on: 'Capture' }
Jetpack 'yuki-yano/fuzzy-motion.vim'
Jetpack 'hrsh7th/vim-searchx'
Jetpack 'nathom/filetype.nvim'
Jetpack 'arthurxavierx/vim-caser'
Jetpack 'haya14busa/vim-asterisk'
Jetpack 'voldikss/vim-floaterm', #{ on: 'FloatermNew' }
Jetpack 'monaqa/dps-dial.vim', #{ on: '<Plug>(dps-dial-' }
Jetpack 'segeljakt/vim-silicon', #{ on: 'Silicon' }
Jetpack 'simeji/winresizer', #{ on: 'WinResizerStartResize' }
Jetpack 'vim-jp/vimdoc-ja'
call jetpack#end()

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']
let g:asterisk#keeppos = 1
let g:lazygit_floating_window_scaling_factor = 1
let g:lazygit_floating_window_winblend = 20
let g:silicon = {}
let g:silicon['output'] = '~/Downloads/silicon-{time:%Y-%m-%d-%H%M%S}.png'
" let g:denops#debug = 1

" lua vim.keymap.set() API is not released as stable yet
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

" {{{ fuzzy-motion.vim
nnoremap s; <Cmd>FuzzyMotion<CR>
let g:fuzzy_motion_auto_jump = v:true
" }}}

" {{{ searchx
Keymap nx ? <Cmd>call searchx#start(#{ dir: 0 })<CR>
Keymap nx / <Cmd>call searchx#start(#{ dir: 1 })<CR>
Keymap nx N <Cmd>call searchx#prev()<CR>
Keymap nx n <Cmd>call searchx#next()<CR>
nnoremap <C-l> <Cmd>call searchx#clear()<CR><Cmd>nohlsearch<CR><C-l>

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

" {{{ vsnip
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

call ddc#enable()
call ddc#custom#patch_global(#{
  \   sources: ['skkeleton'],
  \   sourceOptions: #{ skkeleton: #{ matchers: ['skkeleton'] } },
  \   autoCompleteEvents: [],
  \   completionMode: 'manual',
  \ })

function! s:skkeleton_enable() abort
  call ddc#custom#patch_buffer(#{
    \   autoCompleteEvents: ['TextChangedI', 'TextChangedP', 'CmdlineChanged'],
    \   completionMode: 'popupmenu'
    \ })
  lua require('cmp').setup.buffer({ enabled = false })

  autocmd User skkeleton-disable-pre ++once
    \ call ddc#custom#patch_buffer(#{ autoCompleteEvents: [], completionMode: 'manual' }) |
    \ lua require('cmp').setup.buffer({ enabled = true })
endfunction

augroup skkeleton
  autocmd!
  autocmd User skkeleton-enable-pre call <SID>skkeleton_enable()
  autocmd User skkeleton-initialize-pre call <SID>skkeleton_init()
augroup END
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
Keymap ov m <Cmd>lua require(tsht).nodes()<CR>
" }}}

" {{{ openbrowser
Keymap nx gx <Plug>(openbrowser-smart-search)
" }}}

" {{{ vim-asterisk
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
" }}}

" {{{ fzf-preview.vim
let g:fzf_preview_fzf_preview_window_option = 'down:70%'
let g:fzf_preview_use_dev_icons = 1
let g:fzf_preview_default_fzf_options = {
      \ '--reverse': v:true,
      \ '--preview-window': 'wrap',
      \ '--cycle': v:true,
      \ '--no-sort': v:true,
      \ }
nnoremap <Space>a <Cmd>FzfPreviewGitActionsRpc<CR>
nnoremap <Space>b <Cmd>FzfPreviewBuffersRpc<CR>
nnoremap <Space>B <Cmd>FzfPreviewBufferLinesRpc<CR>
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

xnoremap <silent> p <Cmd>call <SID>markdown_link_paste()<CR>
" https://github.com/Shougo/shougo-s-github/blob/master/vim/rc/mappings.rc.vim#L179
xnoremap <silent> P <Cmd>call <SID>visual_paste('p')<CR>
" }}}

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
nnoremap <space>p  <cmd>lua vim.lsp.buf.formatting()<CR>

nnoremap <leader>df <cmd>lua PeekDefinition()<CR>

lua << EOF
require('impatient')

require('nvim-treesitter.configs').setup({
  -- {{{ nvim-treesitter
  ensure_installed = "maintained",
  sync_install = false,
  ignore_install = {
    "ocaml",
    "ocaml_interface",
    "ocamllex",
    "teal",
    "tlaplus"
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'vim' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      node_decremental = "grm",
      scope_incremental = "grc",
    },
  },
  indent = { enable = true },
  -- }}}

  -- {{{ nvim-treesitter-textobjects
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@conditional.outer",
        ["ic"] = "@conditional.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]i"] = "@conditional.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]I"] = "@conditional.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[i"] = "@conditional.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[I"] = "@conditional.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
  -- }}}

  -- {{{ nvim-treesitter-refactor
  refactor = {
    highlight_definitions = { enable = true },
    -- highlight_current_scope = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = 'grd',
        list_definitions = 'grD',
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

require('treesitter-context').setup({
  enable = true,
  throttle = true,
  max_lines = 0,
  patterns = {
    default = {
      'class',
      'function',
      'method',
      'for',
      'while',
      'if',
      'switch',
      'case',
    },
  },
})

require('spellsitter').setup()

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
    { name = 'look', keyword_length = 2, option = { convert_case = true, loud = true } },
  }),
})

require'cmp'.setup.cmdline('/', {
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

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

local nvim_lsp = require('lspconfig')

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.preselectSupport = true
-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
-- capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = { 'documentation', 'detail', 'additionalTextEdits' }
-- }

-- [Neovim builtin LSP設定入門](https://zenn.dev/nazo6/articles/c2f16b07798bab)
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs.lua
local node_root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()) ~= nil

lsp_installer.on_server_ready(function(server)
  local opts = {}
  -- opts.on_attach = on_attach
  opts.capabilities = capabilities

  if server.name == "tsserver" or server.name == "eslint" then
    -- opts.root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
    opts.autostart = is_node_repo
    if server.name == "tsserver" then
      opts.settings = { documentFormatting = false }
      opts.init_options = { hostInfo = "neovim" }
    end
  elseif server.name == "denols" then
    -- opts.root_dir = nvim_lsp.util.root_pattern("deno.jsonc", "deps.ts")
    opts.autostart = not(is_node_repo)
    -- opts.single_file_support = true
    -- opts.filetypes = {
    --   "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "markdown", "json"
    -- }
    opts.init_options = {
      lint = true,
      unstable = true,
      config = "./deno.jsonc",
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
  elseif server.name == "efm" then
    -- https://skanehira.github.io/blog/posts/20201116-vim-writing-articles/
    local prettier = {
      formatCommand = "prettier --stdin-filepath ${INPUT}",
      formatStdin = true
    }
    opts.filetypes = { "markdown", "typescript", "javascript", "typescriptreact", "javascriptreact" }
    if not(is_node_repo) then
      opts.filetypes = { "markdown" }
    end
    opts.init_options = { documentFormatting = true, codeAction = true }
    opts.settings = {
      rootMarkers = { ".git/" },
      languages = {
        markdown = {
          {
            lintCommand = "npx --no-install textlint -f unix --stdin --stdin-filename ${INPUT}",
            lintStdin = true,
            lintIgnoreExitCode = true,
            lintFormats = { '%f:%l:%c: %m [%trror/%r]' },
            -- rootMarkers = { '.textlintrc' },
            formatCommand = "dprint fmt --config ~/dotfiles/dprint.json --stdin ${INPUT}",
            formatStdin = true
          }
        },
        typescript = { prettier },
        javascript = { prettier },
        typescriptreact = { prettier },
        javascriptreact = { prettier },
      }
    }
  -- elseif server.name == "sumneko_lua" then
  --   -- -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
  --   -- opts.settings.Lua.diagnostics = { globals = { 'vim' } }
  --   -- opts.settings.Lua.workspace = { library = vim.api.nvim_get_runtime_file("", true) }
  --   -- opts.settings.Lua.telemetry = { enable = false }
  --   opts = require('lua-dev').setup()
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

require("lsp_signature").setup()

require("lsp-colors").setup()
require("trouble").setup()

require("indent_blankline").setup({
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
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

    vim.cmd [[ highlight link GitSignsCurrentLineBlame NonText ]]
  end
})
require('lualine').setup({
  sections = { lualine_a = { 'mode', 'g:skkeleton#mode' } }
})
require('colorizer').setup()

require('mini.bufremove').setup()
require('mini.comment').setup()
require('mini.cursorword').setup()
require('mini.surround').setup()
require('mini.trailspace').setup()
require('mini.tabline').setup()
require('mini.pairs').setup()
require('mini.misc').setup({ make_global = { 'put', 'put_text', 'zoom' } })
-- require('mini.statusline').setup()
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
require('which-key').setup()

-- require('filetype').setup({
--   overrides = {
--     extensions = {
--       bashrc = 'bash',
--       env = 'env',
--     },
--     complex = {
--       ["%.env.*"] = "env",
--       ["%.zshrc.*"] = "zsh",
--       [".*shrc"] = "bash",
--       ["git--__.+"] = "bash",
--     },
--   }
-- })
-- 
-- local Job = require('plenary.job')
-- local karabiner_cli = '/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli'
-- function _G.set_karabiner(val)
--   Job:new{
--     command = karabiner_cli,
--     args = {
--       '--set-variables',
--       ('{"neovim_in_insert_mode":%d}'):format(val),
--     },
--   }:start()
-- end
-- 
-- function _G.set_karabiner_if_in_insert_mode()
--   local val = vim.fn.mode():match'[icrR]' and 1 or 0
--   _G.set_karabiner(val)
-- end
-- vim.cmd[[
-- augroup skkeleton_karabiner_elements
--   autocmd!
--   autocmd InsertEnter,CmdlineEnter * call v:lua.set_karabiner(1)
--   autocmd InsertLeave,CmdlineLeave,FocusLost * call v:lua.set_karabiner(0)
--   autocmd FocusGained * call v:lua.set_karabiner_if_in_insert_mode()
-- augroup END
-- ]]
EOF

"-----------------
" Commands and Functions
"-----------------
let g:my_vimrc = expand('<sfile>:p')
command! RcEdit execute 'edit' g:my_vimrc
command! RcReload write | execute 'source' g:my_vimrc | nohlsearch | redraw | echo g:my_vimrc . ' is reloaded.'
command! CopyFullPath     let @*=expand('%:p') | echo 'copy full path'
command! CopyDirName      let @*=expand('%:h') | echo 'copy dir name'
command! CopyFileName     let @*=expand('%:t') | echo 'copy file name'
command! CopyRelativePath let @*=expand('%:h').'/'.expand('%:t') | echo 'copy relative path'
command! VimShowHlGroup echo synID(line('.'), col('.'), 1)->synIDtrans()->synIDattr('name')
command! -nargs=* T split | wincmd j | resize 12 | terminal <args>
command! Nyancat FloatermNew --autoclose=2 nyancat
command! Trim lua MiniTrailspace.trim()
command! -bang GhGraph if !exists('g:loaded_floaterm') | call plug#load('vim-floaterm') | endif |
  \ execute 'FloatermNew' '--title=contributions' '--height=13'
  \ '--width=55' 'gh' 'graph' (v:cmdbang ? '--scheme=random' : '')
command! -nargs=* -bang Dex silent only! | botright 12 split |
  \ execute 'terminal' (has('nvim') ? '' : '++curwin') 'dex'
  \   (v:cmdbang ? '--clear' : '') <q-args> expand('%:p') |
  \ stopinsert | execute 'normal! G' | set bufhidden=wipe |
  \ execute 'autocmd BufEnter <buffer> if winnr("$") == 1 | quit! | endif' |
  \ file Dex<bang> | wincmd k
command! Croc execute '!croc send' expand('%:p')

" https://github.com/neovim/neovim/pull/12383#issuecomment-695768082
" https://github.com/Shougo/shougo-s-github/blob/master/vim/autoload/vimrc.vim#L84
function! s:visual_paste(direction) range abort
  let registers = {}

  for name in ['"', '0']
    let registers[name] = {'type': getregtype(name), 'value': getreg(name)}
  endfor

  execute 'normal!' a:direction

  for [name, register] in items(registers)
    call setreg(name, register.value, register.type)
  endfor
endfunction

" https://zenn.dev/skanehira/articles/2021-11-29-vim-paste-clipboard-link
function! s:markdown_link_paste() abort
  let link = trim(getreg('*'))
  if link !~# '^http'
    call s:visual_paste('p')
    return
  endif

  normal! "9y
  call setreg(9, '[' . getreg(9) . '](' . link . ')')
  normal! gv"9p

  for name in ['"', '0']
    call setreg(name, link)
  endfor
endfunction

function! s:half_move(direction) abort
  let [bufnum, lnum, col, off] = getpos('.')
  if a:direction == 'left'
    let col = col / 2
  elseif a:direction == 'right'
    let col = (len(getline('.')) + col) / 2
  elseif a:direction == 'center'
    let col = len(getline('.')) / 2
  elseif a:direction == 'up'
    let lnum = (line('w0') + lnum) / 2
  elseif a:direction == 'down'
    let lnum = (line('w$') + lnum) / 2
  endif
  call setpos('.', [bufnum, lnum, col, off])
endfunction

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

  autocmd VimEnter * TSEnableAll *

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
