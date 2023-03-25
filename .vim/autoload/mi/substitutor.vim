" helpers

function! s:match_ranges(expr, pat, multiple = 0)
  if &ignorecase && &smartcase && a:pat !~ '\c'
    let pat = '\C' .. a:pat
  else
    let pat = a:pat
  endif
  let match_from = match(a:expr, pat)
  if match_from < 0
    return []
  endif
  let match_to = matchend(a:expr, pat)

  let matches = [[match_from, match_to]]

  while a:multiple
    let match_from = match(a:expr, pat, match_to)
    if match_from < 0
      break
    endif
    let match_to = matchend(a:expr, pat, match_to)
    call add(matches, [match_from, match_to])
  endwhile

  return matches
endfunction

function! s:getlines_except_folded(from, to)
  let lines = []
  let from = type(a:from) == v:t_number ? a:from : line(a:from)
  let to = type(a:to) == v:t_number ? a:to : line(a:to)
  if from > to
    let [from, to] = [to, from]
  endif

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

" :h pattern-delimiter
let s:delimiter_pattern = "[!@$%^&*()=+~`',.;:<>/?_-]"

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

  const cmd_spec = mi#cmdline#extract()
  if cmd_spec.cmd == '' ||
        \ cmd_spec.cmd !~# '^s\%[ubstitute]$' ||
        \ strlen(cmd_spec.args) < 2 ||
        \ cmd_spec.args[0] !~# s:delimiter_pattern
    return
  endif

  let elements = split(cmd_spec.args, cmd_spec.args[0])
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
  let [range_from, range_to] = [cmd_spec.range_from, cmd_spec.range_to]
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
