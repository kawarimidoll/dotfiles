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

function! s:not_fit_indent() abort
  return !!((col('.') - 1) % shiftwidth())
endfunction

function! s:not_on_tab() abort
  return getline('.')[col('.')-1] != "\t"
endfunction

function! mi#hjkl#h(cnt = 1) abort
  if a:cnt > 1 || !&expandtab
    execute printf('normal! %sh', a:cnt)
    return
  endif
  normal! h
  while s:in_indent() && s:not_fit_indent()
        \ && s:not_on_tab()
    normal! h
  endwhile
endfunction

function! mi#hjkl#l(cnt = 1) abort
  if a:cnt > 1 || !&expandtab
    execute printf('normal! %sl', a:cnt)
    return
  endif
  normal! l
  let lastcol = col('$') - 1
  while s:in_indent() && s:not_fit_indent()
        \ && col('.') != lastcol && s:not_on_tab()
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
