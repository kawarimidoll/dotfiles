" regex helpers

" enclosure without capture
function! s:x_enc(str) abort
  return '\%(' .. a:str .. '\)'
endfunction

" joiner
function! s:x_oneof(patterns) abort
  return s:x_enc(join(a:patterns, '\|'))
endfunction

" regex patterns

" global, vglobal, sort, substitute,
" vimgrep, vimgrepadd, lvimgrep, lvimgrepadd
let s:cmd_patterns = [
      \ 'g\%[lobal]!\?',
      \ 'v\%[global]',
      \ 'sor\%[t]!\?',
      \ 's\%[ubstitute]',
      \ 'vim\%[grepadd]!\?',
      \ 'l\%[vimgrepadd]!\?',
      \ ]

" :h pattern-delimiter
let s:delimiter_pattern = "[!@$%^&*()=+~`',.;:<>/?_-]"

" functions

function! s:update_magic(query) abort
  if a:query[:1] ==# '\v'
    " \v -> \V
    return ['\V' .. a:query[2:], 0]
  elseif a:query[:1] ==# '\V'
    " \V -> \v
    return ['\v' .. a:query[2:], 0]
  else
    " not specified -> add \v
    return ['\v' .. a:query, 2]
  endif
endfunction

function! mi#magic#expr() abort
  if getcmdtype() !~# '[/?:]'
    return ''
  endif

  if getcmdtype() ==# ':'
    const cmd_spec = mi#cmdline#get_spec()
    if cmd_spec.cmd == '' ||
          \ cmd_spec.cmd !~# '^' .. s:x_oneof(s:cmd_patterns) .. '$'
      return
    endif

    let delim_idx = matchend(cmd_spec.args, s:delimiter_pattern)
    if delim_idx < 1
      return
    endif
    " :sort may have args except query
    let before_delim = cmd_spec.args[:delim_idx - 1]
    let [query, pos_diff] = s:update_magic(cmd_spec.args[delim_idx:])
    let query = cmd_spec.range .. cmd_spec.cmd .. before_delim .. query
  else
    " / or ?
    let [query, pos_diff] = s:update_magic(getcmdline())
  endif

  call setcmdline(query, getcmdpos() + pos_diff)

  " to redraw incsearch, update cmdline (add space and remove it)
  return " \<bs>"
endfunction
