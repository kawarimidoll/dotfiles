let s:prop_type = 'searchprop'
call prop_type_delete(s:prop_type, {})
call prop_type_add(s:prop_type, {'highlight': 'Search'})

function! s:format_search_spec(spec) abort
  if a:spec.incomplete ==# 1
    " timeout
    return '[?/??]'
  elseif a:spec.incomplete ==# 2
    " over limit
    if a:spec.total > a:spec.maxcount && a:spec.current > a:spec.maxcount
      return printf('[>%d/>%d]', a:spec.current, a:spec.total)
    elseif a:spec.total > a:spec.maxcount
      return printf('[%d/>%d]', a:spec.current, a:spec.total)
    endif
  endif

  return printf('[%d/%d]', a:spec.current, a:spec.total)
endfunction

function! s:remove_searchprop() abort
  if exists('s:searchprop_enabled')
    call prop_remove({'type': s:prop_type, 'all': v:true})
    unlet! s:searchprop_enabled
  endif
endfunction

function! s:update_searchprop(timer) abort
  if a:timer !=# s:searchprop_timer
    return
  endif

  call s:remove_searchprop()

  if !v:hlsearch
    return
  endif

  try
    let search_spec = searchcount({'recompute': 1, 'maxcount': 0, 'timeout': 100})
  catch /^Vim\%((\a\+)\)\=:E866:/
    return
  endtry

  if empty(search_spec) || !search_spec.exact_match
    return
  endif

  call prop_add(line('.'), 0, {
        \ 'type': s:prop_type,
        \ 'text': s:format_search_spec(search_spec),
        \ 'text_align': 'after',
        \ 'text_padding_left': 2
        \ })
  let s:searchprop_enabled = 1

  augroup mi#augroup#searchprop_hold
    autocmd!
    autocmd CursorHold * ++once call s:debounce_searchprop()
  augroup END
endfunction

function! s:debounce_searchprop() abort
  let s:searchprop_timer = timer_start(150, function('s:update_searchprop'))
endfunction

augroup mi#augroup#searchprop
  autocmd!
  autocmd CursorMoved * call s:debounce_searchprop()
  autocmd ModeChanged *:n call s:debounce_searchprop()
  autocmd ModeChanged n:* call s:remove_searchprop()
  autocmd BufLeave,WinLeave * call s:remove_searchprop()
augroup END
