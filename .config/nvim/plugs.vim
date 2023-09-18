source ~/dotfiles/.vim/vimrc

let g:markdown_fenced_languages = ['ts=typescript', 'js=javascript']

" {{{ commands.vim
autocmd VimEnter * ++once
      \ source ~/dotfiles/.config/nvim/commands.vim
" let g:my_vimrc = expand('<sfile>:p')
" Keymap nx gf <Cmd>SmartOpen<CR>
" }}}

" {{{ override completion behavior
autocmd InsertEnter * ++once
      \ luafile ~/dotfiles/.config/nvim/override_neovim_completion.lua
" }}}

" {{{ Plugs
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
let s:plug_path = (has('nvim') ? stdpath('data') .. '/site' : '~/.vim') .. '/autoload/plug.vim'
if empty(glob(s:plug_path))
  let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  call system(printf('curl --create-dirs -fLo %s %s', s:plug_path, s:plug_url))
endif

function s:plug_load(plug_name) abort
  " https://zenn.dev/kawarimidoll/articles/8e124a88dde820
  " https://github.com/junegunn/vim-plug/pull/1157/files
  " vim-plug doesn't load lua scripts automatically when lazy-loading
  call plug#load(a:plug_name)
  const lua_scripts = join([
        \ globpath(g:plug_home, a:plug_name .. '/plugin/**/*.lua'),
        \ globpath(g:plug_home, a:plug_name .. '/after/plugin/**/*.lua'),
        \ ], "\n")
  for script in split(lua_scripts, '[\r\n]')
    execute 'luafile' script
  endfor
endfunction

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
" Plug 'Shougo/ddc.vim', { 'on': [] }
" Plug 'Shougo/ddc-ui-pum', { 'on': [] }
" Plug 'Shougo/ddc-source-around', { 'on': [] }
Plug 'vim-skk/skkeleton', { 'on': [] }
Plug 'skk-dev/dict', { 'as': 'skk-dict' }
let g:skk_dict_dir = g:plugs['skk-dict']['dir']
Plug 'tokuhirom/jawiki-kana-kanji-dict', { 'as': 'skk-wiki-dict' }
let g:skk_wiki_dict_dir = g:plugs['skk-wiki-dict']['dir']
Plug 'kawarimidoll/mru_cache.lua'
Plug 'haya14busa/vim-asterisk', { 'on': [] }
Plug 'kevinhwang91/nvim-hlslens', { 'on': [] }
Plug 'petertriho/nvim-scrollbar'
Plug 'folke/which-key.nvim', { 'on': [] }
Plug 'uga-rosa/ccc.nvim', { 'on': [] }
Plug 'nvim-tree/nvim-web-devicons', { 'on': [] }
Plug 'tzachar/highlight-undo.nvim', { 'on': [] }
" Plug 'rcarriga/nvim-notify'
Plug 'vigoux/notifier.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'itchyny/vim-qfedit'
Plug 'thinca/vim-qfreplace'
" Plug 'anuvyklack/pretty-fold.nvim'
function! s:vim_enter_plugs() abort
  if get(g:, 'vim_entered')
   return
  end
  let g:vim_entered = 1
        " \ 'ddc.vim',
        " \ 'ddc-ui-pum',
        " \ 'ddc-source-around',
  call plug#load(
        \ 'denops.vim',
        \ 'skkeleton',
        \ 'vim-asterisk',
        \ 'vim-qfedit',
        \ 'vim-qfreplace',
        \ )
  call s:plug_load('nvim-hlslens')
  call s:plug_load('which-key.nvim')
  call s:plug_load('nvim-web-devicons')
  call s:plug_load('ccc.nvim')
  call s:plug_load('highlight-undo.nvim')
  luafile ~/dotfiles/.config/nvim/plugin_config/mru_cache.lua
  let g:asterisk#keeppos = 1
  luafile ~/dotfiles/.config/nvim/plugin_config/hlslens.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/scrollbar.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/which-key.lua
  " luafile ~/dotfiles/.config/nvim/plugin_config/notify.lua
  " luafile ~/dotfiles/.config/nvim/plugin_config/noice.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/gitsigns.lua
  " lua require('pretty-fold').setup({})
  lua require('ccc').setup({ highlighter = { auto_enable = true } })
  lua require('notifier').setup({})
  command! NotifierQuickfix execute 'NotifierReplay!' | copen
  lua require('highlight-undo').setup({})
endfunction
autocmd VimEnter * ++once call <sid>vim_enter_plugs()
" }}}

" {{{ load on WinLeave
" Plug 'tkmpypy/chowcho.nvim', { 'on': [] }
Plug 'levouh/tint.nvim'
function! s:win_leave_plugs() abort
  if get(g:, 'win_leaveed')
   return
  end
  let g:win_leaveed = 1
  " call plug#load('chowcho.nvim')
  " luafile ~/dotfiles/.config/nvim/plugin_config/chowcho.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/tint.lua
  doautocmd WinLeave
endfunction
autocmd WinLeave * ++once call <sid>win_leave_plugs()
" }}}

" " {{{ load for quickfix
" Plug 'kevinhwang91/nvim-bqf', { 'for': 'qf' }
" Plug 'ten3roberts/qf.nvim', { 'on': [] }
" function! s:qf_pre_plugs() abort
"   if exists(':Lbelow') == 2
"    return
"   end
"   call plug#load('qf.nvim')
"   lua require('qf').setup()
" endfunction
" autocmd QuickFixCmdPre * ++once call <sid>qf_pre_plugs()
" " }}}

" {{{ lsp
Plug 'neovim/nvim-lspconfig', { 'on': [] }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'j-hui/fidget.nvim', { 'tag': 'legacy' }
Plug 'folke/neodev.nvim'
function! s:lsp_init() abort
  if exists(':LspInfo') == 2
    return
  end
  call s:plug_load('nvim-lspconfig')
  lua require('lsp_signature').setup()
  luafile ~/dotfiles/.config/nvim/plugin_config/lsp.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/null_ls.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/fidget.lua
endfunction
autocmd BufReadPost * ++once call <sid>lsp_init()
" }}}

" {{{ trouble.nvim
Plug 'folke/trouble.nvim', { 'on': ['Trouble', 'TroubleToggle'] }
autocmd User trouble.nvim ++once luafile ~/dotfiles/.config/nvim/plugin_config/trouble.lua
nnoremap mxx <Cmd>TroubleToggle<CR>
nnoremap mxw <Cmd>TroubleToggle workspace_diagnostics<CR>
nnoremap mxd <Cmd>TroubleToggle document_diagnostics<CR>
nnoremap mxq <Cmd>TroubleToggle quickfix<CR>
nnoremap mxl <Cmd>TroubleToggle loclist<CR>
nnoremap gR <Cmd>TroubleToggle lsp_references<CR>
" }}}

" {{{ lspsaga.nvim
Plug 'nvimdev/lspsaga.nvim', { 'on': ['Lspsaga'] }
nnoremap gh <Cmd>Lspsaga lsp_finder<CR>
" nnoremap grr <Cmd>Lspsaga rename<CR>
nnoremap gD <Cmd>Lspsaga peek_definition<CR>
nnoremap ma <Cmd>Lspsaga code_action<CR>
vnoremap ma <Cmd>Lspsaga range_code_action<CR>

nnoremap mcd <Cmd>Lspsaga show_line_diagnostics<CR>
nnoremap mcc <Cmd>Lspsaga show_cursor_diagnostics<CR>
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
  execute 'luafile' g:plug_home .. '/lspsaga.nvim/plugin/lspsaga.lua'
  lua require('lspsaga').setup({ lightbulb = { virtual_text = false } })
  nnoremap <C-n> <Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<C-n>')<CR>
  nnoremap <C-p> <Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<C-p>')<CR>
endfunction
autocmd User lspsaga.nvim ++once call s:lspsaga_init()
" }}}

" {{{ treesitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate', 'on': [] }
Plug 'nvim-treesitter/nvim-treesitter-refactor', { 'on': [] }
Plug 'JoosepAlviste/nvim-ts-context-commentstring', { 'on': [] }
Plug 'HiPhish/nvim-ts-rainbow2', { 'on': [] }
Plug 'romgrk/nvim-treesitter-context', { 'on': [] }
" Plug 'David-Kunz/treesitter-unit'
" Plug 'mfussenegger/nvim-treehopper', { 'on': [] }
Plug 'm-demare/hlargs.nvim', { 'on': [] }
Plug 'andymass/vim-matchup', { 'on': [] }
Plug 'yioneko/nvim-yati', { 'on': [] }
Plug 'haringsrob/nvim_context_vt', { 'on': [] }
function! s:treesitter_init() abort
  if exists(':TSEnable') == 2
    return
  end
  call s:plug_load('nvim-treesitter')
  call s:plug_load('nvim-treesitter-refactor')
  call s:plug_load('nvim-ts-context-commentstring')
  call s:plug_load('nvim-ts-rainbow2')
  " call s:plug_load('nvim-treehopper')
  call s:plug_load('vim-matchup')
  call s:plug_load('nvim-yati')
  call s:plug_load('nvim_context_vt')
  call s:plug_load('hlargs.nvim')

  luafile ~/dotfiles/.config/nvim/plugin_config/treesitter.lua

  " " do not replace to <cmd>
  " omap     <silent> m :<C-u>lua require('tsht').nodes()<CR>
  " vnoremap <silent> m :lua require('tsht').nodes()<CR>
  " xnoremap iu :lua require('treesitter-unit').select()<CR>
  " xnoremap au :lua require('treesitter-unit').select(true)<CR>
  " onoremap iu :<C-u>lua require('treesitter-unit').select()<CR>
  " onoremap au :<C-u>lua require('treesitter-unit').select(true)<CR>

  lua require('hlargs').setup()
endfunction
autocmd BufReadPost * ++once call <sid>treesitter_init()
" }}}

" {{{ load on InsertEnter
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
Plug 'uga-rosa/cmp-skkeleton', { 'on': [] }
Plug 'onsails/lspkind.nvim', { 'on': [] }
Plug 'hrsh7th/vim-vsnip', { 'on': [] }
Plug 'hrsh7th/vim-vsnip-integ', { 'on': [] }
Plug 'rafamadriz/friendly-snippets', { 'on': [] }
Plug 'Shougo/pum.vim'
Plug 'uga-rosa/jam.nvim', { 'on': [] }
Plug 'zbirenbaum/copilot.lua', { 'on': [] }
Plug 'zbirenbaum/copilot-cmp', { 'on': [] }
Plug 'tani/vim-typo', { 'on': []}
Plug 'hrsh7th/nvim-insx', { 'on': []}
let g:copilot_no_tab_map = v:true
function! s:insert_enter_plugs() abort
  if get(g:, 'insert_entered')
    return
  endif
  let g:insert_entered = 1

  call s:plug_load('nvim-cmp')
  call s:plug_load('cmp-nvim-lsp')
  call s:plug_load('cmp-buffer')
  call s:plug_load('cmp-path')
  call s:plug_load('cmp-cmdline')
  call s:plug_load('cmp-vsnip')
  call s:plug_load('cmp-nvim-lua')
  call s:plug_load('cmp-treesitter')
  call s:plug_load('cmp-tabnine')
  call s:plug_load('cmp-rg')
  call s:plug_load('cmp-nvim-lsp-document-symbol')
  call s:plug_load('cmp-spell')
  call s:plug_load('cmp-look')
  call s:plug_load('cmp-skkeleton')
  call s:plug_load('lspkind.nvim')
  call s:plug_load('copilot.lua')
  call s:plug_load('copilot-cmp')

  call s:plug_load('vim-vsnip')
  call s:plug_load('vim-vsnip-integ')
  call s:plug_load('jam.nvim')
  call s:plug_load('vim-typo')
  call s:plug_load('nvim-insx')

  source ~/dotfiles/.config/nvim/plugin_config/vsnip.vim
  luafile ~/dotfiles/.config/nvim/plugin_config/cmp.lua

  source ~/dotfiles/.config/nvim/plugin_config/skkeleton.vim
  " let g:skk_ddc_alternative = 'cmp'
  " source ~/dotfiles/.config/nvim/plugin_config/skk_ddc_alt.vim

  luafile ~/dotfiles/.config/nvim/plugin_config/jam.lua
  luafile ~/dotfiles/.config/nvim/plugin_config/insx.lua

  doautocmd InsertEnter
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
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': ['markdown'] }
" }}}

" {{{ venn.nvim
Plug 'jbyuki/venn.nvim', { 'on': [] }
function! s:venn_toggle() abort
  if !get(g:, 'venn_loaded')
    call s:plug_load('venn.nvim')
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
" Plug 'anuvyklack/keymap-amend.nvim'
Plug 'echasnovski/mini.nvim'
Plug 'Shougo/context_filetype.vim'
Plug 'vim-jp/vimdoc-ja'
" }}}
call plug#end()

command! PlugSync PlugUpgrade | PlugClean! | PlugInstall --sync
      \ | call system('cd ' .. g:plugs['vimdoc-ja']['dir'] .. ' && git reset --hard') |  PlugUpdate
luafile ~/dotfiles/.config/nvim/plugin_config/mini.lua
" }}}

" {{{ user owned mappings
nnoremap <Plug>(rc-q-d) <Cmd>TroubleToggle<CR>
nnoremap <Plug>(rc-q-z) <Cmd>lua require('mini.misc').zoom()<CR>

cabbrev lup lua<space>=
" }}}
