let s:snake = {'pattern': '\v^[a-z][a-z0-9]*(_[a-z0-9]+)*$'}
function! s:snake.split(str) abort
  return split(a:str, '_')
endfunction
function! s:snake.join(words) abort
  return join(a:words, '_')
endfunction

let s:kebab = {'pattern': '\v^[a-z][a-z0-9]*(-[a-z0-9]+)+$'}
function! s:kebab.split(str) abort
  return split(a:str, '-')
endfunction
function! s:kebab.join(words) abort
  return join(a:words, '-')
endfunction

let s:scream = {'pattern': '\v^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$'}
function! s:scream.split(str) abort
  return s:snake.split(tolower(a:str))
endfunction
function! s:scream.join(words) abort
  return toupper(join(a:words, '_'))
endfunction

let s:camel = {'pattern': '\v^[a-z][a-z0-9]*([A-Z]+[a-z0-9]+)+$'}
function! s:camel.split(str) abort
  return s:snake.split(substitute(a:str, '\v\u', '_\l\0', 'g'))
endfunction
function! s:camel.join(words) abort
  return join([a:words[0], s:pascal.join(a:words[1:])], '')
endfunction

let s:pascal = {'pattern': '\v^([A-Z]+[a-z0-9]+)+$'}
function! s:pascal.split(str) abort
  return s:camel.split(tolower(a:str[0]) .. a:str[1:])
endfunction
function! s:pascal.join(words) abort
  return join(map(copy(a:words),{_,w -> toupper(w[0]) .. w[1:]}), '')
endfunction

function! s:dial(cnt, sign) abort
  let cases = [s:pascal, s:camel, s:kebab, s:snake, s:scream]
  let pos = getpos('.')
  let col = pos[2]
  let line = getline('.')

  let pre_cursor  = matchstr(line[:col-1], '\v[-_[:alnum:]]+$')
  let post_cursor = matchstr(line[col:], '\v^[-_[:alnum:]]+')
  let word = pre_cursor .. post_cursor

  let idx = 0
  for case_obj in cases
    if word !~# case_obj.pattern
      let idx += 1
      continue
    endif

    let words = case_obj.split(word)
    let lnum = pos[1]

    let replacement = cases[(idx + a:cnt * a:sign) % len(cases)].join(words)
    let pre_match_idx = col-1-len(pre_cursor)
    let pre_match = pre_match_idx >= 0 ? line[:pre_match_idx] : ''
    let post_match = line[col+len(post_cursor):]
    call setline(lnum, pre_match .. replacement .. post_match)

    return
  endfor

  if a:sign > 0
    execute 'normal!' a:cnt .. "\<C-a>"
  else
    execute 'normal!' a:cnt .. "\<C-x>"
  endif
endfunction

function! mi#dial#increment(cnt) abort
  call s:dial(a:cnt, 1)
endfunction
function! mi#dial#decrement(cnt) abort
  call s:dial(a:cnt, -1)
endfunction
