" ref: sample below :h e840
function! mi#cmp#findstart() abort
  let line = getline('.')
  let [before_cursor, after_cursor] = mi#utils#str_divide(line, col('.')-1)

  " 以下は「Vimです」のような文章で切れ目がわからなくなる
  " let start = matchend(before_cursor, '.*[^[:keyword:]]')
  " if start < 0
  "   let start = 0
  " endif

  " マルチバイトまじりの文章に対応するためwhileで回すしかなさそう
  let start = strlen(before_cursor)
  while start > 0 && before_cursor[start - 1] =~ '\k'
    let start -= 1
  endwhile

  let [before_word, lastword] = mi#utils#str_divide(before_cursor, start)
  let s:cmp_info = l:
  return start
endfunction
