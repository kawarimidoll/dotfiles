let s:surround_specs = {
      \ '(': { 'finder': ['(\s*', '\s*)'], 'wrapper': ['( ', ' )'] },
      \ ')': { 'finder': ['(', ')'], 'wrapper': ['(', ')'] },
      \ '[': { 'finder': ['\[\s*', '\s*]'], 'wrapper': ['[ ', ' ]'] },
      \ ']': { 'finder': ['\[', ']'], 'wrapper': ['[', ']'] },
      \ '{': { 'finder': ['{\s*', '\s*}'], 'wrapper': ['{ ', ' }'] },
      \ '}': { 'finder': ['{', '}'], 'wrapper': ['{', '}'] },
      \ '<': { 'finder': ['<\s*', '\s*>'], 'wrapper': ['< ', ' >'] },
      \ '>': { 'finder': ['<', '>'], 'wrapper': ['<', '>'] },
      \ 'b': { 'finder': ['(\s*', '\s*)'], 'wrapper': ['(', ')'] },
      \ 'r': { 'finder': ['\[\s*', '\s*]'], 'wrapper': ['[', ']'] },
      \ 'c': { 'finder': ['{\s*', '\s*}'], 'wrapper': ['{', '}'] },
      \ 'a': { 'finder': ['<\s*', '\s*>'], 'wrapper': ['<', '>'] },
      \ 'q': { 'finder': ['"', '"', '''', '''', '`', '`'], 'wrapper': ['''', ''''] },
      \ 'f': { 'finder': ['\k\+(\s*', '\s*)'], 'wrapper': ['function_name(', ')', 'function_name'] },
      \ 'F': { 'finder': ['\k\+(\s*', '\s*)'], 'wrapper': ['function_name( ', ' )', 'function_name'] },
      \ 't': { 'finder': ['<\w\+[^>]*\/\@<!>', '</\w\+>'], 'wrapper': ['<tag_name>', '</tag_name>', 'tag_name'] },
      \ }

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

function! s:get_wrapper() abort
  let cache = get(s:cache, 'add', [])
  if !empty(cache)
    return cache
  endif

  let char = nr2char(getchar())
  if char !~ '\p'
    return []
  endif

  if !has_key(s:surround_specs, char)
    let s:cache.add = [char, char]
    return s:cache.add
  endif

  let [open, close; replace_marks] = s:surround_specs[char]['wrapper']
  for replace_mark in replace_marks
    let user_input = input('[surround] input ' .. replace_mark .. ': ')
    if user_input !~ '\p'
      return []
    endif
    let open = substitute(open, replace_mark, user_input, '')
    let close = substitute(close, replace_mark, user_input, '')
  endfor

  let s:cache.add = [open, close]
  return s:cache.add
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

  let wrapper = s:get_wrapper()
  if empty(wrapper)
    return "\<esc>"
  endif
  let [open, close] = wrapper

  let tail = getpos("']")
  call s:putstr(tail[1], tail[2] + 1, close)

  let head = getpos("'[")
  call s:putstr(head[1], head[2], open)

  call cursor(tail[1], tail[2] + 1 + strchars(open))
endfunction
