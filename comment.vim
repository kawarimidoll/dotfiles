function! s:get_range() abort
  let from = line('.')
  let to = line('v')
  if from > to
    let [from, to] = [to, from]
  endif
  return [from, to]
endfunction

function! s:get_comment_pair() abort
  let pair = split(&commentstring, '%s')
  return [pair[0], get(pair, 1, '')]
endfunction

function! s:is_comment() abort
  let line = getline('.')
  let [open, close] = s:get_comment_pair()
  return line =~ '^\s*' .. open .. '.*' .. close .. '\s*$'
endfunction

function! s:comment_on() abort
  let [from, to] = s:get_range()
  let lines = getline(from, to)
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

function! s:comment_off() abort
  let [open, close] = s:get_comment_pair()
  let [from, to] = s:get_range()
  let lines = getline(from, to)
  let lnum = from
  for line in lines
    let line = substitute(line, open .. '\s\?', '', '')
    let line = substitute(line, '\s*' .. close .. '\s*$', '', '')
    call setline(lnum, line)
    let lnum += 1
  endfor
endfunction

function! s:comment_toggle() abort
  if s:is_comment()
    call s:comment_off()
  else
    call s:comment_on()
  endif
endfunction

nnoremap gcc <Cmd>call <sid>comment_toggle()<CR>
xnoremap gcc <Cmd>call <sid>comment_toggle()<CR>
