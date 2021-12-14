if filereadable(expand('~/dotfiles/.config/nvim/min-edit.vim'))
  source ~/dotfiles/.config/nvim/min-edit.vim
endif

set number

"-----------------
" Plugs
"-----------------
" [Tips should also describe automatic installation for Neovim|junegunn/vim-plug](https://github.com/junegunn/vim-plug/issues/739)
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  if !executable('curl')
    echoerr 'You have to install curl.'
    execute 'quit!'
  endif
  silent execute '!curl -fL --create-dirs -o ' . autoload_plug_path .
      \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
else
  " [おい、NeoBundle もいいけど vim-plug 使えよ](https://qiita.com/b4b4r07/items/fa9c8cceb321edea5da0)
  function! s:AutoPlugInstall() abort
    let list = get(g:, 'plugs', {})->items()->copy()
        \  ->filter({_,item->!isdirectory(item[1].dir)})
        \  ->map({_,item->item[0]})
    if empty(list)
      return
    endif
    echo 'Not installed plugs: ' . string(list)
    if confirm('Install plugs?', "yes\nno", 2) == 1
      PlugInstall --sync | close
    endif
  endfunction
  augroup vimrc_plug
    autocmd!
    autocmd VimEnter * call s:AutoPlugInstall()
  augroup END
endif
unlet autoload_plug_path

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
Plug 'matsui54/ddc-converter_truncate'
Plug 'matsui54/ddc-buffer'
Plug 'matsui54/ddc-dictionary'
Plug 'LumaKernel/ddc-file'
Plug 'tani/ddc-fuzzy'
Plug 'gamoutatsumi/ddc-sorter_ascii'
Plug 'vim-skk/denops-skkeleton.vim'
Plug 'delphinus/skkeleton_indicator.nvim'

Plug 'matsui54/denops-popup-preview.vim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
call plug#end()

let s:dictPath = '~/.cache/nvim/google-10000-english-no-swears.txt'
if !filereadable(expand(s:dictPath))
  echo "10k words dictionary does not exists! '" . s:dictPath . "' is required!"
  let l:dictDir = fnamemodify(s:dictPath, ':h')
  let l:cmds = [
    \   "curl -OL https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt",
    \   "mkdir -p " . l:dictDir,
    \   "mv ./google-10000-english-no-swears.txt " . l:dictDir,
    \ ]
  echo "To get dictionary, run:\n" . l:cmds->join("\n") . "\n"

  if confirm("Run automatically?", "y\nN") == 1
    echo "Running..."
    call system(l:cmds->join(" && "))
    echo "Done."
  endif
endif

call ddc#custom#patch_global('sources', ['nvim-lsp', 'skkeleton', 'vsnip', 'buffer', 'file', 'dictionary', 'around'])
call ddc#custom#patch_global('completionMenu', 'pum.vim')

let s:source_common_option = #{
  \   smartCase: v:true,
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
  \   nvim-lsp: #{
  \     mark: 'lsp',
  \     forceCompletionPattern: '\.\w*|:\w*|->\w*',
  \   },
  \ })
call ddc#custom#patch_global('filterParams', #{
  \   converter_truncate: #{ maxAbbrWidth: 60, maxInfo: 500, ellipsis: '...' },
  \   converter_fuzzy: #{ hlGroup: 'Title' },
  \ })
call ddc#custom#patch_global('specialBufferCompletion', v:true)
" 10k words dictionary:
" https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english-no-swears.txt
call ddc#custom#patch_global('sourceParams', #{
  \   around: #{ maxSize: 500 },
  \   buffer: #{ forceCollect: v:true, fromAltBuf: v:true, showBufName: v:true },
  \   dictionary: #{
  \     showMenu: v:false,
  \     dictPaths: [expand(s:dictPath)],
  \   },
  \   nvim-lsp: #{ maxSize: 500 },
  \ })
call ddc#enable()
call popup_preview#enable()

imap <expr> <C-l> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-l>'
imap <silent><expr> <TAB>   pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : vsnip#jumpable(+1) ? '<Plug>(vsnip-jump-next)' : '<TAB>'
imap <silent><expr> <S-TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-TAB>'
imap <silent><expr> <C-n>   (pum#visible() ? '' : '<Cmd>call ddc#map#manual_complete()<CR>') . '<Cmd>call pum#map#select_relative(+1)<CR>'
imap <silent><expr> <C-p>   (pum#visible() ? '' : '<Cmd>call ddc#map#manual_complete()<CR>') . '<Cmd>call pum#map#select_relative(-1)<CR>'
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>
autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)

cnoremap <expr> <TAB>   pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : ddc#map#manual_complete()
cnoremap <expr> <S-TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : ddc#map#manual_complete()
cnoremap <expr> <C-n>   pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<C-n>'
cnoremap <expr> <C-p>   pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<C-p>'
cnoremap <expr> <CR>    pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
" cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
" cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
nnoremap :       <Cmd>call CommandlinePre()<CR>:

function! CommandlinePre() abort
  " Overwrite sources
  let s:prev_buffer_config = ddc#custom#get_buffer()
  call ddc#custom#patch_buffer('sources', ['cmdline'])
  " call ddc#custom#patch_buffer('sources', ['necovim', 'cmdline', 'cmdline-history'])
  call ddc#custom#patch_buffer('autoCompleteEvents', ['CmdlineChanged'])
  call ddc#custom#patch_buffer('sourceOptions', #{
    \   _: s:source_common_option,
    \   cmdline: #{ mark: 'cmd' },
    \ })
    " \   necovim: #{ mark: 'neco' },
    " \   cmdline-history: #{ mark: 'hist' },

  autocmd User DDCCmdlineLeave ++once call CommandlinePost()

  " Enable command line completion
  call ddc#enable_cmdline_completion()
endfunction
function! CommandlinePost() abort
  " Restore sources
  call ddc#custom#set_buffer(s:prev_buffer_config)
endfunction

nnoremap <expr> K '<Cmd>' . (['vim','help']->index(&filetype) >= 0 ? 'help ' . expand('<cword>') : 'lua vim.lsp.buf.hover()') . '<CR>'

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
autocmd User skkeleton-initialize-pre call s:skkeleton_init()

lua << EOF
-- ほぼREADMEそのまま
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD',        '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd',        '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e',  '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[g',        '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g',        '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'sl',        '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>p',  '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

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
function detected_root_dir(root_dir)
  return not(not(root_dir(vim.api.nvim_buf_get_name(0), vim.api.nvim_get_current_buf())))
end
lsp_installer.on_server_ready(function(server)
  local opts = {}
  opts.on_attach = on_attach
  opts.capabilities = capabilities

  -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs.lua
  if server.name == 'tsserver' or server.name == 'eslint' then
    local root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
    opts.root_dir = root_dir
    opts.autostart = detected_root_dir(root_dir)
  elseif server.name == 'denols' then
    local root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
    opts.root_dir = root_dir
    opts.autostart = detected_root_dir(root_dir)
    opts.init_options = { lint = true, unstable = true, }
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

require("lsp_signature").setup()

require('skkeleton_indicator').setup({
  alwaysShown = false,
  fadeOutMs = 30000,
})
EOF
