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

  let idx = stridx(line, mi#utils#lower_key(c), col + off) + 1
  let idx_u = stridx(line, mi#utils#upper_key(c), col + off) + 1
  if idx < 1 || (1 < idx_u && idx_u < idx)
    let idx = idx_u
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
  let idx = max([
        \   strridx(line, mi#utils#lower_key(c), col + off),
        \   strridx(line, mi#utils#upper_key(c), col + off),
        \ ]) + 1

  if idx > 0
    let off = 0
    if s:last_find.till
      let off += 1
    endif
    call cursor(lnum, idx + off)
  endif
endfunction

function! mi#motion#f() abort
  if !exists('g:mi#dot_repeating')
    let c = nr2char(getchar())
    if c !~ '\p'
      return
    endif

    let s:last_find = {'direction': 'right', 'char': c, 'till': v:false}
  endif
  call s:motion_right()
endfunction

function! mi#motion#F() abort
  if !exists('g:mi#dot_repeating')
    let c = nr2char(getchar())
    if c !~ '\p'
      return
    endif

    let s:last_find = {'direction': 'left', 'char': c, 'till': v:false}
    call s:motion_left()
  endif
endfunction

function! mi#motion#t() abort
  if !exists('g:mi#dot_repeating')
    let c = nr2char(getchar())
    if c !~ '\p'
      return
    endif

    let s:last_find = {'direction': 'right', 'char': c, 'till': v:true}
  endif
  call s:motion_right()
endfunction

function! mi#motion#T() abort
  if !exists('g:mi#dot_repeating')
    let c = nr2char(getchar())
    if c !~ '\p'
      return
    endif

    let s:last_find = {'direction': 'left', 'char': c, 'till': v:true}
  endif
  call s:motion_left()
endfunction

function! mi#motion#semicolon() abort
  if exists('s:last_find')
    if s:last_find.direction == 'right'
      call s:motion_right()
    else
      call s:motion_left()
    endif
  else
    normal! ;
  endif
endfunction
function! mi#motion#comma() abort
  if exists('s:last_find')
    if s:last_find.direction == 'right'
      call s:motion_left()
    else
      call s:motion_right()
    endif
  else
    normal! ,
  endif
endfunction

function! mi#motion#original(char) abort
  if stridx('fFtT', a:char) < 0
    return
  endif
  unlet! s:last_find
  execute 'normal!' a:char
endfunction
