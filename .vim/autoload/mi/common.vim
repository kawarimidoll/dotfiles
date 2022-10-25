function! mi#common#dot_repeat() abort
  try
    let g:mi#dot_repeating = 1
    normal! .
  finally
    unlet! g:mi#dot_repeating
  endtry
endfunction
