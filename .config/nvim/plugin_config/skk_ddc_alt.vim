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
  "completionMenu": "pum.vim",
  "completionMode": "manual"
}
JSON

let s:config = json_decode(join(s:config_json, ''))
function! s:ddc_init() abort
  call ddc#custom#patch_global('ui', 'pum')
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

  inoremap <buffer> <Tab> <Cmd>call pum#map#insert_relative(+1)<CR>
  inoremap <buffer> <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
  inoremap <buffer> <C-n> <Cmd>call pum#map#insert_relative(+1)<CR>
  inoremap <buffer> <C-p> <Cmd>call pum#map#insert_relative(-1)<CR>
  inoremap <buffer> <C-y> <Cmd>call pum#map#confirm()<CR>
  inoremap <buffer> <C-e> <Cmd>call pum#map#cancel()<CR>
  inoremap <buffer> <CR> <Cmd>call pum#map#confirm()<CR>

  if g:skk_ddc_alternative == 'cmp'
    lua require('cmp').setup.buffer({ enabled = false })
  elseif g:skk_ddc_alternative == 'mini'
    let g:minicompletion_disable = v:true
  endif
endfunction

function! s:skkeleton_disable() abort
  call ddc#custom#patch_buffer({'autoCompleteEvents': [], 'completionMode': 'manual'})

  iunmap <buffer> <Tab>
  iunmap <buffer> <S-Tab>
  iunmap <buffer> <C-n>
  iunmap <buffer> <C-p>
  iunmap <buffer> <C-y>
  iunmap <buffer> <C-e>
  iunmap <buffer> <CR>

  if g:skk_ddc_alternative == 'cmp'
    lua require('cmp').setup.buffer({ enabled = true })
  elseif g:skk_ddc_alternative == 'mini'
    let g:minicompletion_disable = v:false
  endif
endfunction

augroup skk_ddc_alt
  autocmd!
  autocmd User skkeleton-enable-pre call <SID>skkeleton_enable()
  autocmd User skkeleton-disable-pre call <SID>skkeleton_disable()
  autocmd User skkeleton-initialize-pre ++once call <SID>ddc_init()
augroup END
