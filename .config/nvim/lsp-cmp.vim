if filereadable(expand('~/dotfiles/.config/nvim/min-edit.vim'))
  source ~/dotfiles/.config/nvim/min-edit.vim
endif

set autoindent
set autoread
set completeopt=menu,menuone,noselect
set history=2000
set inccommand=split
set infercase
set lazyredraw
set linebreak
set list
set listchars=tab:^-,trail:~,extends:»,precedes:«,nbsp:%
set scrollback=2000
set signcolumn=number
set switchbuf+=usetab
set termguicolors
set updatetime=300
set wildmode=longest,full
let g:markdown_fenced_languages = ['ts=typescript', 'js=javascript']

" {{{ Qfutils
function! s:load_qfutils(args) abort
  source ~/dotfiles/.config/nvim/qfutils.vim
  execute 'Qfutils' a:args
endfunction
command! -nargs=+ Qfutils call s:load_qfutils(<q-args>)
" }}}

" function s:load_async_terminal(args) abort
"   source ~/dotfiles/.config/nvim/async_terminal.vim
"   execute 'AsyncTerminal' a:args
" endfunction
" command! -nargs=+ AsyncTerminal call s:load_async_terminal(<q-args>)
" command! -nargs=+ Gtt AsyncTerminal git <q-args>

" {{{ commands.vim
source ~/dotfiles/.config/nvim/commands.vim
let g:my_vimrc = expand('<sfile>:p')
Keymap nx gf <Cmd>SmartOpen<CR>
" }}}

" {{{ Plugs
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
" {{{ fzf-lua
Plug 'ibhagwan/fzf-lua', { 'branch': 'main', 'on': 'FzfLua' }
autocmd QuickFixCmdPre * ++once call plug#load('fzf-lua')
autocmd User fzf-lua ++once luafile ~/dotfiles/.config/nvim/plugin_config/fzf_lua.lua
nnoremap <Space>a <Cmd>FzfLua git_status<CR>
nnoremap <Space>b <Cmd>FzfLua buffers<CR>
nnoremap <Space>B <Cmd>FzfLua blines<CR>
nnoremap <Space>c <Cmd>FzfLua command_history<CR>
nnoremap <Space>C <Cmd>FzfLua quickfix<CR>
nnoremap <Space>f <Cmd>FzfLua files<CR>
nnoremap <Space>F <Cmd>FzfLua builtin<CR>
nnoremap <Space>h <Cmd>FzfLua mru cwd_only=true<CR>
nnoremap <Space>H <Cmd>FzfLua help_tags<CR>
nnoremap <Space>j <Cmd>FzfLua jumps<CR>
nnoremap <Space>l <Cmd>FzfLua lines<CR>
nnoremap <Space>m <Cmd>FzfLua marks<CR>
nnoremap <Space>z <Cmd>FzfLua live_grep<CR>
nnoremap <Space>: <Cmd>FzfLua commands<CR>
" }}}

" {{{ pounce.nvim
Plug 'rlane/pounce.nvim', { 'on': 'Pounce' }
Keymap nx s; <Cmd>Pounce<CR>
Keymap nx s' <Cmd>Pounce<CR>
autocmd User pounce.nvim ++once luafile ~/dotfiles/.config/nvim/plugin_config/pounce.lua
" }}}

" {{{ load on VimEnter
Plug 'nvim-lua/plenary.nvim', { 'on': [] }
Plug 'vim-denops/denops.vim', { 'on': [] }
Plug 'vim-skk/skkeleton', { 'on': [] }
Plug 'Shougo/ddc.vim', { 'on': [] }
Plug 'kawarimidoll/mru_cache.lua', { 'on': [] }
Plug 'haya14busa/vim-asterisk', { 'on': [] }
Plug 'kevinhwang91/nvim-hlslens', { 'on': [] }
Plug 'petertriho/nvim-scrollbar', { 'on': [] }
Plug 'folke/which-key.nvim', { 'on': [] }
Plug 'uga-rosa/ccc.nvim', { 'on': ['CccPick'] }
Plug 'kyazdani42/nvim-web-devicons', { 'on': [] }
Plug 'rcarriga/nvim-notify', { 'on': [] }
Plug 'lewis6991/gitsigns.nvim', { 'on': [] }
Plug 'tkmpypy/chowcho.nvim', { 'on': [] }
Plug 'anuvyklack/pretty-fold.nvim', { 'on': [] }
Plug 'levouh/tint.nvim', { 'on': [] }
function! s:vim_enter_plugs() abort
  if get(g:, 'vim_entered')
   return
  end
  let g:vim_entered = 1
  call plug#load(
        \ 'plenary.nvim',
        \ 'denops.vim',
        \ 'skkeleton',
        \ 'ddc.vim',
        \ 'mru_cache.lua',
        \ 'vim-asterisk',
        \ 'nvim-hlslens',
        \ 'nvim-scrollbar',
        \ 'which-key.nvim',
        \ 'ccc.nvim',
        \ 'nvim-web-devicons',
        \ 'nvim-notify',
        \ )
  call plug#load(
        \ 'gitsigns.nvim',
        \ 'chowcho.nvim',
        \ 'pretty-fold.nvim',
        \ )
  if exists('*nvim_win_set_hl_ns')
    call plug#load('tint.nvim')
    luafile ~/dotfiles/.config/nvim/plugin_config/tint.lua
  endif
  source ~/dotfiles/.config/nvim/plugin_config/skkeleton.vim
  source ~/dotfiles/.config/nvim/plugin_config/skk_ddc_cmp.vim
  luafile ~/dotfiles/.config/nvim/plugin_config/mru_cache.lua
  let g:asterisk#keeppos = 1
  luafile ~/dotfiles/.config/nvim/plugin_config/hlslens.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/scrollbar.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/which-key.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/notify.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/gitsigns.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/chowcho.lua
  lua require('pretty-fold').setup({})
  lua require('ccc').setup({ highlighter = { auto_enable = true } })
endfunction
autocmd VimEnter * ++once call <sid>vim_enter_plugs()
" }}}

" {{{ load for quickfix
Plug 'kevinhwang91/nvim-bqf', { 'for': 'qf' }
Plug 'ten3roberts/qf.nvim', { 'on': [] }
function! s:qf_pre_plugs() abort
  if get(g:, 'qf_pre_loaded')
   return
  end
  let g:qf_pre_loaded = 1
  call plug#load(
        \ 'qf.nvim',
        \ )
  lua require('qf').setup()
endfunction
autocmd QuickFixCmdPre * ++once call <sid>qf_pre_plugs()
" }}}

" {{{ lsp
Plug 'neovim/nvim-lspconfig', { 'on': [] }
Plug 'williamboman/mason.nvim', { 'on': [] }
Plug 'williamboman/mason-lspconfig.nvim', { 'on': [] }
Plug 'jose-elias-alvarez/null-ls.nvim', { 'on': [] }
Plug 'ray-x/lsp_signature.nvim', { 'on': [] }
Plug 'j-hui/fidget.nvim', { 'on': [] }
Plug 'onsails/lspkind.nvim', { 'on': [] }
Plug 'folke/lua-dev.nvim', { 'for': 'lua' }
function! s:lsp_init() abort
  if get(g:, 'lsp_loaded')
    return
  end
  let g:lsp_loaded = 1
  " call s:cmp_init()
  call plug#load(
        \ 'nvim-lspconfig',
        \ 'mason.nvim',
        \ 'mason-lspconfig.nvim',
        \ 'null-ls.nvim',
        \ 'lsp_signature.nvim',
        \ 'lspkind.nvim',
        \ 'fidget.nvim',
        \ )
  lua require("lsp_signature").setup()
  lua require("fidget").setup()
  lua require("lspkind").init({ mode = 'symbol_text' })
  execute 'luafile' g:plug_home .. '/nvim-lspconfig/plugin/lspconfig.lua'
  luafile ~/dotfiles/.config/nvim/plugin_config/lsp.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/null_ls.lua
endfunction
autocmd BufReadPost * ++once call <sid>lsp_init()
" }}}

" {{{ trouble.nvim
Plug 'folke/trouble.nvim', { 'on': ['Trouble', 'TroubleToggle'] }
autocmd User trouble.nvim ++once luafile ~/dotfiles/.config/nvim/plugin_config/trouble.lua
nnoremap <leader>xx <Cmd>TroubleToggle<CR>
nnoremap <leader>xw <Cmd>TroubleToggle workspace_diagnostics<CR>
nnoremap <leader>xd <Cmd>TroubleToggle document_diagnostics<CR>
nnoremap <leader>xq <Cmd>TroubleToggle quickfix<CR>
nnoremap <leader>xl <Cmd>TroubleToggle loclist<CR>
nnoremap gR <Cmd>TroubleToggle lsp_references<CR>
" }}}

" {{{ lspsaga.nvim
Plug 'tami5/lspsaga.nvim', { 'on': ['Lspsaga'] }
nnoremap gh <Cmd>Lspsaga lsp_finder<CR>
" nnoremap grr <Cmd>Lspsaga rename<CR>
nnoremap gD <Cmd>Lspsaga preview_definition<CR>
nnoremap <leader>ca <Cmd>Lspsaga code_action<CR>
vnoremap <leader>ca <Cmd>Lspsaga range_code_action<CR>

nnoremap <leader>cd <Cmd>Lspsaga show_line_diagnostics<CR>
nnoremap <leader>cc <Cmd>Lspsaga show_cursor_diagnostics<CR>
nnoremap [d <Cmd>Lspsaga diagnostic_jump_prev<CR>
nnoremap ]d <Cmd>Lspsaga diagnostic_jump_next<CR>

function! s:ex_help(word) abort
  if index(['vim', 'help'], &filetype) >= 0
    execute 'help' a:word
    return
  endif

  if &filetype == 'lua'
    let col = getcurpos('.')[2]
    let line = getline('.')
    let pre = substitute(line[:col-1], '^.*[^0-9A-Za-z_.]', '', '')
    let post = substitute(line[col:], '[^0-9A-Za-z_].*$', '', '')
    let cword = pre .. post

    if cword =~ '\.'
      try
        execute 'help' cword
        return
      catch
        " nop
      endtry
    endif
    try
      execute 'help' 'luaref-' .. a:word
      return
    catch
      " nop
    endtry
    try
      execute 'help' a:word
      return
    catch
      " nop
    endtry
  endif

  " no help in vim
  Lspsaga hover_doc
endfunction
command! -nargs=+ ExHelp call s:ex_help(<q-args>)
set keywordprg=:ExHelp

function! s:lspsaga_init() abort
  nnoremap <C-n> <Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<C-n>')<CR>
  nnoremap <C-p> <Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<C-p>')<CR>
endfunction
autocmd User lspsaga.nvim ++once call s:lspsaga_init()
" }}}

" {{{ treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate', 'on': [] }
Plug 'nvim-treesitter/nvim-treesitter-refactor', { 'on': [] }
Plug 'JoosepAlviste/nvim-ts-context-commentstring', { 'on': [] }
Plug 'p00f/nvim-ts-rainbow', { 'on': [] }
Plug 'romgrk/nvim-treesitter-context', { 'on': [] }
Plug 'David-Kunz/treesitter-unit', { 'on': [] }
Plug 'mfussenegger/nvim-ts-hint-textobject', { 'on': [] }
Plug 'm-demare/hlargs.nvim', { 'on': [] }
Plug 'andymass/vim-matchup', { 'on': [] }
Plug 'yioneko/nvim-yati', { 'on': [] }
Plug 'haringsrob/nvim_context_vt', { 'on': [] }
function! s:treesitter_init() abort
  if get(g:, 'treesitter_loaded')
    return
  end
  let g:treesitter_loaded = 1
  " https://zenn.dev/kawarimidoll/articles/8e124a88dde820
  call plug#load(
        \ 'nvim-treesitter',
        \ 'nvim-treesitter-refactor',
        \ 'nvim-ts-context-commentstring',
        \ 'nvim-ts-rainbow',
        \ 'treesitter-unit',
        \ 'nvim-ts-hint-textobject',
        \ 'hlargs.nvim',
        \ 'vim-matchup',
        \ 'nvim-yati',
        \ 'nvim_context_vt',
        \ )
  execute 'luafile' g:plug_home .. '/nvim-treesitter/plugin/nvim-treesitter.lua'
  luafile ~/dotfiles/.config/nvim/plugin_config/treesitter.lua
  TSEnable highlight

  " do not replace to <cmd>
  omap     <silent> m :<C-u>lua require('tsht').nodes()<CR>
  vnoremap <silent> m :lua require('tsht').nodes()<CR>
  xnoremap iu :lua require('treesitter-unit').select()<CR>
  xnoremap au :lua require('treesitter-unit').select(true)<CR>
  onoremap iu :<C-u>lua require('treesitter-unit').select()<CR>
  onoremap au :<C-u>lua require('treesitter-unit').select(true)<CR>
  lua require('hlargs').setup()
endfunction
autocmd BufReadPost * ++once call <sid>treesitter_init()
" }}}

" {{{ nvim-cmp
Plug 'hrsh7th/nvim-cmp', { 'on': [] }
Plug 'hrsh7th/cmp-nvim-lsp', { 'on': [] }
Plug 'hrsh7th/cmp-buffer', { 'on': [] }
Plug 'hrsh7th/cmp-path', { 'on': [] }
Plug 'hrsh7th/cmp-cmdline', { 'on': [] }
Plug 'hrsh7th/cmp-vsnip', { 'on': [] }
Plug 'hrsh7th/cmp-nvim-lua', { 'on': [] }
Plug 'ray-x/cmp-treesitter', { 'on': [] }
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh', 'on': [] }
Plug 'lukas-reineke/cmp-rg', { 'on': [] }
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol', { 'on': [] }
Plug 'f3fora/cmp-spell', { 'on': [] }
Plug 'octaltree/cmp-look', { 'on': [] }
function! s:cmp_init() abort
  if get(g:, 'cmp_loaded')
    return
  end
  let g:cmp_loaded = 1
  call plug#load(
        \ 'nvim-cmp',
        \ 'cmp-nvim-lsp',
        \ 'cmp-buffer',
        \ 'cmp-path',
        \ 'cmp-cmdline',
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
  " execute 'luafile' g:plug_home .. '/nvim-cmp/plugin/cmp.lua'
  luafile ~/dotfiles/.config/nvim/plugin_config/cmp.lua
endfunction
" }}}

" {{{ load on InsertEnter
Plug 'hrsh7th/vim-vsnip', { 'on': [] }
Plug 'rafamadriz/friendly-snippets', { 'on': [] }
Plug 'Shougo/pum.vim', { 'on': [] }
Plug 'uga-rosa/jam.nvim', { 'on': [] }
function! s:insert_enter_plugs() abort
  if get(g:, 'insert_entered')
    return
  end
  let g:insert_entered = 1
  call plug#load(
        \ 'vim-vsnip',
        \ 'friendly-snippets',
        \ 'pum.vim',
        \ 'jam.nvim',
        \ )

  let g:vsnip_filetypes = {}
  let g:vsnip_filetypes.javascriptreact = ['javascript']
  let g:vsnip_filetypes.typescriptreact = ['typescript']
  " smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
  " smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
  smap j <BS>j
  smap k <BS>k
  " Keymap is <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)'         : '<C-j>'
  Keymap is <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  Keymap nx st <Plug>(vsnip-select-text)
  Keymap nx sT <Plug>(vsnip-cut-text)

  execute 'luafile' g:plug_home .. '/jam.nvim/plugin/jam.lua'
  luafile ~/dotfiles/.config/nvim/plugin_config/jam.lua
endfunction
autocmd InsertEnter * ++once call <sid>insert_enter_plugs()
" }}}

" {{{ dial.nvim
Plug 'monaqa/dial.nvim', { 'on': '<Plug>(dial-' }
xmap g<C-a> g<Plug>(dial-increment)
xmap g<C-x> g<Plug>(dial-decrement)
Keymap nx <C-a> <Plug>(dial-increment)
Keymap nx <C-x> <Plug>(dial-decrement)
autocmd User dial.nvim ++once luafile ~/dotfiles/.config/nvim/plugin_config/dial.lua
" }}}

" {{{ winresizer
Plug 'simeji/winresizer', { 'on': 'WinResizerStartResize' }
nnoremap <C-e> <Cmd>WinResizerStartResize<CR>
" }}}

" {{{ vim-silicon
Plug 'segeljakt/vim-silicon', { 'on': 'Silicon' }
autocmd User vim-silicon ++once source ~/dotfiles/.config/nvim/plugin_config/silicon.vim
" }}}

" {{{ capture.vim
Plug 'tyru/capture.vim', { 'on': [] }
autocmd CmdlineEnter * ++once call plug#load('capture.vim')
" }}}

" {{{ neoterm
Plug 'kassio/neoterm', { 'on': ['T', 'Tnew'] }
autocmd User neoterm ++once source ~/dotfiles/.config/nvim/plugin_config/neoterm.vim
" }}}

" {{{ vim-floaterm
Plug 'voldikss/vim-floaterm', { 'on': ['FloatermNew'] }
" }}}

" {{{ markdown-preview.nvim
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': ['markdown'] }
" }}}

" {{{ venn.nvim
Plug 'jbyuki/venn.nvim', { 'on': [] }
function! s:venn_toggle() abort
  if !get(g:, 'venn_loaded')
    call plug#load('venn.nvim')
    execute 'luafile' g:plug_home .. '/venn.nvim/plugin/venn.lua'
    let g:venn_loaded = 1
  endif
  if get(b:, 'venn_enabled')
    setlocal virtualedit=
    mapclear <buffer>
    unlet! b:venn_enabled
  else
    let b:venn_enabled = 1
    setlocal virtualedit=all
    nnoremap <buffer><nowait> <C-j> <C-v>j:VBox<CR>
    nnoremap <buffer><nowait> <C-k> <C-v>k:VBox<CR>
    nnoremap <buffer><nowait> <C-l> <C-v>l:VBox<CR>
    nnoremap <buffer><nowait> <C-h> <C-v>h:VBox<CR>
    vnoremap <buffer><nowait> f :VBox<CR>
  endif
endfunction
command! VToggle call s:venn_toggle()
" }}}

" {{{ load immediately
Plug 'anuvyklack/keymap-amend.nvim', { 'on': [] }
Plug 'lewis6991/impatient.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'vim-jp/vimdoc-ja'
" }}}
call plug#end()

command! PlugSync PlugUpgrade | PlugClean! | PlugInstall --sync | PlugUpdate
lua require('impatient')
luafile ~/dotfiles/.config/nvim/plugin_config/mini.lua
" call <sid>cmp_init()
" }}}

" {{{ user owned mappings
Keymap n <expr> [b '<Cmd>Qfutils BCycle -' .. v:count1 .. '<CR>'
Keymap n <expr> ]b '<Cmd>Qfutils BCycle '  .. v:count1 .. '<CR>'
Keymap n <expr> [q '<Cmd>Qfutils CCycle -' .. v:count1 .. '<CR>'
Keymap n <expr> ]q '<Cmd>Qfutils CCycle '  .. v:count1 .. '<CR>'

" [Vim で q を prefix キーにする - 永遠に未完成](https://thinca.hatenablog.com/entry/q-as-prefix-key-in-vim)
nnoremap <script> <expr> q empty(reg_recording()) ? '<sid>(q)' : 'q'
for c in g:alpha_all->split('\zs')
  execute 'nnoremap <sid>(q)' .. c '<NOP>'
endfor
nnoremap <sid>(q)q qq
nnoremap Q @q
nnoremap <sid>(q)a <Cmd>Qfutils CAdd<CR>
nnoremap <sid>(q)b <Cmd>Gitsigns toggle_current_line_blame<CR>
nnoremap <sid>(q)c <Cmd>Qfutils CToggle<CR>
nnoremap <sid>(q)d <Cmd>TroubleToggle<CR>
nnoremap <sid>(q)g :<C-u>global/^/normal<Space>
nnoremap <sid>(q)h <Cmd>HalfMove left<CR>
nnoremap <sid>(q)i <Cmd>HalfMove center<CR>
nnoremap <sid>(q)j <Cmd>HalfMove down<CR>
nnoremap <sid>(q)k <Cmd>HalfMove up<CR>
nnoremap <sid>(q)l <Cmd>HalfMove right<CR>
nnoremap <sid>(q)o <Cmd>only<CR>
nnoremap <sid>(q)t <C-^>
nnoremap <sid>(q)x <Cmd>Qfutils CClear<CR>
nnoremap <sid>(q)z <Cmd>lua MiniMisc.zoom()<CR>
nnoremap <sid>(q): q:
nnoremap <sid>(q)/ q/
nnoremap <Space>d <Cmd>keepalt lua MiniBufremove.delete()<CR>
nnoremap <Space>L <Cmd>LazyGit<CR>
" }}}

" {{{ autocmd
augroup vimrc
  autocmd!
  " https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
  autocmd FileType *commit nnoremap <buffer> <CR> <Cmd>silent! execute 'normal! ^w"zdiw"_dip"zPA: ' <bar> startinsert!<CR>

  " autocmd BufNewFile,BufRead .env* setf env
  autocmd BufNewFile,BufRead commonshrc setf bash

  " autocmd BufReadPost * delmarks!

  " :h ModeChanged
  " autocmd ModeChanged [vV\x16]*:* let &l:rnu = mode() =~# '^[vV\x16]'
  " autocmd ModeChanged *:[vV\x16]* let &l:rnu = mode() =~# '^[vV\x16]'
  " autocmd WinEnter,WinLeave * let &l:rnu = mode() =~# '^[vV\x16]'
augroup END
" }}}
