" array helpers

function! s:includes(heystack, needle) abort
  return index(a:heystack, a:needle) >= 0
endfunction

function! s:excludes(heystack, needle) abort
  return !s:includes(a:heystack, a:needle)
endfunction

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
const s:range_elements = [
      \ '\d\+', '[.$%]', "'[a-zA-Z<>'`]",
      \ '/[^/]\+/', '?[^?]\+?', '\[/?&]'
      \ ]
const s:range_item = s:x_oneof(s:range_elements) .. s:x_opt('[+-]\d\+')
const s:range_pattern = s:x_opt(s:range_item .. s:x_any('[,;]' .. s:range_item))

" :h pattern-delimiter
" const s:delimiter_pattern = "[!@$%^&*()=+~`',.;:<>/?_-]"

const s:args_pattern = s:x_opt('\S.*')
const s:cmd_pattern = s:x_plus('\a') .. s:x_opt('!')

const s:cmdline_pattern = '^' .. s:x_cap(s:range_pattern) .. s:x_any('\s') ..
      \ s:x_cap(s:cmd_pattern) .. s:x_any('\s') .. s:x_cap(s:args_pattern)

function! s:extract(cmdline) abort
  const matched = matchlist(a:cmdline, s:cmdline_pattern)
  const [whole, range, cmd, args; rest] = matched
  return {'whole': whole, 'range': range, 'cmd': cmd, 'args': args}
endfunction

function! mi#cmdline#extract() abort
  if getcmdtype() != ':'
    return {}
  endif
  return s:extract(getcmdline())
endfunction

function! mi#cmdline#bang(mod) abort
  const ON = 'ON'
  const OFF = 'OFF'
  const TOGGLE = 'TOGGLE'
  if s:excludes([ON, OFF, TOGGLE], a:mod)
    throw '[mi#cmdline] use mod one of [ON, OFF, TOGGLE].'
  endif

  const cmd_spec = mi#cmdline#extract()
  if cmd_spec.cmd == ''
    return
  endif

  const has_bang = cmd_spec.cmd[-1:] ==# '!'
  if has_bang && s:includes([OFF, TOGGLE], a:mod)
    const cmd = cmd_spec.cmd[:-2]
  elseif !has_bang && s:includes([ON, TOGGLE], a:mod)
    const cmd = cmd_spec.cmd .. '!'
  else
    const cmd = cmd_spec.cmd
  endif

  const args = cmd_spec.args ==# '' ? '' : (' ' .. cmd_spec.args)
  call setcmdline(printf('%s%s%s', cmd_spec.range, cmd, args))
endfunction
