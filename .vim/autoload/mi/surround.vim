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

  let pair = get(s:cache, 'add', [])
  if empty(pair)
    let char = nr2char(getchar())
    let fname = ''

    if char !~ '\p'
      return "\<esc>"
    elseif char ==? 'f'
      let fname = input('function name: ')
      if fname !~ '\p'
        return "\<esc>"
      endif
      let char = char ==# 'F' ? '(' : ')'
    endif

    let open = fname .. get(s:invert(s:pairs), char, char)
    let close = get(s:pairs, char, char)

    if has_key(s:pairs, char)
      " wrap with blank by open-bracket
      let open = open .. ' '
      let close = ' ' .. close
    endif

    let s:cache.add = [open, close]
  else
    let [open, close] = pair
  endif

  let tail = getpos("']")
  call s:putstr(tail[1], tail[2] + 1, close)

  let head = getpos("'[")
  call s:putstr(head[1], head[2], open)

  call cursor(tail[1], tail[2] + 1 + strchars(open))
endfunction
