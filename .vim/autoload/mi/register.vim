let s:alpha_lower = 'abcdefghijklmnopqrstuvwxyz'
let s:alpha_upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
let s:digits = '0123456789'
let s:alpha_all = s:alpha_lower .. s:alpha_upper
let s:alnum = s:alpha_all .. s:digits

" {{{ mi#register#collect_yank_history()
function! mi#register#collect_yank_history(length = -1) abort
  " regs should be start with double quote
  let regs = split('"' .. s:alpha_lower[:a:length], '\zs')
  for index in range(len(regs) - 1, 1, -1)
    call setreg(regs[index], getreginfo(regs[index-1]))
  endfor
endfunction
" }}}

" {{{ mi#register#clear()
" https://zenn.dev/kawarimidoll/articles/3f42843715c5de
function! mi#register#clear() abort
  for r in split(s:alnum .. '/', '\zs')
    call setreg(r, [])
  endfor
endfunction
" }}}
