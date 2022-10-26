function! mi#common#dot_repeat() abort
  try
    let g:mi#dot_repeating = 1
    normal! .
  finally
    unlet! g:mi#dot_repeating
  endtry
endfunction

function! mi#common#trim(ignore = {}) abort
  if !has_key(a:ignore, 'trailing_white_spaces')
    silent! %s/\s\+$//
  endif
  if !has_key(a:ignore, 'multiple_blank_line')
    silent! %s/^\n\zs\n\+//
  endif
  if !has_key(a:ignore, 'blank_line_eof')
    silent! %s/\n\+\%$//
  endif
endfunction
