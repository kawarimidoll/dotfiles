" regex helpers

" capture group
function! s:x_cap(str) abort
  return '\(' .. a:str .. '\)'
endfunction

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

" one or more
function! s:x_plus(str) abort
  return s:x_enc(a:str) .. '\+'
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

" :h pattern-delimiter
" let s:delimiter_pattern = "[!@$%^&*()=+~`',.;:<>/?_-]"

let s:args_pattern = s:x_opt('\S.*')
let s:cmd_pattern = s:x_plus('\a') .. s:x_opt('!')

let s:cmdline_pattern = '^' .. s:x_cap(s:range_pattern) .. s:x_any('\s') ..
      \ s:x_cap(s:cmd_pattern) .. s:x_any('\s') .. s:x_cap(s:args_pattern)

function! s:extract(cmdline) abort
  let matched = matchlist(a:cmdline, s:cmdline_pattern)
  let [whole, range, cmd, args; rest] = matched
  return {'whole': whole, 'range': range, 'cmd': cmd, 'args': args}
endfunction

function! mi#cmdline#extract() abort
  if getcmdtype() != ':'
    return {}
  endif
  return s:extract(getcmdline())
endfunction

function! mi#cmdline#toggle_bang() abort
  let cmd_spec = mi#cmdline#extract()
  if cmd_spec.cmd == ''
    return ''
  endif
  let cmd = cmd_spec.cmd =~ '!$' ? cmd_spec.cmd[:-2] : (cmd_spec.cmd .. '!')
  let args = cmd_spec.args == '' ? '' : (' ' .. cmd_spec.args)
  call setcmdline(printf('%s%s%s', cmd_spec.range, cmd, args))
endfunction
