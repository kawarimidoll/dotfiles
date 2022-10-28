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
