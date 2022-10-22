" {{{ mi#operator#replace
function! mi#operator#replace(type = '') abort
  if a:type == ''
    let &operatorfunc = function('mi#operator#replace')
    return 'g@'
  endif
  normal! `[v`]P
endfunction
" }}}
