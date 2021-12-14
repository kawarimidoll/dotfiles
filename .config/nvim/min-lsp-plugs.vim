if filereadable(expand('~/dotfiles/.config/nvim/min-edit.vim'))
  source ~/dotfiles/.config/nvim/min-edit.vim
endif

"-----------------
" Plugs
"-----------------
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
Plug 'tani/ddc-fuzzy'
Plug 'gamoutatsumi/ddc-sorter_ascii'

Plug 'matsui54/denops-popup-preview.vim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
call plug#end()

call ddc#custom#patch_global('sources', ['nvim-lsp', 'vsnip', 'around'])
call ddc#custom#patch_global('completionMenu', 'pum.vim')
" call ddc#custom#patch_global('filterParams', #{
"   \   matcher_fuzzy: #{splitMode: 'word',}
"   \ })
let s:source_common_option = #{
  \  smartCase: v:true,
  \  matchers:   ['matcher_fuzzy'],
  \  sorters:    ['sorter_fuzzy'],
  \  converters: ['converter_fuzzy']
  \ }
call ddc#custom#patch_global('sourceOptions', #{
  \   _: s:source_common_option,
  \   around: #{
  \     mark: 'A',
  \     isVolatile: v:true,
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
call ddc#custom#patch_global('sourceParams', #{
  \ nvim-lsp: #{ maxSize: 500 },
  \ })
" call ddc#custom#patch_filetype(
"   \ ['typescript'], 'sources', ['nvim-lsp', 'around']
"   \ )
call ddc#enable()

" <TAB>/<S-TAB> completion.
" inoremap <silent><expr> <TAB>
"   \ pumvisible() ? '<C-n>' :
"   \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
"   \ '<TAB>' : ddc#map#manual_complete()
" inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

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
  buf_set_keymap('n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
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
lsp_installer.on_server_ready(function(server)
  local opts = {}
  opts.on_attach = on_attach
  opts.capabilities = capabilities

  if server.name == 'tsserver' or server.name == 'eslint' then
    opts.root_dir = nvim_lsp.util.root_pattern("package.json", "node_modules")
  elseif server.name == 'denols' then
    opts.root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc", "deps.ts")
    opts.init_options = { lint = true, unstable = true, }
  end

  server:setup(opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)

require("lsp_signature").setup()
EOF

call popup_preview#enable()

set number
