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
set completeopt=longest,menu
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
Plug 'vim-denops/denops.vim'

Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-around'
Plug 'Shougo/ddc-nvim-lsp'
Plug 'Shougo/pum.vim'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/neco-vim'
Plug 'Shougo/ddc-cmdline'
Plug 'Shougo/ddc-cmdline-history'
Plug 'Shougo/ddc-converter_remove_overlap'
Plug 'Shougo/ddc-rg'
Plug 'matsui54/ddc-converter_truncate'
Plug 'matsui54/ddc-buffer'
Plug 'matsui54/ddc-dictionary'
Plug 'LumaKernel/ddc-file'
Plug 'LumaKernel/ddc-tabnine'
Plug 'LumaKernel/ddc-registers-words'
Plug 'tani/ddc-fuzzy'
Plug 'gamoutatsumi/ddc-sorter_ascii'
Plug 'vim-skk/denops-skkeleton.vim'
Plug 'delphinus/skkeleton_indicator.nvim'
Plug 'delphinus/ddc-treesitter'

Plug 'matsui54/denops-popup-preview.vim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'

Plug 'lewis6991/impatient.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-colors.nvim'
Plug 'folke/trouble.nvim'

Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'p00f/nvim-ts-rainbow'
Plug 'romgrk/nvim-treesitter-context'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mfussenegger/nvim-ts-hint-textobject'
Plug 'lewis6991/spellsitter.nvim'
Plug 'andymass/vim-matchup'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lualine/lualine.nvim'

Plug 'folke/which-key.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'lewis6991/gitsigns.nvim'
Plug 'kat0h/bufpreview.vim', { 'on': 'PreviewMarkdown' }
Plug 'lambdalisue/gina.vim', { 'on': 'Gina' }
Plug 'kdheepak/lazygit.nvim', { 'on': 'LazyGit' }
Plug 'tyru/open-browser.vim', { 'on': ['OpenBrowser', '<Plug>(openbrowser-'] }
Plug 'tyru/capture.vim', { 'on': 'Capture' }
" Plug 'obcat/vim-hitspop'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nathom/filetype.nvim'
Plug 'arthurxavierx/vim-caser'
Plug 'haya14busa/vim-asterisk'
Plug 'voldikss/vim-floaterm', { 'on': 'FloatermNew' }
Plug 'phaazon/hop.nvim'
Plug 'monaqa/dial.nvim'
Plug 'segeljakt/vim-silicon', { 'on': 'Silicon' }
Plug 'simeji/winresizer', { 'on': 'WinResizerStartResize' }
Plug 'vim-jp/vimdoc-ja'
call plug#end()

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']
let g:asterisk#keeppos = 1
let g:lazygit_floating_window_scaling_factor = 1
let g:lazygit_floating_window_winblend = 20
let g:silicon = {}
let g:silicon['output'] = '~/Downloads/silicon-{time:%Y-%m-%d-%H%M%S}.png'

let s:dictPath = '~/.cache/nvim/google-10000-english-no-swears.txt'
if !filereadable(expand(s:dictPath))
  echo "10k words dictionary does not exists! '" . s:dictPath . "' is required!"
  let l:dictDir = fnamemodify(s:dictPath, ':h')
  let l:cmds = [
    \   "curl -OL https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt",
    \   "mkdir -p " . l:dictDir,
    \   "mv " . fnamemodify(s:dictPath, ':t') . " " . l:dictDir,
    \ ]
  echo "To get dictionary, run:\n" . l:cmds->join("\n") . "\n"

  if confirm("Run automatically?", "y\nN") == 1
    echo "Running..."
    call system(l:cmds->join(" && "))
    echo "Done."
  endif
endif

call ddc#custom#patch_global('sources', [
  \ 'nvim-lsp', 'skkeleton', 'vsnip', 'buffer', 'file', 'tabnine', 'treesitter',
  \ 'registers-words', 'dictionary', 'rg', 'around'])
call ddc#custom#patch_global('completionMenu', 'pum.vim')
call ddc#custom#patch_global('autoCompleteEvents', [
  \ 'InsertEnter', 'TextChangedI', 'TextChangedP',
  \ 'CmdlineChanged', 'CmdlineEnter'])
let s:source_common_option = #{
  \   ignoreCase: v:true,
  \   matchers:   ['matcher_fuzzy'],
  \   sorters:    ['sorter_fuzzy'],
  \   converters: ['converter_remove_overlap', 'converter_truncate', 'converter_fuzzy']
  \ }
call ddc#custom#patch_global('sourceOptions', #{
  \   _: s:source_common_option,
  \   around: #{
  \     mark: 'A',
  \     isVolatile: v:true,
  \   },
  \   buffer: #{
  \     mark: 'B',
  \     maxCandidates: 10,
  \   },
  \   dictionary: #{
  \     mark: 'D',
  \     maxCandidates: 6,
  \     minAutoCompleteLength: 3,
  \   },
  \   file: #{
  \     mark: 'F',
  \     isVolatile: v:true,
  \     forceCompletionPattern: '\S/\S*',
  \   },
  \   skkeleton: #{
  \     mark: 'skk',
  \     matchers: ['skkeleton'],
  \     minAutoCompleteLength: 1,
  \   },
  \   vsnip: #{
  \     mark: 'VS',
  \     dup: v:true,
  \   },
  \   tabnine: #{
  \     mark: 'TN',
  \     maxCandidates: 6,
  \     isVolatile: v:true,
  \     minAutoCompleteLength: 1,
  \   },
  \   treesitter: #{
  \     mark: 'TS',
  \   },
  \   registers-words: #{
  \     mark: 'reg',
  \     minAutoCompleteLength: 3,
  \   },
  \   rg: #{
  \     mark: 'rg',
  \     minAutoCompleteLength: 3,
  \   },
  \   nvim-lsp: #{
  \     mark: 'lsp',
  \     forceCompletionPattern: '\.\w*|:\w*|->\w*',
  \   },
  \ })
call ddc#custom#patch_global('filterParams', #{
  \   converter_truncate: #{ maxAbbrWidth: 60, maxInfo: 500, ellipsis: '...' },
  \   converter_fuzzy: #{ hlGroup: 'Title' },
  \ })
" call ddc#custom#patch_global('specialBufferCompletion', v:true)
" 10k words dictionary:
" https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt
call ddc#custom#patch_global('sourceParams', #{
  \   around: #{ maxSize: 500 },
  \   buffer: #{ forceCollect: v:true, fromAltBuf: v:true, showBufName: v:true },
  \   dictionary: #{
  \     showMenu: v:false,
  \     dictPaths: [expand(s:dictPath)],
  \   },
  \   registers-words: #{ registers: '/"0123456' },
  \   nvim-lsp: #{ maxSize: 500 },
  \ })
call ddc#enable()
call popup_preview#enable()

" {{{ mappings(ddc)
imap <silent><expr> <TAB>
  \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' :
  \ vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' :
  \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
  \ '<TAB>' : ddc#map#manual_complete()
imap <silent><expr> <S-TAB>
  \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' :
  \ vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-TAB>'
inoremap <silent><expr> <C-n> (pum#visible() ? '' : '<Cmd>call ddc#map#manual_complete()<CR>') . '<Cmd>call pum#map#select_relative(+1)<CR>'
inoremap <silent><expr> <C-p> (pum#visible() ? '' : '<Cmd>call ddc#map#manual_complete()<CR>') . '<Cmd>call pum#map#select_relative(-1)<CR>'
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>
inoremap <silent><expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" }}}
augroup pum-complete-done
  autocmd!
  autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
augroup END

" {{{ mappings(vsnip)
" imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
" smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
nmap st <Plug>(vsnip-select-text)
xmap st <Plug>(vsnip-select-text)
nmap sT <Plug>(vsnip-cut-text)
xmap sT <Plug>(vsnip-cut-text)
" }}}

" cnoremap <expr> <TAB>   pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : ddc#map#manual_complete()
" cnoremap <expr> <S-TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : ddc#map#manual_complete()
" cnoremap <expr> <C-n>   pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<C-n>'
" cnoremap <expr> <C-p>   pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<C-p>'
" cnoremap <expr> <CR>    pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" " cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
" " cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
" nnoremap : <Cmd>call <SID>CommandlinePre()<CR>:
"
" function! s:CommandlinePre() abort
"   " Overwrite sources
"   let s:prev_buffer_config = ddc#custom#get_buffer()
"   call ddc#custom#patch_buffer('sources', ['cmdline', 'cmdline-history'])
"   call ddc#custom#patch_buffer('autoCompleteEvents', ['CmdlineChanged', 'CmdlineEnter'])
"   call ddc#custom#patch_buffer('sourceOptions', #{
"     \   _: s:source_common_option,
"     \   cmdline: #{ mark: 'cmd' },
"     \   cmdline-history: #{ mark: 'hist' },
"     \ })
"     " \   necovim: #{ mark: 'neco' },
"
"   autocmd User DDCCmdlineLeave ++once call <SID>CommandlinePost()
"
"   " Enable command line completion
"   call ddc#enable_cmdline_completion()
" endfunction
" function! s:CommandlinePost() abort
"   " Restore sources
"   call ddc#custom#set_buffer(s:prev_buffer_config)
" endfunction

" {{{ dial.nvim
nmap <C-a>  <Plug>(dial-increment)
nmap <C-x>  <Plug>(dial-decrement)
vmap <C-a>  <Plug>(dial-increment)
vmap <C-x>  <Plug>(dial-decrement)
vmap g<C-a> <Plug>(dial-increment-additional)
vmap g<C-x> <Plug>(dial-decrement-additional)
" }}}

" {{{ nvim-ts-hint-textobject
onoremap m <Cmd>lua require('tsht').nodes()<CR>
vnoremap m <Cmd>lua require('tsht').nodes()<CR>
" }}}

" {{{ nvim-ts-hint-textobject
nmap gx <Plug>(openbrowser-smart-search)
xmap gx <Plug>(openbrowser-smart-search)
" }}}

" {{{ vim-asterisk
map *  <Plug>(asterisk-z*)
map #  <Plug>(asterisk-z#)
map g* <Plug>(asterisk-gz*)
map g# <Plug>(asterisk-gz#)
" }}}

" {{{ telescope.vim
nnoremap <space>ff <cmd>Telescope git_files<cr>
nnoremap <space>fg <cmd>Telescope live_grep<cr>
nnoremap <space>fb <cmd>Telescope buffers<cr>
nnoremap <space>fh <cmd>Telescope help_tags<cr>
" }}}

" {{{ hop.nvim
nnoremap so :<C-u>HopChar1<CR>
nnoremap st :<C-u>HopChar2<CR>
nnoremap sl <Cmd>HopLine<CR>
nnoremap sw <Cmd>HopWord<CR>
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
nnoremap <sid>(q)b <Cmd>GitSigns toggle_current_line_blame<CR>
nnoremap <sid>(q)c <Cmd>cclose<CR>
" nnoremap <sid>(q)m <Cmd>PreviewMarkdownToggle<CR>
nnoremap <sid>(q)o <Cmd>only<CR>
nnoremap <sid>(q)t <C-^>
nnoremap <sid>(q)z <Cmd>lua MiniMisc.zoom()<CR>

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
nnoremap gs        <cmd>lua vim.lsp.buf.signature_help()<CR>
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

imap <C-j> <Plug>(skkeleton-enable)
cmap <C-j> <Plug>(skkeleton-enable)

let s:jisyoPath = '~/.cache/nvim/SKK-JISYO.L'
if !filereadable(expand(s:jisyoPath))
  echo "SSK Jisyo does not exists! '" . s:jisyoPath . "' is required!"
  let l:jisyoDir = fnamemodify(s:jisyoPath, ':h')
  let l:cmds = [
    \   "curl -OL http://openlab.jp/skk/dic/SKK-JISYO.L.gz",
    \   "gunzip SKK-JISYO.L.gz",
    \   "mkdir -p " . l:jisyoDir,
    \   "mv ./SKK-JISYO.L " . l:jisyoDir,
    \ ]
  echo "To get Jisyo, run:\n" . l:cmds->join("\n") . "\n"

  if confirm("Run automatically?", "y\nN") == 1
    echo "Running..."
    call system(l:cmds->join(" && "))
    echo "Done."
  endif
endif

function! s:skkeleton_init() abort
  call skkeleton#config(#{
    \   eggLikeNewline: v:true,
    \   globalJisyo: expand(s:jisyoPath),
    \   showCandidatesCount: 1,
    \   immediatelyCancel: v:false,
    \   keepState: v:true,
    \ })
  call skkeleton#register_kanatable('rom', {
    \   'x,': [',', ''],
    \   'x.': ['.', ''],
    \   'x-': ['-', ''],
    \   'x_': ['_', ''],
    \   'x!': ['!', ''],
    \   'x?': ['?', ''],
    \   'z9': ['（', ''],
    \   'z0': ['）', ''],
    \   "z\<Space>": ["\u3000", ''],
    \ })
endfunction
augroup skkeleton-initialize-pre
  autocmd!
  autocmd User skkeleton-initialize-pre call s:skkeleton_init()
augroup END

lua << EOF
require('impatient')

require('nvim-treesitter.configs').setup({
  -- {{{ nvim-treesitter
  ensure_installed = "maintained",
  sync_install = false,
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
        ["]c"] = "@conditional.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]C"] = "@conditional.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@conditional.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[C"] = "@conditional.outer",
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
        goto_definition_lsp_fallback = 'gnd',
        list_definitions = 'gnD',
        list_definitions_toc = "gO",
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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--
--   -- Enable completion triggered by <c-x><c-o>
--   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
--
--   -- Mappings.
--   local opts = { noremap=true, silent=true }
--
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   buf_set_keymap('n', 'gD',        '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   buf_set_keymap('n', 'gd',        '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   buf_set_keymap('n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   buf_set_keymap('n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--   -- buf_set_keymap('n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   buf_set_keymap('n', '<C-k>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--   buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--   buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   buf_set_keymap('n', '<space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--   buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--   buf_set_keymap('n', '<space>e',  '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
--   buf_set_keymap('n', '[g',        '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
--   buf_set_keymap('n', ']g',        '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
--   buf_set_keymap('n', 'sl',        '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
--   buf_set_keymap('n', '<space>p',  '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
-- end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' }
}

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
local function detected_root_dir(root_dir)
  return not(not(root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf())))
end
lsp_installer.on_server_ready(function(server)
  local opts = {}
  -- opts.on_attach = on_attach
  opts.capabilities = capabilities

  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs.lua
  if server.name == "tsserver" or server.name == "eslint" then
    local root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
    opts.root_dir = root_dir
    opts.autostart = detected_root_dir(root_dir)
  elseif server.name == "denols" then
    local root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
    opts.root_dir = root_dir
    opts.filetypes = {
      "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "markdown", "json"
    }
    opts.autostart = detected_root_dir(root_dir)
    opts.init_options = { lint = true, unstable = true, }
  elseif server.name == "efm" then
    -- https://skanehira.github.io/blog/posts/20201116-vim-writing-articles/
    opts.filetypes = { "markdown" }
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
          }
        }
      }
    }
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

require("lsp_signature").setup()

require('skkeleton_indicator').setup({
  alwaysShown = false,
  fadeOutMs = 30000,
})

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
})
require('lualine').setup()
require('colorizer').setup()
require('hop').setup()

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

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#dont-preview-binaries
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local preview_except_binaries = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      if mime_type == "text" then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end
  }):sync()
end

-- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-993956937
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local telescope_custom_actions = {}
function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selected_entry = action_state.get_selected_entry()
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  end
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("cfdo " .. open_cmd)
end
function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
end
function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "split")
end
function telescope_custom_actions.multi_selection_open_tab(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "tabe")
end
function telescope_custom_actions.multi_selection_open(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end
require('telescope').setup({
  defaults = {
    generic_sorter = require('mini.fuzzy').get_telescope_sorter ,
    buffer_previewer_maker = preview_except_binaries,
    mappings = {
      i = {
        ["<ESC>"] = actions.close,
        ["<C-J>"] = actions.move_selection_next,
        ["<C-K>"] = actions.move_selection_previous,
        ["<TAB>"] = actions.toggle_selection,
        ["<C-TAB>"] = actions.toggle_selection + actions.move_selection_next,
        ["<S-TAB>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<CR>"] = telescope_custom_actions.multi_selection_open,
        ["<C-V>"] = telescope_custom_actions.multi_selection_open_vsplit,
        ["<C-S>"] = telescope_custom_actions.multi_selection_open_split,
        ["<C-T>"] = telescope_custom_actions.multi_selection_open_tab,
        ["<C-DOWN>"] = require('telescope.actions').cycle_history_next,
        ["<C-UP>"] = require('telescope.actions').cycle_history_prev,
      },
      n = i,
    },
  }
})

require('filetype').setup({
  overrides = {
    extensions = {
      bashrc = 'bash',
      env = 'env',
    },
    complex = {
      ["%.env.*"] = "env",
      ["%.zshrc.*"] = "zsh",
      [".*shrc"] = "bash",
      ["git--__.+"] = "bash",
    },
  }
})
EOF

"-----------------
" Commands and Functions
"-----------------
command! RcEdit edit expand('<sfile>:p')
command! RcReload write | source expand('<sfile>:p') | nohlsearch | redraw | echo 'init.vim is reloaded.'
command! CopyFullPath     let @*=expand('%:p') | echo 'copy full path'
command! CopyDirName      let @*=expand('%:h') | echo 'copy dir name'
command! CopyFileName     let @*=expand('%:t') | echo 'copy file name'
command! CopyRelativePath let @*=expand('%:h').'/'.expand('%:t') | echo 'copy relative path'
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
  let link = trim(getreg('"'))
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

"-----------------
" Auto Commands
"-----------------
augroup vimrc
  autocmd!
  " https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
  autocmd FileType gitcommit nnoremap <buffer> <CR> :<C-u>silent! normal! "_dip |
        \ put! =getline('.')->substitute('^\s*#\s*\(\S*\).*$', '\1', 'g') | startinsert!<CR>

  " [NeovimのTerminalモードをちょっと使いやすくする](https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal)
  autocmd TermOpen * startinsert

  " 前回終了位置に復帰
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute 'normal g`"' | endif | delmarks!

  " [vim-jp » Hack #202: 自動的にディレクトリを作成する](https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html)
  autocmd BufWritePre * call s:ensure_dir(expand('<afile>:p:h'), v:cmdbang)
  function! s:ensure_dir(dir, force)
    if !isdirectory(a:dir) && (a:force || confirm('"' . a:dir . '" does not exist. Create?', "y\nN"))
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END
