function! mi#common#dot_repeat() abort
  try
    let g:mi#dot_repeating = 1
    normal! .
  finally
    unlet! g:mi#dot_repeating
  endtry
endfunction

function! mi#common#trim(ignore = {}) abort
  if !has_key(a:ignore, 'trailing_white_spaces')
    silent! %s/\s\+$//
  endif
  if !has_key(a:ignore, 'multiple_blank_line')
    silent! %s/^\n\zs\n\+//
  endif
  if !has_key(a:ignore, 'blank_line_eof')
    silent! %s/\n\+\%$//
  endif
endfunction

function! mi#common#half_move(direction, count = 1) abort
  let [lnum, col] = getpos('.')[1:2]

  for i in range(a:count)
    if a:direction == 'left'
      let col = col / 2
    elseif a:direction == 'right'
      let col = (len(getline('.')) + col) / 2
    elseif a:direction == 'center'
      let col = len(getline('.')) / 2
    elseif a:direction == 'up'
      let lnum = (line('w0') + lnum) / 2
    elseif a:direction == 'down'
      let lnum = (line('w$') + lnum) / 2
    else
      echoerr "half_move: direction must be one of ['left', 'right', 'center', 'up', 'down']"
    endif
  endfor
  call cursor(lnum, col)
endfunction
