function! s:is_skippable_line() abort
  let lnum = line('.')
  return lnum > 1 && lnum < line('$') && getline(lnum) =~# '^\s*$'
endfunction

function! mi#hjkl#j(cnt = 1) abort
  if a:cnt > 1
    execute printf('normal! %sj', a:cnt)
    return
  endif
  normal! j
  while s:is_skippable_line()
    normal! j
  endwhile
endfunction

function! mi#hjkl#k(cnt = 1) abort
  if a:cnt > 1
    execute printf('normal! %sk', a:cnt)
    return
  endif
  normal! k
  while s:is_skippable_line()
    normal! k
  endwhile
endfunction
