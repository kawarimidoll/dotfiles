call ddc#custom#patch_global('completionMenu', 'pum.vim')
call ddc#custom#patch_global('autoCompleteEvents',
    \ ['InsertEnter', 'TextChangedI', 'TextChangedP', 'CmdlineChanged'])
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
  \   'forceCompletionPattern': '\S/\S*',
  \   'ignoreCase': v:true,
  \   'matchers': ['matcher_fuzzy'],
  \   'sorters': ['sorter_fuzzy'],
  \   'converters': ['converter_fuzzy']
  \ },
  \ 'around': {'mark': 'A'},
  \ 'cmdline': {
  \   'mark': 'CMD',
  \   'forceCompletionPattern': '\S/\S*',
  \   'ignoreCase': v:true,
  \   'matchers': ['matcher_fuzzy'],
  \   'sorters': ['sorter_fuzzy'],
  \   'converters': ['converter_fuzzy']
  \ },
  \ 'cmdline-history': {
  \   'mark': 'H',
  \   'ignoreCase': v:true,
  \   'sorters': [],
  \ },
  \ })

" nnoremap : <Cmd>call <sid>ddc_commandline_pre()<CR>:

" function! s:ddc_commandline_pre() abort
"   " Overwrite sources
"   if !exists('b:prev_buffer_config')
"     let b:prev_buffer_config = ddc#custom#get_buffer()
"   endif
"   call ddc#custom#patch_buffer('cmdlineSources', ['cmdline', 'cmdline-history', 'around', 'file', 'look'])
"
"   autocmd User DDCCmdlineLeave ++once call <sid>ddc_commandline_post()
"   autocmd InsertEnter <buffer> ++once call <sid>ddc_commandline_post()
"
"   " Enable command line completion
"   call ddc#enable_cmdline_completion()
" endfunction
" function! s:ddc_commandline_post() abort
"   " Restore sources
"   if exists('b:prev_buffer_config')
"     call ddc#custom#set_buffer(b:prev_buffer_config)
"     unlet b:prev_buffer_config
"   else
"     call ddc#custom#set_buffer({})
"   endif
" endfunction

call ddc#enable()
call signature_help#enable()
call popup_preview#enable()

Keymap i <silent><expr> <Tab>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<Tab>'
Keymap i <silent><expr> <S-Tab>
      \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<S-Tab>'
" Keymap i <silent><expr> <C-n>
"       \ pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : '<Down>'
" Keymap i <silent><expr> <C-p>
"       \ pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : '<Up>'
Keymap i <silent><expr> <C-y>
      \ pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<C-y>'
Keymap i <silent><expr> <C-e>
      \ pum#visible() ? '<Cmd>call pum#map#cancel()<CR>'  : '<C-e>'
Keymap i <silent><expr> <CR>
      \ pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'
