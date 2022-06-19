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

let s:fzf_commands = ['GFiles?', 'Buffers', 'Files', 'History', 'Rg', 'Commands']
call jetpack#add('junegunn/fzf.vim', #{ on: s:fzf_commands })
call jetpack#add('junegunn/fzf', #{ do: {-> fzf#install()} })

call jetpack#add('vim-denops/denops.vim')
call jetpack#add('yuki-yano/fuzzy-motion.vim')

call jetpack#add('neovim/nvim-lspconfig')
call jetpack#add('williamboman/nvim-lsp-installer')

call jetpack#add('Shougo/ddc.vim')
call jetpack#add('Shougo/pum.vim')
call jetpack#add('Shougo/ddc-around')
call jetpack#add('Shougo/ddc-nvim-lsp')
call jetpack#add('LumaKernel/ddc-file')
call jetpack#add('delphinus/ddc-treesitter')
call jetpack#add('octaltree/cmp-look')
call jetpack#add('LumaKernel/ddc-tabnine')
call jetpack#add('Shougo/ddc-matcher_head')
call jetpack#add('Shougo/ddc-sorter_rank')
call jetpack#add('Shougo/ddc-converter_remove_overlap')
call jetpack#add('matsui54/denops-signature_help')
call jetpack#add('matsui54/denops-popup-preview.vim')
call jetpack#add('vim-skk/skkeleton')

call jetpack#add('lewis6991/impatient.nvim')
call jetpack#add('nvim-lualine/lualine.nvim')
call jetpack#add('folke/which-key.nvim')
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
call jetpack#add('hrsh7th/vim-searchx')
call jetpack#add('monaqa/dial.nvim')
call jetpack#add('segeljakt/vim-silicon', #{ on: 'Silicon' })
call jetpack#add('simeji/winresizer', #{ on: 'WinResizerStartResize' })
call jetpack#add('echasnovski/mini.nvim')

" call jetpack#add('sonph/onehalf', #{ rtp: 'vim/' })
call jetpack#add('sainnhe/edge')
call jetpack#add('vim-jp/vimdoc-ja', #{ for: 'help' })
call jetpack#end()

let g:lazygit_floating_window_scaling_factor = 1
let g:silicon = #{
  \   font:   'UDEV Gothic 35JPDOC',
  \   output: '~/Downloads/silicon-{time:%Y-%m-%d-%H%M%S}.png'
  \ }

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
    \   autoCompleteEvents: ['TextChangedI', 'TextChangedP', 'CmdlineChanged'],
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
  \   'forceCompletionPattern': '\S/\S*'
  \ },
  \ 'around': {'mark': 'A'},
  \ })
call ddc#enable()
call popup_preview#enable()
call signature_help#enable()
imap <silent><expr> <Tab>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<Tab>'
imap <silent><expr> <S-Tab>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<S-Tab>'
imap <silent><expr> <CR>
      \ pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" }}}

" {{{ fuzzy-motion.vim
nnoremap s; <Cmd>FuzzyMotion<CR>
let g:fuzzy_motion_auto_jump = v:true
" }}}

" {{{ fzf.vim
let $FZF_DEFAULT_COMMAND = 'find_for_vim'
nnoremap <Space>a <Cmd>GFiles?<CR>
nnoremap <Space>b <Cmd>Buffers<CR>
nnoremap <Space>f <Cmd>Files<CR>
nnoremap <Space>h <Cmd>History<CR>
nnoremap <Space>/ :<C-u>Rg ""<Left>
nnoremap <Space>? :<C-u>Rg ""<Left><C-r><C-f>
nnoremap <Space>: <Cmd>Commands<CR>
xnoremap <Space>? "zy:<C-u>Rg "<C-r>z"<Left>
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
let g:searchx.nohlsearch = #{ jump: v:false }
function g:searchx.convert(input) abort
  if a:input !~# '\k'
    return '\V' .. a:input
  endif
  return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
endfunction
" }}}

" {{{ dial.vim
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
    augend.case.new{
      types = {"camelCase", "PascalCase", "snake_case", "kebab-case", "SCREAMING_SNAKE_CASE"},
    },
  },
}
EOF
xmap g<C-a> g<Plug>(dial-increment)
xmap g<C-x> g<Plug>(dial-decrement)
Keymap nx <C-a> <Plug>(dial-increment)
Keymap nx <C-x> <Plug>(dial-decrement)
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
" }}}

" {{{ colorscheme
let g:edge_style = 'aura'
let g:edge_better_performance = 1
let g:edge_dim_foreground = 1
colorscheme edge
" colorscheme onehalfdark
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
local nvim_lsp = require('lspconfig')
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs.lua
local node_root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf()) ~= nil
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {}
  if server.name == "tsserver" then
    opts.autostart = is_node_repo
    opts.settings = { documentFormatting = false }
    opts.init_options = { hostInfo = "neovim" }
  elseif server.name == "eslint" then
    opts.autostart = is_node_repo
  elseif server.name == "denols" then
    opts.autostart = not(is_node_repo)
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
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'grn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>p', vim.lsp.buf.formatting, bufopts)
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)
require('which-key').setup()
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
