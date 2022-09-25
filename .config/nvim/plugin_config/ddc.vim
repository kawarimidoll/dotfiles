let s:config_json = readfile('.config/nvim/plugin_config/ddc.json')
let s:config = json_decode(join(s:config_json, ''))
call ddc#custom#patch_global(s:config)

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

function! s:imap_amend_with_pum(key, amend, ...) abort
  let fallback = a:0 > 0 ? a:1 : a:key
  execute printf("inoremap <silent><expr> %s pum#visible()?'%s':'%s'", a:key, a:amend, fallback)
endfunction

call s:imap_amend_with_pum('<Tab>',   '<Cmd>call pum#map#insert_relative(+1)<CR>')
call s:imap_amend_with_pum('<S-Tab>', '<Cmd>call pum#map#insert_relative(-1)<CR>')
call s:imap_amend_with_pum('<C-n>',   '<Cmd>call pum#map#insert_relative(+1)<CR>', '<Down>')
call s:imap_amend_with_pum('<C-p>',   '<Cmd>call pum#map#insert_relative(-1)<CR>', '<Up>')
call s:imap_amend_with_pum('<C-y>',   '<Cmd>call pum#map#confirm()<CR>')
call s:imap_amend_with_pum('<C-e>',   '<Cmd>call pum#map#cancel()<CR>')
call s:imap_amend_with_pum('<CR>',    '<Cmd>call pum#map#confirm()<CR>')
