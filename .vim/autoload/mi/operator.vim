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
  if &filetype ==# 'vim'
    " remove line-continuation, ignore first line
    " silent! substitute/^\s*\\s*// <- simple, but includes first line
    let from = line("'[")
    let to = line("']")
    let range = from + 1
    if from != to
      let range ..= ',' .. to
    endif
    execute printf('silent! %ssubstitute/^\s*\\s*//', range)
    execute printf('keepjump normal! %sGV%sGJ', from, to)
    return
  endif
  normal! `[v`]J
endfunction
