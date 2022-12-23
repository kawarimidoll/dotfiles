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

function! s:init_highlight()
  if exists('s:conceal_match_ids')
    for id in s:conceal_match_ids
      call matchdelete(id)
    endfor
    unlet! s:conceal_match_ids
  endif
  silent! call prop_remove({'all': 1, 'type': s:prop_type}, line('w0'), line('w$'))
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

  let [_; elements] = split(cmdline, delim)
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
  let lnum = line('w0')
  for line in getline('w0', 'w$')
    for [match_from, match_to] in s:match_ranges(line, sub_from, multiple)
      call add(s:conceal_match_ids, matchaddpos('Conceal', [[lnum, match_from+1, match_to-match_from]], 20))
      call prop_add(lnum, match_from+1, {'type': s:prop_type, 'text': sub_to})
    endfor
    let lnum += 1
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
  " autocmd CmdlineEnter,CmdlineChanged : call s:on_input()
augroup end
