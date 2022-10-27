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

  " exit visual mode
  let m = mode()
  if m ==# 'v' || m ==# 'V' || m == "\<C-v>"
    execute 'normal! ' .. m
  endif

  " select with line-visual mode
  normal! V
  call cursor(to, 0)
  normal! o
endfunction
