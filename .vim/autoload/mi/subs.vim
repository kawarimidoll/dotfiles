" :h pattern-delimiter
let s:delimiter_pattern = "[!@$%^&*()=+~`',.;:<>/?_-]"

function! s:echoerr(msg) abort
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

function! s:make_cases(str) abort
  const words = split(a:str, '[^[:alnum:]]\|\ze\u\l')
  const snake = tolower(join(words, '_'))
  const scream = toupper(snake)
  const kebab = substitute(snake, '_', '-', 'g')
  const dots = substitute(snake, '_', '.', 'g')
  const camel = substitute(snake, '_\(.\)', '\u\1', 'g')
  const pascal = substitute(camel, '.', '\u\0', '')
  return [snake, scream, kebab, dots, camel, pascal]
endfunction

function! mi#subs#titute(line1, line2, args) abort
  const delimiter = a:args[0]
  if delimiter !~# s:delimiter_pattern
    return s:echoerr(printf('[mi#subs] invalid delimiter: %s. see :h E146', delimiter))
  endif

  const args = split(a:args, delimiter)
  if a:args[1] ==# delimiter
    " use last search pattern
    call insert(args, getreg('/'))
  endif
  const from = get(args, 0, '')
  const to = get(args, 1, '')
  const flags = get(args, 2, '')

  if empty(from) || empty(to)
    return s:echoerr('[mi#subs] arguments required. see :h E471')
  elseif !empty(get(args, 3, ''))
    return s:echoerr('[mi#subs] trailling characters. see :h E488')
  endif

  if flags =~# 'j'
    for i in range(a:line1, a:line2)
      let new_line = mi#subs#cased(getline(i), from, to, substitute(flags, 'j', '', 'g'))
      call setline(i, new_line)
    endfor
    return
  endif

  execute join([
        \ printf('%s,%s substitute', a:line1, a:line2),
        \ from,
        \ to,
        \ flags
        \ ], delimiter)
endfunction

augroup mi#subs#cased
  autocmd!
augroup END
function! mi#subs#cased(line, from, to, flags) abort
  if get(g:, '_subs_last_from', '') !=# a:from || get(g:, '_subs_last_to', '') !=# a:to
    let g:_subs_last_from = a:from
    let g:_subs_last_to = a:to
    const from_cases = s:make_cases(a:from)
    const to_cases = s:make_cases(a:to)
    let g:_subs_case_dict = {}
    for i in range(len(from_cases))
      let g:_subs_case_dict[from_cases[i]] = to_cases[i]
    endfor
    autocmd! mi#subs#cased
    autocmd mi#subs#cased CmdlineLeave : ++once
          \ unlet! g:_subs_case_dict g:_subs_last_from g:_subs_last_to
  endif

  return substitute(
        \ a:line,
        \ printf('\C%s', join(from_cases, '\|')),
        \ printf('\=get(g:_subs_case_dict, submatch(0), submatch(0))'),
        \ a:flags)
endfunction

command! -range -nargs=+ Substitute call mi#subs#titute(<line1>, <line2>, <q-args>)

" two_love TWO_LOVE TwoLove twoLove two-love two.love
" TWO_TIME TwoTime twoTime two-time two_time
" two_time TWO_TIME twoTime two-time TwoTime
" two_time TwoTime twoTime two-time TWO_TIME
