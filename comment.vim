function! s:get_range(from, to) abort
  let from = a:from
  let to = a:to

  let another = line('v')
  if from == to && from != another
    if another < from
      let from = another
    else
      let to = another
    endif
  endif
  return [from, to]
endfunction

function! s:get_comment_pair() abort
  let pair = split(&commentstring, '%s')
  return [pair[0], get(pair, 1, '')]
endfunction

function! s:is_comment(lnum) abort
  let line = getline(a:lnum)
  let [open, close] = s:get_comment_pair()
  return line =~ '^\s*' .. open .. '.*' .. close .. '\s*$'
endfunction

function! s:comment_on(line1, line2) abort
  let [from, to] = s:get_range(a:line1, a:line2)
  let lines = getline(from, to)
  "let line = substitute(line, '^\(\s*\)\(.*\)', '\=submatch(1) .. printf(&commentstring, submatch(2))', '')
  "call setline('.', line)

  let min_indent = lines[0]
  for line in lines
    let current_indent = matchstr(line, '\s*')
    if len(current_indent) == len(line)
      continue
    endif
    if len(current_indent) >= len(min_indent)
      continue
    endif
    let min_indent = current_indent
    if min_indent == ''
      break
    endif
  endfor
  "let indent = indent(from)
  "let idx = 1
  "while indent > 0 && idx < len(lines)
  "  if line =~ '^\s*$'
  "    continue
  "  endif
  "  if indent >= indent(lines[idx])
  "    continue
  "  endif
  "  let indent = indent(lines[idx])
  "  let idx += 1
  "endwhile

  let [open, close] = s:get_comment_pair()
  if open =~ '\S$'
    let open ..= ' '
  endif

  let indent_len = len(min_indent)
  let lnum = from
  for line in lines
    call setline(lnum, min_indent .. trim(open .. line[indent_len:] .. close))
    let lnum += 1
  endfor
endfunction

function! s:comment_off(line1, line2) abort
  let [open, close] = s:get_comment_pair()
  " let line = getline('.')
  " let line = substitute(line, '^\(\s*\)' .. open .. '\s*', '\1', '')
  " let line = substitute(line, '\s*' .. close .. '\s*$', '', '')
  " call setline('.', line)

  let [from, to] = s:get_range(a:line1, a:line2)
  let lines = getline(from, to)
  let lnum = from
  for line in lines
    let line = substitute(line, open .. '\s\?', '', '')
    let line = substitute(line, '\s*' .. close .. '\s*$', '', '')
    call setline(lnum, line)
    let lnum += 1
  endfor
endfunction

function! s:comment_toggle(line1, line2) abort
  " let m = mode()
  " let from = line('.')
  " let to = (m ==? 'v' || m == "\<C-v>") ? line('v') : line('.')
  " if from > to
  "   let [from, to] = [to, from]
  " endif

  if s:is_comment(a:line1)
    call s:comment_off(a:line1, a:line2)
  else
    call s:comment_on(a:line1, a:line2)
  endif
endfunction

command! -range CommentToggle call s:comment_toggle(<line1>, <line2>)
nnoremap gcc <Cmd>CommentToggle<CR>
xnoremap gcc <Cmd>CommentToggle<CR>
