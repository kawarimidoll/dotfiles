" respect https://github.com/itchyny/vim-qfedit

let s:qed_setlocal = {-> execute('setlocal modifiable nomodified noswapfile')}
let s:is_loc = {-> get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)}
let s:getlist = {-> s:is_loc() ? getloclist(0) : getqflist()}
let s:setlist = {items -> s:is_loc() ? setloclist(0, items) : setqflist(items)}
let s:delpat = {str, pattern -> substitute(str, pattern, '', '')}

function s:extract(str, pattern) abort
  let found = matchstr(a:str, a:pattern)
  return [found, s:delpat(a:str, found .. '\s*')]
  " return [found, s:delpat(a:str, found)]->map('trim(v:val)')
endfunction

function s:parseline(line) abort
  let [mid, text] = s:extract(a:line, '^[^|]*|[^|]*|')
  let [filename, mid; _rest] = split(mid, '\s*|\s*', v:true)
  let bufnr = empty(filename) ? 0 : bufnr(filename)
  if bufnr < 1
    unlet bufnr
  endif
  let [part, mid] = s:extract(mid, '\v^\d+%(-\d+)?')
  let [lnum, end_lnum; _rest] = split(part, '-') + ['', '']
  let [part, mid] = s:extract(mid, '\v^col\s*\d+%(-\d+)?')
  let [col, end_col; _rest] = split(s:delpat(part, '^col\s*'), '-') + ['', '']
  let [type, nr; _rest] = split(mid, '\s\+') + ['', '']
  unlet mid part _rest
  return l:
endfunction

function s:on_change() abort
  defer setpos('.', getcurpos())
  let items = []
  for item in getline(1, '$')
    try
      call add(items, s:parseline(item))
    catch
      " skip add() if s:parseline() throws error
    endtry
  endfor
  call s:setlist(items)
  call s:qed_setlocal()
endfunction

function mi#qed#start() abort
  call s:qed_setlocal()
  augroup qed_change
    autocmd! TextChanged <buffer> keepjump call s:on_change()
  augroup END
endfunction

" let line = 'qed.vim|2-10 col 1-5| function s:ok() abort'
" let line = 'qed.vim|col 1-5| function s:ok() abort'
" let line = 'qed.vim|2-10 col 1-5 error  3| function s:ok() abort'
" let line = 'qed.vim|| function s:ok() abort'
" let line = '|error  3| function s:ok() abort'
" let line = 'qed.vim|2-3|'
" let line = 'qed.vim|2-3| if a || b'
" echo s:parseline(line)
