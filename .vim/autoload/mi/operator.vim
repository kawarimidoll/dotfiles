" {{{ mi#operator#replace
function! mi#operator#replace(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#operator#replace')
    return 'g@'
  endif
  normal! `[v`]P
endfunction
" }}}

let s:leading_backslash = '\\s*$'
let s:trailing_backslash = '^\s*\\s*'
let s:pre_join_remove_patterns = {
      \ 'vim': s:trailing_backslash,
      \ 'bash': s:leading_backslash,
      \ 'zsh': s:leading_backslash,
      \ 'c': s:leading_backslash,
      \ 'cpp': s:leading_backslash,
      \ 'ruby': s:leading_backslash,
      \ 'python': s:leading_backslash,
      \ }

function! mi#operator#join(type = '') abort
  if a:type == ''
    set operatorfunc=function('mi#operator#join')
    return 'g@'
  endif
  let remove_pattern = get(s:pre_join_remove_patterns, &filetype, '')
  if remove_pattern ==# ''
    normal! `[v`]J
    return
  endif

  " remove line-continuation, ignore the first or the last line
  " silent! substitute/^\s*\\s*// <- simple, but changes the all lines
  let from = line("'[")
  let to = line("']")
  let expr = printf('keepjump normal! %sGV%sGJ', from, to)

  if remove_pattern[0] ==# '^'
    let from += 1
  endif
  if remove_pattern[-1:-1] ==# '$'
    let to -= 1
  endif
  let range = from
  if from < to
    let range ..= ',' .. to
  endif
  execute printf('silent! %ssubstitute/%s//', range, remove_pattern)
  execute expr
endfunction
