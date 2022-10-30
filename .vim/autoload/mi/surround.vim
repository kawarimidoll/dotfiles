let s:pairs = {'{': '}', '[': ']', '(': ')'}

function! s:invert(obj) abort
  let result = {}
  for [key, val] in items(a:obj)
    let result[val] = key
  endfor
  return result
endfunction

function! s:putstr(lnum, col, str) abort
  let line = getline(a:lnum)
  call setline(a:lnum, strpart(line, 0, a:col - 1) .. a:str .. strpart(line, a:col - 1))
endfunction

function! mi#surround#operator(task) abort
  let s:cache = {}
  execute "set operatorfunc=function('mi#surround#" .. a:task .. "')"
  return 'g@'
endfunction

function! mi#surround#add(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#surround#add')
    return 'g@'
  endif

  let char = get(s:cache, 'add', '')
  if char == ''
    let char = nr2char(getchar())
    if char !~ '\p'
      return "\<esc>"
    endif
    let s:cache.add = char
  endif

  let tail = getpos("']")
  call s:putstr(tail[1], tail[2] + 1, get(s:pairs, char, char))

  let head = getpos("'[")
  call s:putstr(head[1], head[2], get(s:invert(s:pairs), char, char))
endfunction
