function! mi#qf#is_qf_buf() abort
  return &l:buftype ==# 'quickfix'
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

function! mi#qf#add_curpos() abort
  caddexpr join([expand('%'), line('.'), col('.'), trim(getline('.'))], ':')
endfunction

" https://stackoverflow.com/a/48817071
function! mi#qf#remove() abort
  let qf_info = getqflist({ 'idx': 1, 'size': 1 })
  if qf_info.size < 2
    call mi#qf#clear()
    return
  endif

  if mi#qf#is_qf_buf()
    let idx = line('.') - 1
  else
    let idx = qf_info.idx - 1
  endif

  let qfall = getqflist()
  call remove(qfall, idx)
  call setqflist(qfall, 'r')
  copen

  if mi#qf#is_qf_buf()
    call mi#qf#fit_window()
    execute 'normal! ' .. (idx + 1) .. 'G'
  endif
endfunction

let s:fit_window_size = [3, 10]
function! mi#qf#fit_window(size = {}) abort
  let size_min = get(a:size, 'min', s:fit_window_size[0])
  let size_max = get(a:size, 'max', s:fit_window_size[1])
  let s:fit_window_size = [size_min, size_max]
  execute 'resize' min([max([size_min, getqflist({ 'size': 1 }).size]), size_max])
endfunction

function! mi#qf#quit_if_last_buf() abort
  if winnr('$') == 1 && mi#qf#is_qf_buf()
    quit
  endif
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
function! mi#qf#preview() abort
  let item = mi#qf#get_current_item()
  if empty(item)
    return
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
    execute 'autocmd WinClosed,WinLeave <buffer> silent! pclose | if win_getid() ==' win_getid() '| wincmd w | endif'
  endif
endfunction
