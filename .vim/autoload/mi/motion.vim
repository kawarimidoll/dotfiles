" inspired by :h getchar()

function! s:motion_right() abort
  if !exists('s:last_find')
    return
  endif
  let c = s:last_find.char

  let line = getline('.')
  let [lnum, col] = getpos('.')[1:2]

  let off = 0
  if s:last_find.till
    let off = 1
  endif

  let idx = stridx(line, c, col + off) + 1

  if s:last_find.smart && c ==# mi#utils#lower_key(c)
    let idx_u = stridx(line, mi#utils#upper_key(c), col + off) + 1
    if idx < 1 || (1 < idx_u && idx_u < idx)
      let idx = idx_u
    endif
  endif

  if idx > 0
    let off = 0
    if mode(1) =~ 'o'
      let off += 1
    endif
    if s:last_find.till
      let off -= 1
    endif
    call cursor(lnum, idx + off)
  endif
endfunction

function! s:motion_left() abort
  if !exists('s:last_find')
    return
  endif
  let c = s:last_find.char

  let line = getline('.')
  let [lnum, col] = getpos('.')[1:2]

  let off = -2
  if s:last_find.till
    let off = -3
  endif

  let idx = strridx(line, c, col + off) + 1

  if s:last_find.smart && c ==# mi#utils#lower_key(c)
    let idx = max([idx, strridx(line, mi#utils#upper_key(c), col + off) + 1])
  endif

  if idx > 0
    let off = 0
    if s:last_find.till
      let off += 1
    endif
    call cursor(lnum, idx + off)
  endif
endfunction

function! s:motion_start(starter, smart) abort
  if stridx('fFtT', a:starter) < 0
    return
  endif

  if !exists('g:mi#dot_repeating')
    let c = nr2char(getchar())
    if c !~ '\p'
      return
    endif

    let right = a:starter ==# 'f' || a:starter ==# 't'
    let till = a:starter ==? 't'
    let s:last_find = {'right': right, 'char': c, 'till': till, 'smart': a:smart}
  endif
  call mi#motion#repeat(';')
endfunction

function! mi#motion#original(starter) abort
  call s:motion_start(a:starter, 0)
endfunction

function! mi#motion#smart(starter) abort
  call s:motion_start(a:starter, 1)
endfunction

function! mi#motion#repeat(starter) abort
  if stridx(';,', a:starter) < 0
    return
  endif
  if exists('s:last_find')
    if (s:last_find.right && a:starter == ';') ||
          \ (!s:last_find.right && a:starter == ',')
      call s:motion_right()
    else
      call s:motion_left()
    endif
  else
    execute 'normal!' a:starter
  endif
endfunction
