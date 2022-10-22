function! s:get_comment_pair() abort
  let pair = split(&commentstring, '%s')
  return [pair[0], get(pair, 1, '')]
endfunction

function! s:is_comment(lnum) abort
  return synIDattr(synID(a:lnum, 1, 1), 'name') =~ 'comment'
endfunction

function! s:comment_on(from, to) abort
  let lines = getline(a:from, a:to)
  let min_indent = lines[0]
  for line in lines
    if line =~ '^\s*$'
      continue
    endif
    let current_indent = matchstr(line, '\s*')
    if len(current_indent) >= len(min_indent)
      continue
    endif
    let min_indent = current_indent
    if min_indent == ''
      break
    endif
  endfor
  "let indent = indent(a:from)
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
  if close =~ '^\S'
    let close = ' ' .. close
  endif

  let indent_len = len(min_indent)
  let lnum = a:from
  for line in lines
    call setline(lnum, min_indent .. trim(open .. line[indent_len:] .. close))
    let lnum += 1
  endfor
endfunction

function! s:comment_off(from, to) abort
  let [open, close] = s:get_comment_pair()
  let lines = getline(a:from, a:to)
  let lnum = a:from
  for line in lines
    let line = substitute(line, open .. '\s\?', '', '')
    let line = substitute(line, '\s*' .. close .. '\s*$', '', '')
    call setline(lnum, line)
    let lnum += 1
  endfor
endfunction

function! s:operator_comment_toggle(type = '') abort
  if a:type == ''
    let &operatorfunc = function('s:operator_comment_toggle')
    return 'g@'
  endif

  let from = line("'[")
  let to = line("']")
  if from > to
    let [from, to] = [to, from]
  endif

  if s:is_comment(get(s:, 'cursorline', line('.')))
    call s:comment_off(from, to)
  else
    call s:comment_on(from, to)
  endif
endfunction

function! mi#comment#operator_toggle() abort
  let s:cursorline = line('.')
  return s:operator_comment_toggle()
endfunction
