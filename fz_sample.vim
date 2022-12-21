function! s:winids() abort
  return map(getwininfo(), 'v:val.winid')
endfunction
function! s:separate(str, idx) abort
  return [slice(a:str, 0, a:idx), slice(a:str, a:idx)]
endfunction
function! s:sep3(str, from, to) abort
  let [tmp, a3] = s:separate(a:str, a:to)
  let [a1, a2] = s:separate(tmp, a:from)
  return [a1, a2, a3]
endfunction

" let text='hello world super owo end one two three'

function! s:recursive_fuzzy_match_in_line(line, query, off = 0) abort
  let line = a:line
  let [match, cols, scores] = matchfuzzypos([line], a:query)
  if empty(match)
    return []
  endif
  let cols = map(cols[0], 'v:val+1')

  let from = cols[0] - 1
  let to = cols[-1]
  let len = to - from

  let [pre_matched, matched, post_matched] = s:sep3(line, from, to)
  let matches = []
  " 日本語混じりのときに壊れないか確認が必要

  " 1行が長いとそれだけでスコアが下がるため、
  " マッチ範囲に再度マッチさせてスコアを再計算する
  " これだと必ず単語頭マッチになってしまってよくないか？
  let score = matchfuzzypos([matched], a:query)[2][0]
  call add(matches, {'score': score, 'cols': map(cols, 'v:val+' .. a:off), 'matched': matched, 'len': len})

  " マッチ前後の範囲で再帰的にマッチを探す
  call extend(matches, s:recursive_fuzzy_match_in_line(pre_matched, a:query))
  call extend(matches, s:recursive_fuzzy_match_in_line(post_matched, a:query, to))
  return matches
endfunction

" super long long sentence that has query at once owo super long long sentence that has query at once super long long sentence that has query at once

function! s:fuzzy_match_buffer(query) abort
  let lnum = line('w0')

  let matches = []
  if a:query == ''
    return matches
  endif

  for line in getline('w0', 'w$')
    let match = s:recursive_fuzzy_match_in_line(line, a:query)
    if !empty(match)
      call extend(matches, map(match, {_,v ->extend(v, {'lnum': lnum}) } ))
    endif
    let lnum += 1
  endfor

  " rank: short length is strong, high score is strong in same length
  call sort(matches, {a,b -> a.len == b.len ? b.score - a.score : a.len - b.len})

  return matches
endfunction

function! s:add_highlights(match_specs) abort
  let s:match_ids = []
  for lnum in range(line('w0'), line('w$'))
    call add(s:match_ids, matchaddpos('Comment', [lnum]))
  endfor
  for match_spec in a:match_specs
    call add(s:match_ids, matchaddpos('Visual', [[match_spec.lnum, match_spec.cols[0], match_spec.len]]))
    for col in match_spec.cols
      call add(s:match_ids, matchaddpos('IncSearch', [[match_spec.lnum, col]]))
    endfor
  endfor
  let s:match_specs = a:match_specs

  " let scores = map(a:match_specs, 'v:val.score')
  " call win_execute(win_getid(winnr('$')), 'call append(0, "' .. join(scores, ' ') .. '")')
endfunction

function! s:clear_highlights() abort
  let ids = get(s:, 'match_ids', [])
  for id in ids
    silent! call matchdelete(id)
  endfor
endfunction

let s:select_marks = 'ABCDEFGHIJKLMNO'

function! s:on_input(query) abort
  call s:clear_highlights()
  let s:last_query = a:query
  if a:query[-1:] =~# '\u'
    let keys = "\<bs>"
    if s:select_marks =~# a:query[-1:]
      let s:selected_mark = a:query[-1:]
      let keys ..= "\<cr>"
    endif
    call feedkeys(keys, 'n')
  else
    call s:add_highlights(s:fuzzy_match_buffer(a:query))
  endif
  redraw
endfunction

function! s:start_fuzzy_match(repeat = 0) abort
  augroup cmd_input
    " autocmd CursorMoved * ++once call s:clear_highlights()
    autocmd CmdlineEnter,CmdlineChanged @ call s:on_input(getcmdline())
  augroup END
  autocmd CmdlineLeave @ ++once call s:clear_highlights() | autocmd! cmd_input

  let s:selected_mark = ''

  let q = a:repeat ? get(s:, 'last_query', '') : ''
  let last_query = input('fuzzy match > ', q)
  if last_query != ''
    let s:last_query = last_query
    if s:selected_mark == ''
      let s:selected_mark = s:select_marks[0]
    endif
    if exists('s:match_specs')
      let match_spec = s:match_specs[stridx(s:select_marks, s:selected_mark)]
      call cursor(match_spec.lnum, match_spec.cols[0])
    endif
  endif
endfunction
nnoremap f<cr> <cmd>call <sid>start_fuzzy_match()<cr>
nnoremap f<bs> <cmd>call <sid>start_fuzzy_match(1)<cr>
