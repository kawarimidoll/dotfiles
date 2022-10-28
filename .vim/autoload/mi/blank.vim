function! mi#blank#above(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#blank#above')
    return 'g@ '
  endif

  put! =repeat(nr2char(10), v:count1)
  normal! '[
endfunction

function! mi#blank#below(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#blank#below')
    return 'g@ '
  endif

  put =repeat(nr2char(10), v:count1)
endfunction
