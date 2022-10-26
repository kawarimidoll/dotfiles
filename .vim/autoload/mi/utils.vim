let s:key_table = {
      \  '`': '~',
      \  '1': '!',
      \  '2': '@',
      \  '3': '#',
      \  '4': '$',
      \  '5': '%',
      \  '6': '^',
      \  '7': '&',
      \  '8': '*',
      \  '9': '(',
      \  '0': ')',
      \  '-': '_',
      \  '=': '+',
      \  '[': '{',
      \  '}': ']',
      \  '\': '|',
      \  ';': ':',
      \  "'": '"',
      \  ',': '<',
      \  '.': '>',
      \  '/': '?',
      \  }

function! mi#utils#update_key_table(key_table) abort
  let s:key_table = a:key_table
endfunction

function! mi#utils#upper_key(key) abort
  return get(s:key_table, a:key, toupper(a:key))
endfunction

function! mi#utils#lower_key(key) abort
  if !exists('s:key_table_inv')
    let s:key_table_inv = {}
    for [k, v] in items(s:key_table)
      let s:key_table_inv[v] = k
    endfor
  endif
  return get(s:key_table_inv, a:key, tolower(a:key))
endfunction
