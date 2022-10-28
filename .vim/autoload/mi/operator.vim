" {{{ mi#operator#replace
function! mi#operator#replace(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#operator#replace')
    return 'g@'
  endif
  normal! `[v`]P
endfunction
" }}}

function! mi#operator#join(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#operator#join')
    return 'g@'
  endif
  normal! `[v`]J
endfunction
