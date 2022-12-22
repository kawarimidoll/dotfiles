let s:cache = {}
let s:surround_specs = {
      \ '(': { 'finder': ['(\s*', '\s*)'], 'wrapper': ['( ', ' )'] },
      \ ')': { 'finder': ['(', ')'], 'wrapper': ['(', ')'] },
      \ '[': { 'finder': ['\[\s*', '\s*]'], 'wrapper': ['[ ', ' ]'] },
      \ ']': { 'finder': ['\[', ']'], 'wrapper': ['[', ']'] },
      \ '{': { 'finder': ['{\s*', '\s*}'], 'wrapper': ['{ ', ' }'] },
      \ '}': { 'finder': ['{', '}'], 'wrapper': ['{', '}'] },
      \ '<': { 'finder': ['<\s*', '\s*>'], 'wrapper': ['< ', ' >'] },
      \ '>': { 'finder': ['<', '>'], 'wrapper': ['<', '>'] },
      \ 'b': { 'finder': ['(\s*', '\s*)', '\[\s*', '\s*]', '{\s*', '\s*}'], 'wrapper': ['(', ')'] },
      \ 'r': { 'finder': ['\[\s*', '\s*]'], 'wrapper': ['[', ']'] },
      \ 'c': { 'finder': ['{\s*', '\s*}'], 'wrapper': ['{', '}'] },
      \ 'a': { 'finder': ['<\s*', '\s*>'], 'wrapper': ['<', '>'] },
      \ 'q': { 'finder': ['"', '"', '''', '''', '`', '`'], 'wrapper': ['''', ''''] },
      \ 'f': { 'finder': ['\<\k\+(\s*', '\s*)'], 'wrapper': ['function_name(', ')', 'function_name'] },
      \ 'F': { 'finder': ['\<\k\+(\s*', '\s*)'], 'wrapper': ['$CURSOR(', ')'], 'after_wrap': 'startinsert' },
      \ 'g': { 'finder': ['\<\k\+<\s*', '\s*>'], 'wrapper': ['generics_name<', '>', 'generics_name'] },
      \ 'G': { 'finder': ['\<\k\+<\s*', '\s*>'], 'wrapper': ['$CURSOR<', '>'], 'after_wrap': 'startinsert' },
      \ 't': { 'finder': ['<\w\+[^>]*\/\@<!>', '</\w\+>'], 'wrapper': ['<tag_name>', '</tag_name>', 'tag_name'] },
      \ }

function! s:invert(obj) abort
  let result = {}
  for [key, val] in items(a:obj)
    let result[val] = key
  endfor
  return result
endfunction

function! s:removestr(from_pos, to_pos) abort
  let from_pos = a:from_pos
  let to_pos = a:to_pos
  if a:from_pos[0] > a:to_pos[0]
    let [from_pos, to_pos] = [to_pos, from_pos]
  endif
  let before = strpart(getline(from_pos[0]), 0, from_pos[1] - 1)
  let after = strpart(getline(to_pos[0]), to_pos[1])
  call setline(from_pos[0],  before .. after)
  if from_pos[0] < to_pos[0]
    call deletebufline(bufnr(), from_pos[0] + 1, to_pos[0])
  endif
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

  if has_key(s:surround_specs[char], 'after_wrap')
    let s:after_wrap = s:surround_specs[char]['after_wrap']
  endif

  let s:cache.add = [open, close]
  return s:cache.add
endfunction

function! s:get_finder() abort
  let cache = get(s:cache, 'find', [])
  if !empty(cache)
    return cache
  endif

  let char = nr2char(getchar())
  if char !~ '\p'
    return []
  endif

  if !has_key(s:surround_specs, char)
    let s:cache.find = [char, char]
  else
    let s:cache.find = s:surround_specs[char]['finder']
  endif

  return s:cache.find
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

  let [head_lnum, head_col] = getpos("'[")[1:2]
  let [tail_lnum, tail_col] = getpos("']")[1:2]

  let c_lnum = head_lnum
  let c_col = head_col

  " cursor set on start of close wrapper by default
  " cursor position can be specified by $CURSOR
  let CURSOR_MARK = '$CURSOR'
  let cursor_in_wrapper = stridx(open, CURSOR_MARK)
  if cursor_in_wrapper < 0
    let c_lnum = tail_lnum
    let c_col = tail_col + 1 + strchars(open)
    let cursor_in_wrapper = stridx(close, CURSOR_MARK)
  endif
  let open = substitute(open, CURSOR_MARK, '', '')
  let close = substitute(close, CURSOR_MARK, '', '')
  let c_col += max([cursor_in_wrapper, 0])

  call s:putstr(tail_lnum, tail_col + 1, close)
  call s:putstr(head_lnum, head_col, open)

  call setcursorcharpos(c_lnum, c_col)

  if exists('s:after_wrap')
    execute s:after_wrap
    unlet! s:after_wrap
  endif
endfunction

function! mi#surround#find_pair() abort
  " debug
  " let s:cache.find = []

  let result = []
  let finder = s:get_finder()
  while v:true
    if empty(finder)
      break
    endif

    let open = finder[0]
    let close = finder[1]
    let finder = finder[2:]

    if open ==# close
      let open_from = searchpos(open, 'nbW', line('w0'))
      let close_from = searchpos(close, 'nW', line('w$'))
    else
      let open_from = searchpairpos(open, '', close, 'nbW', '', line('w0'))
      let close_from = searchpairpos(open, '', close, 'nW', '', line('w$'))
    endif

    if open_from == [0, 0] || close_from == [0, 0]
      continue
    endif

    " use cursor() and searchpos() because searchpairpos() doesn't have 'e' flag
    let cursorpos = getpos('.')[1:2]
    call cursor(open_from[0], open_from[1])
    let open_to = searchpos(open, 'ceW', line('w$'))
    call cursor(close_from[0], close_from[1])
    let close_to = searchpos(close, 'ceW', line('w$'))
    call cursor(cursorpos[0], cursorpos[1])

    " choose the last open_to
    if empty(result) || (result[1][0] <= open_to[0] && result[1][1] < open_to[1])
      let result = [open_from, open_to, close_from, close_to]
    endif
  endwhile

  return result
endfunction

function! mi#surround#delete(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#surround#delete')
    return 'g@'
  endif

  let find_pair = mi#surround#find_pair()
  if empty(find_pair)
    return "\<esc>"
  endif
  echo find_pair

  let [open_from, open_to, close_from, close_to] = find_pair
  call s:removestr(close_from, close_to)
  call s:removestr(open_from, open_to)

  call cursor(open_from[0], open_from[1])
endfunction

function! mi#surround#replace(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#surround#replace')
    return 'g@'
  endif

  let find_pair = mi#surround#find_pair()
  if empty(find_pair)
    return "\<esc>"
  endif

  let wrapper = s:get_wrapper()
  if empty(wrapper)
    return "\<esc>"
  endif

  let [open_from, open_to, close_from, close_to] = find_pair
  call s:removestr(close_from, close_to)
  call s:putstr(close_from[0], close_from[1], wrapper[1])
  call s:removestr(open_from, open_to)
  call s:putstr(open_from[0], open_from[1], wrapper[0])

  " TODO set cursor on new close pos
  call cursor(open_from[0], open_from[1])
endfunction
