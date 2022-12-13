" https://zenn.dev/kawarimidoll/articles/b723f9e93afa90
function! s:update_magic_query(query, pos) abort
  if a:query[:1] ==# '\v'
    " \v -> \V
    return ['\V' .. a:query[2:], a:pos]
  elseif a:query[:1] ==# '\V'
    " \V -> \v
    return ['\v' .. a:query[2:], a:pos]
  else
    " add \v
    return ['\v' .. a:query, a:pos + 2]
  endif
endfunction

function! mi#magic#expr() abort
  if getcmdtype() !~ '[/?]'
    return ''
  endif

  let [query, pos] = s:update_magic_query(getcmdline(), getcmdpos())
  call setcmdline(query, pos)

  " to update search, type space and remove it
  return " \<bs>"
endfunction
