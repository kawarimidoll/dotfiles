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
  let g:minicompletion_disable = v:true

  autocmd User skkeleton-disable-pre ++once
        \ call ddc#custom#patch_buffer(#{ autoCompleteEvents: [], completionMode: 'manual' }) |
        \ let g:minicompletion_disable = v:false
endfunction

augroup skkeleton_ddc_mini
  autocmd!
  autocmd User skkeleton-enable-pre call <SID>skkeleton_enable()
  autocmd User skkeleton-initialize-pre ++once call <SID>ddc_init()
augroup END
