function! s:ddc_init() abort
  call ddc#enable()
  call ddc#custom#patch_global(#{
        \   sources: ['skkeleton'],
        \   sourceOptions: #{ skkeleton: #{ matchers: ['skkeleton'] } },
        \   autoCompleteEvents: [],
        \   completionMode: 'manual',
        \ })
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
