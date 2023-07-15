function! s:exit_visual_mode() abort
  let m = mode()
  if m ==? 'v' || m == "\<C-v>"
    execute 'normal!' m
  endif
endfunction

" https://zenn.dev/kawarimidoll/articles/665dbd860c72cd
function! mi#textobject#outline(params = {}) abort
  let from_parent = get(a:params, 'from_parent', 0)
  let with_blank = get(a:params, 'with_blank', 0)

  " get current line and indent
  let from = line('.')
  let indent = indent(from)
  if indent < 0
    return
  endif
  let to = from

  " search first parent
  if from_parent && from > 1 && indent > 0
    let lnum = from - 1
    while indent <= indent(lnum) || (with_blank && getline(lnum) =~ '^\s*$')
      let lnum -= 1
    endwhile

    " update current line and indent
    let from = lnum
    call cursor(from, 0)
    let indent = indent(from)
  endif

  " search last child
  let lnum = to + 1
  while indent < indent(lnum) || (with_blank && getline(lnum) =~ '^\s*$')
    let to = lnum
    let lnum += 1
  endwhile

  call s:exit_visual_mode()

  " select with line-visual mode
  normal! V
  call cursor(to, 0)
  normal! o
endfunction

" https://github.com/kana/vim-textobj-line
function! mi#textobject#line(params = {}) abort
  let no_trim = get(a:params, 'no_trim', 0)

  call s:exit_visual_mode()

  " select with visual mode
  execute 'normal!' (no_trim ? '0' : '^') .. 'v' .. (no_trim ? '$' : 'g_')
endfunction

" https://github.com/kana/vim-textobj-entire
function! mi#textobject#entire(params = {}) abort
  let charwise = get(a:params, 'charwise', 0)

  call s:exit_visual_mode()

  " select with visual/line-visual mode
  execute 'normal!' 'gg0' (charwise ? 'v' : 'V') .. 'G$'
endfunction

" https://github.com/saihoooooooo/vim-textobj-space/blob/master/plugin/textobj/space.vim
function! mi#textobject#space(params = {}) abort
  let with_tab = get(a:params, 'with_tab', 0)
  let pattern = with_tab ? '\s' : ' '
  call s:select_by_char_pattern(pattern)
endfunction

function! mi#textobject#alphabet(params = {}) abort
  let with_num = get(a:params, 'with_num', 0)
  let pattern = with_num ? '\(\a\|\d\)' : '\a'
  call s:select_by_char_pattern(pattern)
endfunction

function! mi#textobject#fname() abort
  let pattern = '\(\f\|:\)'
  call s:select_by_char_pattern(pattern)
endfunction

" https://github.com/gilligan/textobj-lastpaste
function! mi#textobject#lastpaste() abort
  call s:exit_visual_mode()
  normal! `[v`]
endfunction

" https://github.com/kana/vim-textobj-datetime
function! mi#textobject#datetime() abort
  call s:exit_visual_mode()

  let patterns = [
        \  [
        \    '\(\d\d\d\d[-_/]\)\?\d\d[-_/]\d\d',
        \    '[^-_/0-9]',
        \  ],
        \  [
        \    '\d\d\:\d\d\(:\d\d\)\?',
        \    '[^:0-9]',
        \  ],
        \]

  for [pat, not_pat] in patterns
    let [lnum, col] = searchpos(pat, 'bcn', line('.'))
    if lnum == 0 || col < searchpos(not_pat, 'bcn', line('.'))[1]
      continue
    endif
    call cursor(lnum, col)
    normal! v
    call searchpos(pat, 'ce', line('.'))
    break
  endfor
endfunction

function! mi#textobject#between(char, around) abort
  let char = a:char
  if stridx('^$[.*\', char) > 0
    let char = '\' .. char
  endif
  let left_limit = char .. '[^' .. a:char .. ']'
  let right_limit = '[^' .. a:char .. ']' .. char

  if searchpos(left_limit, 'cnb', line('w0'))[1] == 0
    return
  endif
  if searchpos(right_limit, 'n', line('w$'))[1] == 0
    return
  endif

  call s:exit_visual_mode()

  call search(a:char, 'scb', line('w0'))
  if !a:around
    normal! l
  endif
  normal! v
  call search(a:char, 'e', line('w$'))
  if !a:around
    normal! h
  endif
endfunction

function! s:select_by_char_pattern(pattern) abort
  let col = searchpos(a:pattern, 'cn', line('w$'))[1]
  if col == 0
    return
  endif

  call s:exit_visual_mode()

  let pattern = a:pattern .. '\+'
  let b_flag = col > getpos('.')[2] ? '' : 'b'
  call search(pattern, 'sc' .. b_flag)
  normal! v
  call search(pattern, 'ce')
endfunction

function! s:select_pair(stop_line) abort
  const open_pos = searchpos('[([{]', 'bcW')
  if open_pos[0] ==# 0
    " not found
    return [[0, 0], [0, 0]]
  endif

  " :h match-parens
  let c = getline(open_pos[0])[open_pos[1] - 1]
  const plist = split(&matchpairs, ':\|,')
  const i = index(plist, c)
  if i < 0
    return
  endif
  let s_flags = 'W'
  if i % 2 == 0
    let c2 = plist[i + 1]
  else
    let s_flags ..= 'b'
    let c2 = c
    let c = plist[i - 1]
  endif
  if c == '['
    let c = '\['
    let c2 = '\]'
  endif

  const close_pos = searchpairpos(c, '', c2, s_flags)

  if open_pos[0] ==# close_pos[0] && open_pos[1] ==# close_pos[1]
    " not found
    return [[0, 0], [0, 0]]
  endif
  return [open_pos, close_pos]
endfunction

function! mi#textobject#pair(i_or_a) abort
  if a:i_or_a !=# 'i' && a:i_or_a !=# 'a'
    throw 'invalid parameter. use i or a'
  endif

  const stop_line = line("w0")
  const current_pos = getpos('.')[1:2]
  const saved_view = winsaveview()

  let break_idx = 0
  while v:true
    let [open_pos, close_pos] = s:select_pair(stop_line)
    if open_pos[0] ==# 0
      " not found
      call winrestview(saved_view)
      return
    endif
    call cursor(open_pos)
    if mi#utils#pos_gt(current_pos, close_pos, v:true)
      break
    endif
    if open_pos[1] > 1
      normal! h
    else
      normal! k$
    endif
    let break_idx += 1
    if break_idx > 100
      call winrestview(saved_view)
      throw 'too many roop!'
    endif
  endwhile

  call s:exit_visual_mode()

  if open_pos[0] ==# close_pos[0]
    " use nomal mapping like vi(
    execute 'normal! v' .. a:i_or_a .. mi#utils#get_char_at('.')
    return
  endif

  normal! v
  call cursor(close_pos)

  if a:i_or_a ==# 'i'
    normal! oloh
  endif
endfunction

function! s:select_quote(stop_line) abort
  const open_pos = searchpos('["`'']', 'bcW')
  if open_pos[0] ==# 0
    " not found
    return [[0, 0], [0, 0]]
  endif

  let c = getline(open_pos[0])[open_pos[1] - 1]
  let s_flags = 'W'

  const close_pos = searchpos(c, s_flags)

  if open_pos[0] ==# close_pos[0] && open_pos[1] ==# close_pos[1]
    " not found
    return [[0, 0], [0, 0]]
  endif
  return [open_pos, close_pos]
endfunction

function! mi#textobject#quote(i_or_a) abort
  if a:i_or_a !=# 'i' && a:i_or_a !=# 'a'
    throw 'invalid parameter. use i or a'
  endif

  const stop_line = line("w0")
  const current_pos = getpos('.')[1:2]

  let current_char = mi#utils#get_char_at('.')

  " when cursor is on quote char
  if current_char =~# '["`'']'
    call s:exit_visual_mode()
    " use nomal mapping like vi'
    execute 'normal! v' .. a:i_or_a .. current_char

    " trim spaces around quotes
    if a:i_or_a ==# 'a'
      normal! o
      let current_char = mi#utils#get_char_at('.')
      if current_char =~ '\s'
        call search('["`'']', 'W')
      endif
      normal! o
      let current_char = mi#utils#get_char_at('.')
      if current_char =~ '\s'
        call search('["`'']', 'bW')
      endif
    endif

    return
  endif

  const saved_view = winsaveview()

  let break_idx = 0
  while v:true
    let [open_pos, close_pos] = s:select_quote(stop_line)
    if open_pos[0] ==# 0
      " not found
      call winrestview(saved_view)
      return
    endif
    call cursor(open_pos)
    if mi#utils#pos_gt(current_pos, close_pos, v:true)
      break
    endif
    if open_pos[1] > 1
      normal! h
    else
      normal! k$
    endif
    let break_idx += 1
    if break_idx > 100
      call winrestview(saved_view)
      throw 'too many roop!'
    endif
  endwhile

  call s:exit_visual_mode()

  normal! v
  call cursor(close_pos)

  if a:i_or_a ==# 'i'
    normal! oloh
  endif
endfunction
