function! mi#common#dot_repeat() abort
  try
    let g:mi#dot_repeating = 1
    normal! .
  finally
    unlet! g:mi#dot_repeating
  endtry
endfunction

function! mi#common#__compl_trim(_a, cmdline, _p) abort
  const list = filter(['ignore_trailing_white_spaces', 'ignore_multiple_blank_line', 'ignore_blank_line_eof'],
        \ {_,val -> stridx(a:cmdline, val) == -1})
  return join(list, "\n")
endfunction

function! mi#common#trim(ignores = []) abort range
  const prefix = a:firstline .. ',' .. a:lastline .. 's/'
  echomsg a:firstline a:lastline
  if index(a:ignores, 'ignore_trailing_white_spaces') < 0
    silent! execute prefix .. '\s\+$//'
  endif
  if index(a:ignores, 'ignore_multiple_blank_line') < 0
    silent! execute prefix .. '^\n\zs\n\+//'
  endif
  if index(a:ignores, 'ignore_blank_line_eof') < 0 && a:lastline >= line('$')
    silent! execute '%s/\n\+\%$//'
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
