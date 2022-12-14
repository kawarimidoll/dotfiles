" regex helpers

" enclosure without capture
function! s:x_enc(str) abort
  return '\%(' .. a:str .. '\)'
endfunction

" joiner
function! s:x_oneof(patterns) abort
  return s:x_enc(join(a:patterns, '\|'))
endfunction

" optional
function! s:x_opt(str) abort
  return s:x_enc(a:str) .. '\?'
endfunction

" zero or more
function! s:x_any(str) abort
  return s:x_enc(a:str) .. '*'
endfunction

" regex patterns

"  number, current line, end of buffer, whole buffer, mark,
"  forward search, backward search, last search
let s:range_elements = [
      \ '\d\+', '[.$%]', "'[a-zA-Z<>'`]",
      \ '/[^/]\+/', '?[^?]\+?', '\[/?&]'
      \ ]
let s:range_item = s:x_oneof(s:range_elements) .. s:x_opt('[+-]\d\+')
let s:range_pattern = s:x_opt(s:range_item .. s:x_any('[,;]' .. s:range_item))

" global, vglobal, sort, substitute,
" vimgrep, vimgrepadd, lvimgrep, lvimgrepadd
let s:cmd_patterns = [
      \ 'g\%[lobal]!\? *',
      \ 'v\%[global] *',
      \ 'sor\%[t]!\?[ bfilnorux]*',
      \ 's\%[ubstitute] *',
      \ 'vim\%[grepadd]!\? *',
      \ 'l\%[vimgrepadd]!\? *',
      \ ]

" :h pattern-delimiter
let s:delimiter_pattern = "[!@$%^&*()=+~`',.;:<>/?_-]"

let s:cmdline_pattern = '^' .. s:range_pattern ..
      \ s:x_oneof(s:cmd_patterns) .. s:delimiter_pattern

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
    let query = getcmdline()
    let matchidx = matchend(query, s:cmdline_pattern)
    if matchidx < 1
      " not listed command
      return ''
    endif
    let before_query = query[:matchidx - 1]
    let [query, pos_diff] = s:update_magic(query[matchidx:])
    let query = before_query .. query
  else
    " / or ?
    let [query, pos_diff] = s:update_magic(getcmdline())
  endif

  call setcmdline(query, getcmdpos() + pos_diff)

  " to redraw incsearch, update cmdline (add space and remove it)
  return " \<bs>"
endfunction
