" helpers

function! s:match_ranges(expr, pat, multiple = 0)
  let match_from = match(a:expr, a:pat)
  if match_from < 0
    return []
  endif
  let match_to = matchend(a:expr, a:pat)

  let matches = [[match_from, match_to]]

  while a:multiple
    let match_from = match(a:expr, a:pat, match_to)
    if match_from < 0
      break
    endif
    let match_to = matchend(a:expr, a:pat, match_to)
    call add(matches, [match_from, match_to])
  endwhile

  return matches
endfunction

function! s:getlines_except_folded(from, to)
  let lines = []
  let from = type(a:from) == v:t_number ? a:from : line(a:from)
  let to = type(a:to) == v:t_number ? a:to : line(a:to)

  for lnum in range(from, to)
    let fold_end = foldclosedend(lnum)
    if fold_end > -1
      let lnum = fold_end
    else
      call add(lines, {'lnum': lnum, 'line': getline(lnum)})
    endif
  endfor
  return lines
endfunction

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

" :h pattern-delimiter
let s:delimiter_pattern = "[!@$%^&*()=+~`',.;:<>/?_-]"

let s:cmdline_pattern = '^' .. s:range_pattern ..
      \ 's\%[ubstitute] *' .. s:delimiter_pattern

function! s:range_item_to_lnum(range_item)
  " TODO: handle range items like below
  " /function/

  let range_diff_start = match(a:range_item, '[+-]\d\+$')
  if range_diff_start < 0
    let range_main = a:range_item
    let range_diff = 0
  else
    let range_main = a:range_item[:range_diff_start-1]
    let range_diff = eval(a:range_item[range_diff_start:])
  endif

  if range_main =~ '^\d\+$'
    let lnum = eval(range_main)
  else
    let lnum = line(range_main)
  endif
  return lnum + range_diff
endfunction

function! s:get_cmd_range(cmdline)
  let range_str_end = matchend(a:cmdline, '^' .. s:range_pattern)

  if range_str_end < 1
    return [line('.'), line('.')]
  endif
  let range_str = a:cmdline[:range_str_end-1]
  let range_from_end = matchend(range_str, s:range_item)
  let range_from = range_str[:range_from_end-1]
  if range_from == '%'
    return [1, line('$')]
  endif
  if range_from_end < strlen(range_str)
    let range_to = range_str[range_from_end+1:]
  else
    let range_to = range_from
  endif

  return [s:range_item_to_lnum(range_from), s:range_item_to_lnum(range_to)]
endfunction

function! s:init_highlight()
  if exists('s:conceal_match_ids')
    for id in s:conceal_match_ids
      call matchdelete(id)
    endfor
    unlet! s:conceal_match_ids
  endif
  silent! call prop_remove({'all': 1, 'type': s:prop_type})
endfunction

let s:prop_type = 'substitutor#prop_type'

function! s:on_input()
  call s:init_highlight()
  let cmdline = getcmdline()
  let delimiter_idx = matchend(cmdline, s:cmdline_pattern)

  if delimiter_idx <= 0
    return
  endif
  let delim = cmdline[delimiter_idx-1]

  let elements = split(slice(cmdline, delimiter_idx), delim)
  if len(elements) < 2
    return
  endif

  if !exists('s:save_conceal')
    call s:on_enter()
  endif

  let sub_from = elements[0]
  let sub_to = get(elements, 1, '')
  let flags = get(elements, 2, '')
  let multiple = flags =~ 'g'

  let s:conceal_match_ids = []
  let [range_from, range_to] = s:get_cmd_range(cmdline)
  for line_spec in s:getlines_except_folded(range_from, range_to)
    for [match_from, match_to] in s:match_ranges(line_spec.line, sub_from, multiple)
      call add(s:conceal_match_ids, matchaddpos('Conceal', [[line_spec.lnum, match_from+1, match_to-match_from]], 20))
      call prop_add(line_spec.lnum, match_from+1, {'type': s:prop_type, 'text': sub_to})
    endfor
  endfor
endfunction

function! s:on_leave()
  if exists('s:save_conceal')
    call s:init_highlight()
    let &conceallevel = s:save_conceal.level
    let &concealcursor = s:save_conceal.cursor
    unlet! s:save_conceal
  endif
endfunction

function! s:on_enter()
  let s:save_conceal = {}
  let s:save_conceal.level = &conceallevel
  let s:save_conceal.cursor = &concealcursor
  set conceallevel=2
  set concealcursor+=c
  call prop_type_delete(s:prop_type, {})
  call prop_type_add(s:prop_type, {'highlight': 'Visual'})
  autocmd CmdlineLeave : ++once call s:on_leave()
endfunction

augroup substitutor#augroup
  autocmd!
  autocmd CmdlineChanged : call s:on_input()
augroup end
