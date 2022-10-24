function! s:get_string_after_cursor(length = 1) abort
  let col = col('.')-1
  return getline('.')[col:min([col+(a:length-1), col('$')])]
endfunction
function! s:get_string_before_cursor(length = 1) abort
  let col = col('.')-2
  if col < 0
    return ''
  endif
  return getline('.')[max([col-(a:length-1), 0]):col]
endfunction

let s:pairs = { '{': '}', '[': ']', '(': ')' }

function! s:is_inside_pairs(prev_char, next_char) abort
  return get(s:pairs, a:prev_char, '') == a:next_char
endfunction

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
function! s:expr_cr() abort
  if s:is_inside_pairs(s:get_string_before_cursor(1), s:get_string_after_cursor(1))
    return "\<cr>\<esc>O"
  endif
  return  "\<right>"
endfunction

function! s:is_inside_quotes(prev_char, next_char) abort
  return a:prev_char == a:next_char && index(s:quotes, a:prev_char) >= 0
endfunction
function! s:expr_bs() abort
  if s:is_inside_pairs(s:get_string_before_cursor(1), s:get_string_after_cursor(1))
        \ || s:is_inside_quotes(s:get_string_before_cursor(1), s:get_string_after_cursor(1))
    return "\<right>\<bs>\<bs>"
  endif
  return  "\<bs>"
endfunction

function! mi#pair#keymap_set(pairs = {}) abort
  if !empty(a:pairs)
    let s:pairs = a:pairs
  endif
  for [open_char, close_char] in items(s:pairs)
    execute printf('inoremap <expr> %s <sid>expr_pair_open("%s")', open_char, open_char)
    execute printf('inoremap <expr> %s <sid>expr_pair_close("%s")', close_char, close_char)
  endfor
  inoremap <expr> <cr> <sid>expr_cr()
  inoremap <expr> <bs> <sid>expr_bs()
endfunction

let s:quotes = ["'", '"', '`']

function! s:expr_quote(char) abort
  if s:get_string_after_cursor(1) == a:char
    return "\<right>"
  endif
  if s:get_string_before_cursor(1) == a:char
    return a:char
  endif

  return a:char .. a:char .. "\<left>"
endfunction

function! mi#pair#keymap_quote_set(quotes = []) abort
  if !empty(a:quotes)
    let s:quotes = a:quotes
  endif
  for quote in s:quotes
    execute printf("inoremap <expr> %s <sid>expr_quote(\"\\%s\")", quote, quote)
  endfor
endfunction
