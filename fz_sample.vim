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

function! s:recursive_fuzzy_match(line, query, off = 0) abort
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
  call add(matches, {'score': score, 'cols': cols, 'matched': matched, 'len': len})

  " マッチ前後の範囲で再帰的にマッチを探す
  call extend(matches, s:recursive_fuzzy_match(pre_matched, a:query))
  call extend(matches, s:recursive_fuzzy_match(post_matched, a:query))
  return matches
endfunction

" super long long sentence that has query at once owo super long long sentence that has query at once super long long sentence that has query at once

function! s:fuzzy_match_buffer(query) abort
  let lnum = line('w0')
  let matches = []
  for line in getline('w0', 'w$')
    let match = s:recursive_fuzzy_match(line, a:query)
    if !empty(match)
      call extend(matches, map(match, {_,v ->extend(v, {'lnum': lnum}) } ))
    endif
    let lnum += 1
  endfor

  " rank: short length is strong, high score is strong in same length
  call sort(matches, {a,b -> a.len == b.len ? b.score - a.score : a.len - b.len})

  return matches
endfunction

echo s:fuzzy_match_buffer('cewo')
