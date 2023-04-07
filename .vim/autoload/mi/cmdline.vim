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

" }}}

" public functions {{{

function! mi#cmdline#regex() abort
  return s:cmdline_pattern
endfunction

function! mi#cmdline#get_spec() abort
  if getcmdtype() != ':'
    return {
          \ 'whole': getcmdline(),
          \ 'range': '',
          \ 'cmd': '',
          \ 'bang': v:false,
          \ 'args': '',
          \ 'range_from': '',
          \ 'range_to': '',
          \ }
  endif

  const matched = matchlist(getcmdline(), s:cmdline_pattern)
  const range = get(matched, 1, '')
  const [range_from, range_to] = s:range_str_to_lnum_pair(range)
  const cmd_part = get(matched, 2, '')
  return {
        \ 'whole': get(matched, 0, ''),
        \ 'range': range,
        \ 'cmd': substitute(cmd_part, '!$', '', ''),
        \ 'bang': cmd_part =~# '!$',
        \ 'args': get(matched, 3, ''),
        \ 'range_from': range_from,
        \ 'range_to': range_to
        \ }
endfunction

function! mi#cmdline#set_by_spec(spec, throw_if_empty = v:false) abort
  const cmd = get(a:spec, 'cmd', '')
  if empty(cmd)
    if a:throw_if_empty
      throw '[mi#cmdline] cmd is required'
    endif
    return
  endif
  const range = get(a:spec, 'range', '')
  const bang = get(a:spec, 'bang', v:false) ? '!' : ''
  const args = empty(get(a:spec, 'args', '')) ? '' : ' ' .. a:spec.args

  call setcmdline(printf('%s%s%s%s', range, cmd, bang, args))
endfunction

function! mi#cmdline#bang(mod) abort
  if a:mod !~# '^ON\|OFF\|TOGGLE$'
    throw '[mi#cmdline] use mod one of [ON, OFF, TOGGLE].'
  endif

  const cmd_spec = mi#cmdline#get_spec()
  if empty(get(cmd_spec, 'cmd', ''))
    return
  endif

  const bang = a:mod ==# 'TOGGLE' ? !cmd_spec.bang : (a:mod ==# 'ON')
  call mi#cmdline#set_by_spec(extend({'bang': bang}, cmd_spec, 'keep'))
endfunction

let s:proxy_list = {}
let s:proxy_anonymous_key = 0

function! s:proxy_key(key) abort
  if empty(a:key)
    let s:proxy_anonymous_key += 1
    return s:proxy_anonymous_key
  endif
  return a:key
endfunction

function! mi#cmdline#proxy_list() abort
  return s:proxy_list
endfunction

function! mi#cmdline#proxy_let(from, to, key = '') abort
  let s:proxy_list[s:proxy_key(a:key)] = [a:from, a:to]
  return s:proxy_list
endfunction

function! mi#cmdline#proxy_unlet(key) abort
  unlet! s:proxy_list[a:key]
  return s:proxy_list
endfunction

function! mi#cmdline#proxy_clear() abort
  let s:proxy_list = {}
  return s:proxy_list
endfunction

function! mi#cmdline#proxy_convert() abort
  const cmd_spec = mi#cmdline#get_spec()
  if empty(get(cmd_spec, 'cmd', ''))
    return
  endif
  for [from, to] in values(s:proxy_list)
    if cmd_spec.cmd =~# substitute(printf('^%s$', from), '[', '\\%[', '')
      call mi#cmdline#set_by_spec(extend({'cmd': to}, cmd_spec, 'keep'))
      return
    endif
  endfor
endfunction

" command! -nargs=+ Echo echo string(<args>) .. '!!!'
" call mi#cmdline#proxy_let('ec[ho]', 'Echo')

" }}}
