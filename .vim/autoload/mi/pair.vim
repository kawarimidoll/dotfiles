" https://original-game.com/how-to-make-a-complementary-function-of-vim/2/

function! s:next_char() abort
  return getline('.')[col('.') - 1]
endfunction

function! s:prev_char() abort
  let col = col('.') - 2
  if col < 0
    return ''
  endif
  return getline('.')[col]
endfunction

function! s:get_pairs() abort
  return get(s:, 'pairs', {})
endfunction
function! s:get_quotes() abort
  return get(s:, 'quotes', [])
endfunction

function! s:is_inside_pairs() abort
  return get(s:get_pairs(), s:prev_char(), '') == s:next_char() && s:next_char() != ''
endfunction

function! s:is_inside_quotes() abort
  return s:prev_char() == s:next_char() && index(s:get_quotes(), s:prev_char()) >= 0
endfunction

function! mi#pair#open(char) abort
  if s:prev_char() == '\'
    return a:char
  endif
  return a:char .. s:get_pairs()[a:char] .. "\<left>"
endfunction

function! mi#pair#close(char) abort
  if s:prev_char() == '\'
    return a:char
  endif
  if s:next_char() == a:char
    return "\<right>"
  endif
  return a:char
endfunction

function! mi#pair#quote(char) abort
  if s:prev_char() == '\'
    return a:char
  endif
  if s:next_char() == a:char
    return "\<right>"
  endif
  if s:prev_char() == a:char
    return a:char
  endif

  return a:char .. a:char .. "\<left>"
endfunction

function! mi#pair#cr() abort
  if s:is_inside_pairs()
    return "\<cr>\<esc>O"
  endif
  return "\<cr>"
endfunction

function! mi#pair#bs() abort
  if s:is_inside_pairs() || s:is_inside_quotes()
    return "\<right>\<bs>\<bs>"
  endif
  return  "\<bs>"
endfunction

function! mi#pair#keymap_set(list = []) abort
  let s:pairs = {}
  let s:quotes = []
  for item in a:list
    let len = strlen(item)
    if len != 2
      echoerr 'list item must be 2-characters word. invalid:' item
      continue
    endif
    if item[0] == item[1]
      " quote
      call add(s:quotes, item[0])
    else
      " pair
      let s:pairs[item[0]] = item[1]
    endif
  endfor

  for [open_char, close_char] in items(s:pairs)
    execute printf("inoremap <expr> %s mi#pair#open(\"\\%s\")", open_char, open_char)
    execute printf("inoremap <expr> %s mi#pair#close(\"\\%s\")", close_char, close_char)
  endfor

  for quote in s:quotes
    execute printf("inoremap <expr> %s mi#pair#quote(\"\\%s\")", quote, quote)
  endfor

  inoremap <expr> <cr> mi#pair#cr()
  inoremap <expr> <bs> mi#pair#bs()
endfunction
