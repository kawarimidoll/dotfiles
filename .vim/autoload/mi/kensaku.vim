let s:inc = v:false
let s:last_query = ''
let s:last_converted_query = ''

function! s:add_highlights() abort
  call s:clear_highlights()
  let query = s:last_converted_query
  if query != ''
    let hlgroup = s:inc ? 'IncSearch' : 'Search'
    let s:match_id = matchadd(hlgroup, query)
  endif
endfunction

function! s:clear_highlights() abort
  silent! call matchdelete(s:match_id)
endfunction

function! s:convert_query(query) abort
  if a:query == ''
    return ''
  endif
  let args = get(g:, 'kensaku#args', '')
  let query = system(printf('jsmigemo --vim --nonewline %s --word %s', args, a:query))

  " fix output of jsmigemo-cli for vim
  let query = substitute(query, '\n', '', 'g')
  let query = substitute(query, '\\\\)', '\\)', 'g')
  let query = substitute(query, '\\{', '{', 'g')
  let query = substitute(query, '\\}', '}', 'g')
  let query = substitute(query, '\\+', '+', 'g')

  let s:last_converted_query = query
  return query
endfunction

function! s:on_input() abort
  let s:last_query = getcmdline()
  if s:last_query == ''
    call s:clear_highlights()
    redraw
    return
  endif

  try
    let query = s:convert_query(s:last_query)
    let flg = s:back ? 'cb' : 'c'
    call cursor(s:curpos[0], s:curpos[1])
    call search(query, flg)
    call s:add_highlights()
  catch
    echoerr v:exception
    echoerr query
    throw v:exception
  endtry

  redraw
endfunction

function! s:on_leave() abort
  let s:enabled = v:false
  call s:clear_highlights()
  autocmd! kensaku_augroup
endfunction

function! s:on_enter() abort
  let s:enabled = v:true
  call s:on_input()
endfunction

function! s:prompt() abort
  return '󱌱 ' .. (s:back ? '?' : '/')
endfunction

function! mi#kensaku#clear() abort
  call s:clear_highlights()
endfunction

function! mi#kensaku#next(back) abort
  let s:back = a:back
  execute 'normal!' v:count1 .. (a:back ? 'N' : 'n')
  if @/ == s:last_converted_query
    echo s:prompt() .. s:last_query
  endif
  if &hlsearch
    call feedkeys("\<cmd>let v:hlsearch=1\<cr>", 'n')
  endif
endfunction

function! mi#kensaku#last_query() abort
  return s:last_query
endfunction

" function! mi#kensaku#toggle() abort
"   let cmdtype = getcmdtype()
"   if get(s:, 'enabled', v:false)
"     call feedkeys("\<esc>", 'nt')
"     execute 'normal! /' .. s:last_query
"     return
"   endif
"   if cmdtype == '/' || cmdtype == '?'
"     call mi#kensaku#start({ 'init': substitute(getcmdline(), '\\v', '', 'g') })
"   endif
" endfunction

function! mi#kensaku#start(opts = {}) abort
  let win_view_dict = winsaveview()
  let s:curpos = getpos('.')[1:2]

  augroup kensaku_augroup
    autocmd CmdlineEnter @ call s:on_enter()
    autocmd CmdlineChanged @ call mi#utils#debounce(funcref('s:on_input'), 10)
  augroup END
  autocmd CmdlineLeave @ ++once call s:on_leave()

  let s:inc = v:true
  let s:back = get(a:opts, 'back', v:false)
  let query = input(s:prompt(), get(a:opts, 'init', ''))
  let s:inc = v:false

  if query == ''
    " cancelled
    call s:clear_highlights()
    call winrestview(win_view_dict)
    call cursor(s:curpos[0], s:curpos[1])
    return
  endif

  let @/ = s:last_converted_query
  if &hlsearch
    call feedkeys("\<cmd>let v:hlsearch=1\<cr>", 'n')
  endif
endfunction

let g:kensaku#args = '--dict ~/.local/share/jsmigemo/no-abbrev-compact-dict'
nnoremap J/ <cmd>call mi#kensaku#start()<cr>
nnoremap J? <cmd>call mi#kensaku#start({ 'init': mi#kensaku#last_query() })<cr>
nnoremap n <cmd>call mi#kensaku#next(0)<cr>
nnoremap N <cmd>call mi#kensaku#next(1)<cr>
" cnoremap <c-j> <cmd>call mi#kensaku#toggle()<cr>
