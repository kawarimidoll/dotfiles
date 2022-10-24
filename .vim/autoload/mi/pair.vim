function! s:get_string_after_cursor(length = 1) abort
  let col = col('.')-1
  return getline('.')[col:min([col+a:length, col('$')])]
endfunction

let s:pairs = { '{': '}', '[': ']', '(': ')' }

function! s:expr_pair_open(open_char) abort
  let insert_str = a:open_char

  if index(extend(['', ' '], values(s:pairs)), s:get_string_after_cursor(1)) >= 0
    let insert_str ..= s:pairs[a:open_char] .. "\<left>"
  endif

  return insert_str
endfunction
function! s:expr_pair_close(close_char) abort
  if s:get_string_after_cursor(1) == a:close_char
    return "\<right>"
  endif
  return a:close_char
endfunction

function! mi#pair#keymap_set(pairs = {}) abort
  if !empty(a:pairs)
    let s:pairs = a:pairs
  endif
  for [open_char, close_char] in items(s:pairs)
    execute printf('inoremap <expr> %s <sid>expr_pair_open("%s")', open_char, open_char)
    execute printf('inoremap <expr> %s <sid>expr_pair_close("%s")', close_char, close_char)
  endfor
endfunction
