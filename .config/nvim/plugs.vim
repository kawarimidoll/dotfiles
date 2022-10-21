source ~/dotfiles/.vim/vimrc

let g:markdown_fenced_languages = ['ts=typescript', 'js=javascript']

" {{{ Qfutils
function! s:load_qfutils(args) abort
  source ~/dotfiles/.config/nvim/qfutils.vim
  execute 'Qfutils' a:args
endfunction
command! -nargs=+ Qfutils call s:load_qfutils(<q-args>)
" }}}

" {{{ commands.vim
source ~/dotfiles/.config/nvim/commands.vim
let g:my_vimrc = expand('<sfile>:p')
Keymap nx gf <Cmd>SmartOpen<CR>
" }}}

" {{{ override completion behavior
luafile ~/dotfiles/.config/nvim/override_neovim_completion.lua
" }}}

" {{{ Plugs
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let s:plug_path = (has('nvim') ? stdpath('data') .. '/site' : '~/.vim') .. '/autoload/plug.vim'
if empty(glob(s:plug_path))
  let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  call system(printf('curl --create-dirs -fLo %s %s', s:plug_path, s:plug_url))
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \ |   PlugInstall --sync | source $MYVIMRC
      \ | endif

call plug#begin()
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
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
" Plug 'folke/noice.nvim'
Plug 'vim-denops/denops.vim', { 'on': [] }
Plug 'Shougo/ddc.vim', { 'on': [] }
Plug 'vim-skk/skkeleton', { 'on': [] }
Plug 'skk-dev/dict', { 'as': 'skk-dict' }
let g:skk_dict_dir = g:plugs['skk-dict']['dir']
Plug 'kawarimidoll/mru_cache.lua'
Plug 'haya14busa/vim-asterisk', { 'on': [] }
Plug 'kevinhwang91/nvim-hlslens', { 'on': [] }
Plug 'petertriho/nvim-scrollbar'
Plug 'folke/which-key.nvim', { 'on': [] }
Plug 'uga-rosa/ccc.nvim', { 'on': [] }
Plug 'kyazdani42/nvim-web-devicons', { 'on': [] }
Plug 'rcarriga/nvim-notify'
Plug 'lewis6991/gitsigns.nvim'
Plug 'anuvyklack/pretty-fold.nvim'
function! s:vim_enter_plugs() abort
  if get(g:, 'vim_entered')
   return
  end
  let g:vim_entered = 1
  call plug#load(
        \ 'denops.vim',
        \ 'ddc.vim',
        \ 'skkeleton',
        \ 'vim-asterisk',
        \ 'nvim-hlslens',
        \ 'which-key.nvim',
        \ 'ccc.nvim',
        \ )
  luafile ~/dotfiles/.config/nvim/plugin_config/mru_cache.lua
  let g:asterisk#keeppos = 1
  luafile ~/dotfiles/.config/nvim/plugin_config/hlslens.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/scrollbar.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/which-key.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/notify.lua
  " luafile ~/dotfiles/.config/nvim/plugin_config/noice.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/gitsigns.lua
  lua require('pretty-fold').setup({})
  execute 'luafile' g:plug_home .. '/ccc.nvim/plugin/ccc.lua'
  lua require('ccc').setup({ highlighter = { auto_enable = true } })
endfunction
autocmd VimEnter * ++once call <sid>vim_enter_plugs()
" }}}

" {{{ load on WinEnter
" Plug 'tkmpypy/chowcho.nvim', { 'on': [] }
Plug 'levouh/tint.nvim'
function! s:win_enter_plugs() abort
  if get(g:, 'win_entered')
   return
  end
  let g:win_entered = 1
  " call plug#load('chowcho.nvim')
  " luafile ~/dotfiles/.config/nvim/plugin_config/chowcho.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/tint.lua
endfunction
autocmd WinNew * ++once call <sid>win_enter_plugs()
" }}}

" {{{ load for quickfix
Plug 'kevinhwang91/nvim-bqf', { 'for': 'qf' }
Plug 'ten3roberts/qf.nvim', { 'on': [] }
function! s:qf_pre_plugs() abort
  if exists(':Lbelow') == 2
   return
  end
  call plug#load('qf.nvim')
  lua require('qf').setup()
endfunction
autocmd QuickFixCmdPre * ++once call <sid>qf_pre_plugs()
" }}}

" {{{ lsp
Plug 'neovim/nvim-lspconfig', { 'on': [] }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'j-hui/fidget.nvim'
Plug 'onsails/lspkind.nvim'
Plug 'folke/neodev.nvim'
function! s:lsp_init() abort
  if exists(':LspInfo') == 2
    return
  end
  call plug#load('nvim-lspconfig')
  lua require('lsp_signature').setup()
  lua require('lspkind').init({ mode = 'symbol_text' })
  execute 'luafile' g:plug_home .. '/nvim-lspconfig/plugin/lspconfig.lua'
  luafile ~/dotfiles/.config/nvim/plugin_config/lsp.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/null_ls.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/fidget.lua
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
Plug 'David-Kunz/treesitter-unit'
Plug 'mfussenegger/nvim-ts-hint-textobject', { 'on': [] }
Plug 'm-demare/hlargs.nvim'
Plug 'andymass/vim-matchup', { 'on': [] }
Plug 'yioneko/nvim-yati', { 'on': [] }
Plug 'haringsrob/nvim_context_vt', { 'on': [] }
function! s:treesitter_init() abort
  if exists(':TSEnable') == 2
    return
  end
  " https://zenn.dev/kawarimidoll/articles/8e124a88dde820
  call plug#load(
        \ 'nvim-treesitter',
        \ 'nvim-treesitter-refactor',
        \ 'nvim-ts-context-commentstring',
        \ 'nvim-ts-rainbow',
        \ 'nvim-ts-hint-textobject',
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

" {{{ load on InsertEnter
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'ray-x/cmp-treesitter'
Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
Plug 'lukas-reineke/cmp-rg'
Plug 'hrsh7th/cmp-nvim-lsp-document-symbol'
Plug 'f3fora/cmp-spell'
Plug 'octaltree/cmp-look'
Plug 'rinx/cmp-skkeleton'
Plug 'hrsh7th/vim-vsnip', { 'on': [] }
Plug 'hrsh7th/vim-vsnip-integ', { 'on': [] }
Plug 'rafamadriz/friendly-snippets'
Plug 'Shougo/pum.vim'
Plug 'uga-rosa/jam.nvim', { 'on': [] }
function! s:insert_enter_plugs() abort
  if get(g:, 'insert_entered')
    return
  end
  let g:insert_entered = 1
  call plug#load(
        \ 'vim-vsnip',
        \ 'vim-vsnip-integ',
        \ 'jam.nvim',
        \ )
  source ~/dotfiles/.config/nvim/plugin_config/vsnip.vim
  luafile ~/dotfiles/.config/nvim/plugin_config/cmp.lua

  source ~/dotfiles/.config/nvim/plugin_config/skkeleton.vim
  let g:skk_ddc_alternative = 'cmp'
  source ~/dotfiles/.config/nvim/plugin_config/skk_ddc_alt.vim

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
Plug 'anuvyklack/keymap-amend.nvim'
Plug 'lewis6991/impatient.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'vim-jp/vimdoc-ja'
" }}}
call plug#end()

command! PlugSync PlugUpgrade | PlugClean! | PlugInstall --sync | PlugUpdate
lua require('impatient')
luafile ~/dotfiles/.config/nvim/plugin_config/mini.lua
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
