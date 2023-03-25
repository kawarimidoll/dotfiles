" array helpers {{{

function! s:includes(heystack, needle) abort
  return index(a:heystack, a:needle) >= 0
endfunction

function! s:excludes(heystack, needle) abort
  return !s:includes(a:heystack, a:needle)
endfunction

" }}}

" regex helpers {{{

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

" }}}

" regex patterns {{{

" :h :range
" number, current line, end of buffer, whole buffer, mark,
" forward search, backward search, last search
const s:range_element_patterns = [
      \ '\d\+', '[.$%]', "'[a-zA-Z<>'`]",
      \ '/[^/]\+/', '?[^?]\+?', '\[/?&]'
      \ ]
const s:range_item_pattern = s:x_oneof(s:range_element_patterns) .. s:x_opt('[+-]\d\+')
const s:range_pattern = s:x_opt(s:range_item_pattern .. s:x_any('[,;]' .. s:range_item_pattern))

" :h pattern-delimiter
" const s:delimiter_pattern = "[!@$%^&*()=+~`',.;:<>/?_-]"

const s:args_pattern = s:x_opt('\S.*')
const s:cmd_pattern = s:x_plus('\a') .. s:x_opt('!')

const s:cmdline_pattern = '^' .. s:x_cap(s:range_pattern) .. s:x_any('\s') ..
      \ s:x_cap(s:cmd_pattern) .. s:x_any('\s') .. s:x_cap(s:args_pattern)

" }}}

" private functions {{{

function! s:range_item_to_lnum(range_item) abort
  " TODO: handle range items like below
  " 7;/pattern/ -> the line that matches to pattern after line 7
  " NOTE: \& is not supported

  const range_diff_start_idx = match(a:range_item, s:x_any('[+-]\d\+') .. '$')
  if range_diff_start_idx == 0
    " only diff
    const range_main = '.'
    const range_diff = eval(a:range_item)
  elseif range_diff_start_idx == strlen(a:range_item)
    " only range item
    const range_main = a:range_item[:range_diff_start_idx-1]
    const range_diff = 0
  else
    " both
    const range_main = a:range_item[:range_diff_start_idx-1]
    const range_diff = eval(a:range_item[range_diff_start_idx:])
  endif

  if range_main =~ '^\d\+$'
    " exact number
    const lnum = str2nr(range_main)
  elseif range_main =~ '^/.\+/$'
    " downward search
    const lnum = search(slice(range_main, 1, -1), 'nW', 0, 0, 'line(''.'') == ' .. getpos('.')[2])
  elseif range_main =~ '^?.\+?$'
    " upward search
    const lnum = search(slice(range_main, 1, -1), 'bnW', 0, 0, 'line(''.'') == ' .. getpos('.')[2])
  elseif range_main == '\/'
    " downward last search
    const lnum = search(getreg('/'), 'nW', 0, 0, 'line(''.'') == ' .. getpos('.')[2])
  elseif range_main == '\?'
    " upward last search
    const lnum = search(getreg('/'), 'bnW', 0, 0, 'line(''.'') == ' .. getpos('.')[2])
  else
    const lnum = line(range_main)
  endif

  return lnum + range_diff
endfunction

function! s:range_str_to_lnum_pair(range_str) abort
  if a:range_str ==# ''
    return [line('.'), line('.')]
  endif

  try
    const range_delimiter_idx = matchend(a:range_str, '^' .. s:range_item_pattern)
    const range_from = a:range_str[:range_delimiter_idx-1]
    if range_from == '%'
      return [1, line('$')]
    endif

    const range_to = range_delimiter_idx < strlen(a:range_str) ?
          \ a:range_str[range_delimiter_idx+1:] :
          \ range_from

    return [s:range_item_to_lnum(range_from), s:range_item_to_lnum(range_to)]
  catch
    " fallback to current line to avoid to stop editing cmdline
    return [line('.'), line('.')]
  endtry
endfunction

function! s:extract(cmdline) abort
  const matched = matchlist(a:cmdline, s:cmdline_pattern)
  const range = get(matched, 1, '')
  const [range_from, range_to] = s:range_str_to_lnum_pair(range)
  return {
        \ 'whole': get(matched, 0, ''),
        \ 'range': range,
        \ 'cmd': get(matched, 2, ''),
        \ 'args': get(matched, 3, ''),
        \ 'range_from': range_from,
        \ 'range_to': range_to
        \ }
endfunction

" }}}

" public functions {{{

function! mi#cmdline#regex() abort
  return s:cmdline_pattern
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

" }}}
