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

if !exists('g:skk_ddc_alternative')
  echoerr 'g:skk_ddc_alternative is required'
endif

function! s:skkeleton_enable() abort
  call ddc#custom#patch_buffer({
        \   'autoCompleteEvents': ['InsertEnter', 'TextChangedI', 'TextChangedP'],
        \   'completionMode': 'popupmenu'
        \ })
  let s:ddc_disable_dict = { 'autoCompleteEvents': [], 'completionMode': 'manual' }

  if g:skk_ddc_alternative == 'cmp'
    lua require('cmp').setup.buffer({ enabled = false })
    autocmd User skkeleton-disable-pre ++once
          \ call ddc#custom#patch_buffer(s:ddc_disable_dict) |
          \ lua require('cmp').setup.buffer({ enabled = true })
  elseif g:skk_ddc_alternative == 'mini'
    let g:minicompletion_disable = v:true
    autocmd User skkeleton-disable-pre ++once
          \ call ddc#custom#patch_buffer(s:ddc_disable_dict) |
          \ let g:minicompletion_disable = v:false
  endif
endfunction

augroup skk_ddc_alt
  autocmd!
  autocmd User skkeleton-enable-pre call <SID>skkeleton_enable()
  autocmd User skkeleton-initialize-pre ++once call <SID>ddc_init()
augroup END
