function! s:operator_add_blank_line(ctx = {}, type ='') abort
  let head = getpos("'[")
  let tail = getpos("']")
  if a:ctx.dir == 'k'
    call setpos('.', getpos("']"))
    put! =repeat(nr2char(10), a:ctx.cnt)
    normal! '[
  else
    call setpos('.', getpos("'["))
    put =repeat(nr2char(10), a:ctx.cnt)
  endif
endfunction

function! mi#blank#above(cnt) abort
  let context = {'cnt': a:cnt, 'dir': 'k'}
  let &operatorfunc = function('s:operator_add_blank_line', [context])
  return 'g@k'
endfunction

function! mi#blank#below(cnt) abort
  let context = {'cnt': a:cnt, 'dir': 'j'}
  let &operatorfunc = function('s:operator_add_blank_line', [context])
  return 'g@j'
endfunction
