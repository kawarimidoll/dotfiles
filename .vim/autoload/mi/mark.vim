" http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908
function! mi#mark#auto_set() abort
  if !exists('b:last_mark')
    let b:last_mark = -1
  endif
  let b:last_mark = (b:last_mark + 1) % len(g:mi#const#alpha_lower)
  execute 'mark' g:mi#const#alpha_lower[b:last_mark]
endfunction

function! mi#mark#jump_to_last() abort
  if !exists('b:last_mark')
    return
  endif
  execute 'normal! g`' .. g:mi#const#alpha_lower[b:last_mark]
endfunction
