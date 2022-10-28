" inspired by :h getchar()
" TODO: use setcharsearch() / getcharsearch()

function! s:ft_forward() abort
  if !exists('s:last_find')
    return
  endif
  let c = s:last_find.char

  let line = getline('.')
  let [lnum, col] = getpos('.')[1:2]

  let off = 0
  if s:last_find.until
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
    if s:last_find.until
      let off -= 1
    endif
    call cursor(lnum, idx + off)
  endif
endfunction

function! s:ft_backward() abort
  if !exists('s:last_find')
    return
  endif
  let c = s:last_find.char

  let line = getline('.')
  let [lnum, col] = getpos('.')[1:2]

  let off = -2
  if s:last_find.until
    let off = -3
  endif

  let idx = strridx(line, c, col + off) + 1

  if s:last_find.smart && c ==# mi#utils#lower_key(c)
    let idx = max([idx, strridx(line, mi#utils#upper_key(c), col + off) + 1])
  endif

  if idx > 0
    let off = 0
    if s:last_find.until
      let off += 1
    endif
    call cursor(lnum, idx + off)
  endif
endfunction

function! s:ft_start(starter, smart) abort
  if stridx('fFtT', a:starter) < 0
    return
  endif

  if !exists('g:mi#dot_repeating')
    let c = nr2char(getchar())
    if c !~ '\p'
      return
    endif

    let forward = a:starter ==# 'f' || a:starter ==# 't'
    let until = a:starter ==? 't'
    let s:last_find = {'forward': forward, 'char': c, 'until': until, 'smart': a:smart}
  endif
  call mi#ft#repeat(';')
endfunction

function! mi#ft#exact(starter) abort
  call s:ft_start(a:starter, 0)
endfunction

function! mi#ft#smart(starter) abort
  call s:ft_start(a:starter, 1)
endfunction

function! mi#ft#repeat(starter) abort
  if stridx(';,', a:starter) < 0
    return
  endif
  if exists('s:last_find')
    if (s:last_find.forward && a:starter == ';') ||
          \ (!s:last_find.forward && a:starter == ',')
      call s:ft_forward()
    else
      call s:ft_backward()
    endif
  else
    execute 'normal!' a:starter
  endif
endfunction
