function! mi#qf#is_qf_buf() abort
  return &l:buftype ==# 'quickfix'
endfunction

function! s:post_grep(add, old_size)
  let size = getqflist({'size': 1}).size
  if size != a:old_size
    echo printf('[grep] %s hits found.', size - a:old_size)
    execute printf('silent! doautocmd QuickFixCmdPost grep%s', a:add ? 'add' : '')
  else
    echo '[grep] no matches found.'
    if size == 0
      cclose
    endif
  endif
endfunction

function! mi#qf#async_grep(query, opts = {}) abort
  let title = 'Grep'
  " let addexpr = 'caddexpr data | copen'
  " let get_list = function('getqflist')
  " let set_list = function('setqflist')
  let is_loc = get(a:opts, 'loc', 0)
  if is_loc
    echoerr 'currently not supported'
    " let title = 'L' .. title
    " let addexpr = 'laddexpr data | lopen'
    " let get_list = function('getloclist', [0])
    " let set_list = function('setloclist', [0])
  endif

  let fix_query = get(a:opts, 'fixed', 0)
  if fix_query
    let title ..= 'F'
  endif

  let add_qf = get(a:opts, 'add', 0)
  if add_qf
    let title ..= '!'
    let size = getqflist({'size': 1}).size
  else
    call setqflist([], 'r')
    let size = 0
  endif
  call setqflist([], 'r', {'title': title .. ' ' .. a:query})

  copen
  let cmd = split(&grepprg, ' ')
  if &smartcase
    call add(cmd, '--smart-case')
  elseif &ignorecase
    call add(cmd, '--ignore-case')
  endif
  if fix_query
    call add(cmd, '--fixed-strings')
    call add(cmd, '--')
  endif
  call add(cmd, a:query)
  call mi#job#start(cmd, {
        \ 'out': {data->execute('caddexpr filter(data, ''!empty(v:val)'')')},
        \ 'exit': {data->s:post_grep(add_qf, size)},
        \ })
endfunction

function! mi#qf#grep(add, word) abort
  if a:add
    caddexpr system(printf('%s %s', &grepprg, a:word))
  else
    cgetexpr system(printf('%s %s', &grepprg, a:word))
  endif

  if getqflist({ 'size': 1 }).size != 0
    call setqflist([], 'r', {'title': a:word})
    copen
    silent! doautocmd QuickFixCmdPost grep
  else
    echo 'grep: no matches found.'
    cclose
  endif
endfunction

function! mi#qf#lgrep(add, word) abort
  if a:add
    laddexpr system(printf('%s %s', &grepprg, a:word))
  else
    lgetexpr system(printf('%s %s', &grepprg, a:word))
  endif

  if len(getloclist(0)) != 0
    call setloclist(0, [], 'r', {'title': a:word})
    lopen
    silent! doautocmd QuickFixCmdPost lgrep
  else
    echo 'lgrep: no matches found.'
    lclose
  endif
endfunction

function! s:qf_cycle(direction, cnt) abort
  if getqflist({ 'size': 1 }).size == 0
    echo '[qf#cycle] no items.'
    return
  endif

  if a:direction == 'next'
    let cmd = 'cnext'
    let cycle_cmd = 'cfirst'
  else
    let cmd = 'cprevious'
    let cycle_cmd = 'clast'
  endif

  for i in range(a:cnt)
    try
      execute cmd
    catch /^Vim\%((\a\+)\)\=:E553/
      execute cycle_cmd
    endtry
  endfor
endfunction
function! mi#qf#cycle_p(cnt = v:count1) abort
  call s:qf_cycle('previous', a:cnt)
endfunction
function! mi#qf#cycle_n(cnt = v:count1) abort
  call s:qf_cycle('next', a:cnt)
endfunction

function! mi#qf#from_loc() abort
  let loc_info = getloclist(0, {'title':1, 'size':1})
  if loc_info.size == 0
    return
  endif
  call setqflist(getloclist(0), 'r')
  call setqflist([], 'r', {'title': loc_info.title})
endfunction

function! mi#qf#clear() abort
  call setqflist([], 'r')
  cclose
endfunction

" https://github.com/drmingdrmer/vim-toggle-quickfix/blob/master/autoload/togglequickfix.vim
function! mi#qf#toggle() abort
  let qf_info = getqflist({ 'winid': 1, 'size': 1 })

  if qf_info.winid == 0 && qf_info.size != 0
    copen
  else
    cclose
  endif
endfunction

function! mi#qf#add(line1, line2, allow_blank) abort
  let filename = expand('%:p')
  let list = []

  for lnum in range(a:line1, a:line2)
    let text = getline(lnum)
    if !a:allow_blank
      let text = trim(text)
      if text == ''
        continue
      endif
    endif
    call add(list, {'filename': filename, 'lnum': lnum, 'text': text})
  endfor

  call setqflist(list, 'a')
endfunction
command! -range -bang Qfadd call mi#qf#add(<line1>, <line2>, <bang>0)

" https://stackoverflow.com/a/48817071
function! mi#qf#remove() abort
  const qf_info = getqflist({ 'idx': 1, 'size': 1 })
  if qf_info.size < 2
    call mi#qf#clear()
    return
  endif

  const qfidx = mi#qf#is_qf_buf() ? line('.') : qf_info.idx
  const qfall = getqflist()
  call remove(qfall, qfidx - 1)
  call setqflist(qfall, 'r')
  copen

  if mi#qf#is_qf_buf()
    call mi#qf#fit_window()
    execute 'normal! ' .. qfidx .. 'G'
  endif
endfunction

let s:fit_window_size = [3, 10]
function! mi#qf#fit_window(size = {}) abort
  const size_min = get(a:size, 'min', s:fit_window_size[0])
  const size_max = get(a:size, 'max', s:fit_window_size[1])
  " save latest size
  let s:fit_window_size = [size_min, size_max]
  execute 'resize' min([max([size_min, getqflist({ 'size': 1 }).size]), size_max])
endfunction


function! mi#qf#get_current_item() abort
  try
    if mi#qf#is_qf_buf()
      return getqflist()[line('.') - 1]
    endif
  catch
    " do nothing
  endtry
  return {}
endfunction

let s:preview_highlights = []
let s:unlisted_buffers = []
function! mi#qf#preview() abort
  let item = mi#qf#get_current_item()
  if empty(item)
    return
  endif

  if !buflisted(item.bufnr)
    call add(s:unlisted_buffers, item.bufnr)
  endif
  let fname = bufname(item.bufnr)
  silent! noautocmd execute 'aboveleft pedit' fname
  silent! noautocmd wincmd P
  doautocmd BufRead
  let height = get(g:, 'mi#qf#preview#size', 7)
  execute 'resize' height
  execute 'setlocal scrolloff=' .. height
  execute item.lnum

  for match_id in s:preview_highlights
    silent! call matchdelete(match_id)
  endfor
  let s:preview_highlights = []
  if item.end_lnum && item.end_col
    " TODO: highlight multi-line range
    call add(s:preview_highlights, matchaddpos('Visual', [[item.lnum, item.col, item.end_col - item.col]]))
  else
    call add(s:preview_highlights, matchaddpos('Visual', [item.lnum]))
    call add(s:preview_highlights, matchaddpos('Search', [[item.lnum, item.col]]))
  endif

  silent! noautocmd wincmd p

  let qf_id = getqflist({ 'id': 1 }).id
  if get(s:, 'au_qf_id') != qf_id
    nnoremap <buffer> <cr> <cmd>pclose<cr><cr>
    let s:au_qf_id = qf_id
    autocmd CursorMoved <buffer> call mi#qf#preview()
    autocmd WinClosed,WinLeave <buffer> call s:on_leave_preview()
  endif
endfunction
function! s:on_leave_preview() abort
  let current_id = win_getid()
  silent! pclose
  if win_getid() == current_id
    wincmd w
  endif
  for bufnr in s:unlisted_buffers
    execute 'silent! bdelete!' bufnr
  endfor
  let s:unlisted_buffers = []
endfunction
