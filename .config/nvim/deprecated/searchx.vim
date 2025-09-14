let g:searchx = {}
let g:searchx.auto_accept = v:true
let g:searchx.scrolloff = &scrolloff
let g:searchx.scrolltime = 500
let g:searchx.markers = split('ASDFGHJKLQWERTYUIOPZXCVBNM', '.\zs')
let g:searchx.nohlsearch = #{ jump: v:true }
function g:searchx.convert(input) abort
  if a:input !~# '\k'
    return '\V' .. a:input
  endif
  return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
endfunction

