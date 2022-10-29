" inspired by :h getchar()

function! mi#ft#repeat(key) abort
  if a:key != ';' && a:key != ','
    return
  endif

  let charsearch = getcharsearch()
  if !exists('s:lastchar')
    let s:lastchar = charsearch.char
  endif

  let char = s:lastchar
  if char == ''
    return
  endif

  let direction = (charsearch.forward && a:key == ';') ||
        \ (!charsearch.forward && a:key == ',') ? 1 : -1

  let line = getline('.')
  let [lnum, col] = getpos('.')[1:2]

  " search_off = -2 has a bit difference from default behavior using T,
  " but it is no problem basically.
  let search_off = direction > 0 ? 0 : -2
  if charsearch.until
    let search_off += direction
  endif
  let s:searcher = direction > 0 ? function('stridx') : function('strridx')

  if s:smart
    " search upper case
    let u_char = mi#utils#upper_key(char)
    let u_col = s:searcher(line, u_char, col + search_off) + 1
    if char ==# u_char
      " if input char is already upper case, skip lower case
      let l_col = 0
    else
      " if input char is lower case, search it
      let l_col = s:searcher(line, char, col + search_off) + 1
    endif
  else
    let l_col = s:searcher(line, char, col + search_off) + 1
    let u_col = 0
  endif

  if l_col == 0 && u_col == 0
    " not found
    return
  elseif u_col == 0
    " lower found
    let col = l_col
    let charsearch.char = char
  elseif l_col == 0
    " upper found
    let col = u_col
    let charsearch.char = u_char
  elseif l_col * direction < u_col * direction
    " lower found
    let col = l_col
    let charsearch.char = char
  else
    " upper found
    let col = u_col
    let charsearch.char = u_char
  endif

  call setcharsearch(charsearch)

  if charsearch.until
    let col -= direction
  endif
  if direction > 0 && mode(1) =~ 'o'
    let col += 1
    if col >= col('$')
      " to focus last character of line
      let save_ve = &virtualedit
      set virtualedit=onemore
      execute 'autocmd ModeChanged * ++once set virtualedit=' .. save_ve
    endif
  endif
  call cursor(lnum, col)
endfunction

function! s:ft_start(key, smart) abort
  if a:key !=? 'f' && a:key !=? 't'
    return
  endif

  if !exists('g:mi#dot_repeating')
    let char = nr2char(getchar())
    if char !~ '\p'
      return
    endif

    let forward = a:key ==# 'f' || a:key ==# 't'
    let until = a:key ==? 't'
    call setcharsearch({'forward': forward, 'char': char, 'until': until})
    let s:lastchar = char
    let s:smart = a:smart
  endif

  call mi#ft#repeat(';')
endfunction

function! mi#ft#exact(starter) abort
  call s:ft_start(a:starter, 0)
endfunction

function! mi#ft#smart(starter) abort
  call s:ft_start(a:starter, 1)
endfunction
