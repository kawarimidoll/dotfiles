function! mi#common#__compl_trim(_a, cmdline, _p) abort
  const list = filter(['ignore_trailing_white_spaces', 'ignore_multiple_blank_line', 'ignore_blank_line_eof'],
        \ {_,val -> stridx(a:cmdline, val) == -1})
  return join(list, "\n")
endfunction

function! mi#common#trim(ignores = []) abort range
  let patterns = []
  if index(a:ignores, 'ignore_trailing_white_spaces') < 0
    call add(patterns, '\s\+$')
  endif
  if index(a:ignores, 'ignore_multiple_blank_line') < 0
    call add(patterns, '^\n\zs\n\+')
  endif
  if index(a:ignores, 'ignore_blank_line_eof') < 0 && a:lastline >= line('$')
    call add(patterns, '\n\+\%$')
  endif
  if empty(patterns)
    return
  endif
  keeppatterns execute a:firstline .. ',' .. a:lastline .. 's/' .. join(patterns, '\|') .. '//e'
endfunction

function! mi#common#delete_blank_lines() abort range
  execute a:firstline .. ',' .. a:lastline .. 'global/^$/delete _'
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
