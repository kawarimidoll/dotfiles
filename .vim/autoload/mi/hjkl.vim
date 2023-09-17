function! s:is_skippable_line() abort
  let lnum = line('.')
  return lnum > 1 && lnum < line('$') && getline(lnum) =~# '^\s*$'
endfunction

function! s:in_indent() abort
  return col('.') <= indent('.')
endfunction

function! s:indent_level(col) abort
  return (a:col - 1) / shiftwidth()
endfunction

function! s:fit_indent() abort
  return !!((col('.') - 1) % shiftwidth())
endfunction

function! mi#hjkl#h(cnt = 1) abort
  if a:cnt > 1
    execute printf('normal! %sh', a:cnt)
    return
  endif
  normal! h
  while s:in_indent() && s:fit_indent()
    normal! h
  endwhile
endfunction

function! mi#hjkl#l(cnt = 1) abort
  if a:cnt > 1
    execute printf('normal! %sl', a:cnt)
    return
  endif
  normal! l
  while s:in_indent() && s:fit_indent()
    normal! l
  endwhile
endfunction

function! mi#hjkl#j(cnt = 1, skip_indent = v:false) abort
  if a:cnt > 1
    execute printf('normal! %sj', a:cnt)
    return
  endif
  normal! j
  while (a:skip_indent && s:in_indent()) || s:is_skippable_line()
    normal! j
  endwhile
endfunction

function! mi#hjkl#k(cnt = 1, skip_indent = v:false) abort
  if a:cnt > 1
    execute printf('normal! %sk', a:cnt)
    return
  endif
  normal! k
  while (a:skip_indent && s:in_indent()) || s:is_skippable_line()
    normal! k
  endwhile
endfunction
