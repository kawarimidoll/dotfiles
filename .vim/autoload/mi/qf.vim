function! mi#qf#grep(word) abort
  cgetexpr system(printf('%s %s', &grepprg, a:word))

  if getqflist({ 'size': 1 }).size != 0
    call setqflist([], 'r', {'title': a:word})
    copen
    silent! doautocmd QuickFixCmdPost grep
  else
    echo 'grep: no matches found.'
    cclose
  endif
endfunction

function! mi#qf#lgrep(word) abort
  lgetexpr system(printf('%s %s', &grepprg, a:word))

  if len(getloclist(0)) != 0
    call setloclist(0, [], 'r', {'title': a:word})
    lopen
    silent! doautocmd QuickFixCmdPost lgrep
  else
    echo 'lgrep: no matches found.'
    lclose
  endif
endfunction

function! mi#qf#cycle(count) abort
  let qf_info = getqflist({ 'all': 1 })
  if qf_info.size == 0
    return
  endif

  let num = (qf_info.idx + qf_info.size + a:count) % qf_info.size

  if num == 0
    let num = qf_info.size
  endif

  execute num .. 'cc'
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

  if &filetype == 'qf'
    let idx = line('.') - 1
  else
    let idx = qf_info.idx - 1
  endif

  let qfall = getqflist()
  call remove(qfall, idx)
  call setqflist(qfall, 'r')
  copen

  if &filetype == 'qf'
    execute 'normal! ' .. (idx + 1) .. 'G'
  endif
endfunction

let s:fit_window_size = [3, 10]
function! mi#qf#fit_window(size = {})
  let size_min = get(a:size, 'min', s:fit_window_size[0])
  let size_max = get(a:size, 'max', s:fit_window_size[1])
  let s:fit_window_size = [size_min, size_max]
  execute 'resize' min([max([size_min, getqflist({ 'size': 1 }).size]), size_max])
endfunction

function! mi#qf#quit_if_last_buf()
  if winnr('$') == 1 && &buftype == 'quickfix'
    quit
  endif
endfunction
