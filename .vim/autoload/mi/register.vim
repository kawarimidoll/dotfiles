" {{{ mi#register#collect_yank_history()
function! mi#register#collect_yank_history(length = -1) abort
  if a:length == 0 || @" ==# @a
    return
  endif
  const latest_reg_info = getreginfo('"')
  " regs should be start with double quote
  const regs = split('"' .. g:mi#const#alpha_lower[:a:length], '\zs')
  let saved_info = latest_reg_info
  for index in range(1, len(regs) - 1)
    let current_info = getreginfo(regs[index])
    call setreg(regs[index], saved_info)
    if get(current_info, 'regcontents', []) ==# latest_reg_info.regcontents
      return
    endif
    let saved_info = current_info
  endfor
endfunction
" }}}

" {{{ mi#register#clear()
" https://zenn.dev/kawarimidoll/articles/3f42843715c5de
function! mi#register#clear() abort
  for r in split(g:mi#const#alnum .. '/', '\zs')
    call setreg(r, [])
  endfor
endfunction
" }}}
