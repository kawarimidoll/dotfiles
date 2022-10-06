let s:config_json =<< trim JSON
{
  "sources": ["skkeleton"],
  "sourceOptions": {
    "skkeleton": {
      "matchers": ["skkeleton"],
      "sorters": [],
      "isVolatile": true,
      "backspaceCompletion": true
    }
  },
  "autoCompleteEvents": [],
  "completionMode": "manual"
}
JSON

let s:config = json_decode(join(s:config_json, ''))
function! s:ddc_init() abort
  call ddc#custom#patch_global(s:config)
  call ddc#enable()
endfunction

function! s:skkeleton_enable() abort
  call ddc#custom#patch_buffer(#{
        \   autoCompleteEvents: ['InsertEnter', 'TextChangedI', 'TextChangedP'],
        \   completionMode: 'popupmenu'
        \ })
  lua require('cmp').setup.buffer({ enabled = false })

  autocmd User skkeleton-disable-pre ++once
        \ call ddc#custom#patch_buffer(#{ autoCompleteEvents: [], completionMode: 'manual' }) |
        \ lua require('cmp').setup.buffer({ enabled = true })
endfunction

augroup skkeleton_ddc_cmp
  autocmd!
  autocmd User skkeleton-enable-pre call <SID>skkeleton_enable()
  autocmd User skkeleton-initialize-pre ++once call <SID>ddc_init()
augroup END
