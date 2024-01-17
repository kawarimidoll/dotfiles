let s:key_table = {
      \  '`': '~',
      \  '1': '!',
      \  '2': '@',
      \  '3': '#',
      \  '4': '$',
      \  '5': '%',
      \  '6': '^',
      \  '7': '&',
      \  '8': '*',
      \  '9': '(',
      \  '0': ')',
      \  '-': '_',
      \  '=': '+',
      \  '[': '{',
      \  ']': '}',
      \  '\': '|',
      \  ';': ':',
      \  "'": '"',
      \  ',': '<',
      \  '.': '>',
      \  '/': '?',
      \  }

function! mi#utils#update_key_table(key_table) abort
  let s:key_table = a:key_table
endfunction

function! mi#utils#upper_key(key) abort
  return get(s:key_table, a:key, toupper(a:key))
endfunction

function! mi#utils#lower_key(key) abort
  if !exists('s:key_table_inv')
    let s:key_table_inv = {}
    for [k, v] in items(s:key_table)
      let s:key_table_inv[v] = k
    endfor
  endif
  return get(s:key_table_inv, a:key, tolower(a:key))
endfunction

function! mi#utils#capitalize(str) abort
  return toupper(a:str[0]) .. a:str[1:]
endfunction

function! mi#utils#includes(heystack, needle) abort
  return index(a:heystack, a:needle) >= 0
endfunction

function! mi#utils#excludes(heystack, needle) abort
  return !mi#utils#includes(a:heystack, a:needle)
endfunction

" https://zenn.dev/kawarimidoll/articles/4357f07f210d2f
function! mi#utils#get_current_selection() abort
  if mode() !~# '^[vV\x16]'
    " not in visual mode
    return ''
  endif

  " save current z register
  let save_reg = getreginfo('z')

  " get selection through z register
  noautocmd normal! "zygv
  let result = @z

  " restore z register
  call setreg('z', save_reg)

  return result
endfunction

function! mi#utils#pick_one(list) abort
  return a:list[rand(srand()) % len(a:list)]
endfunction

function! mi#utils#includes(list, value) abort
  for item in a:list
    if item ==# a:value
      return v:true
    endif
  endfor
  return v:false
endfunction

" get element in list with loop
function! mi#utils#at(list, idx) abort
  let len = len(a:list)
  let idx = a:idx
  while idx < 0
    let idx += len
  endwhile
  while idx > len
    let idx -= len
  endwhile
  return a:list[idx]
endfunction

" :h strpart
function! mi#utils#get_char_at(expr) abort
  return strpart(getline(a:expr), col(a:expr) - 1, 1, v:true)
endfunction

function! mi#utils#not_q() abort
  return empty(reg_recording() .. reg_executing())
endfunction

" :h abbreviations
function! mi#utils#eatchar(pat) abort
  const c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

function! mi#utils#download(url, local_path, force = v:false) abort
  echo '[utils#download] ' .. a:local_path
  if filereadable(a:local_path) && !a:force
    echo '[utils#download] dictionary file is already exists.'
    echo '[utils#download] add v:true argument to overwrite.'
    return v:false
  endif
  echo '[utils#download] start download...'
  echo system(printf('curl -fsSLo %s --create-dirs %s', a:local_path, a:url))
  echo '[utils#download] done.'
  return v:true
endfunction

" https://github.com/thinca/config/blob/78a1d2d4725e2ff064722b48cea5b5f1c44f49f9/dotfiles/dot.vim/autoload/vimrc.vim#L151-L161
function mi#utils#keep_cursor(cmd) abort
  const curwin_id = win_getid()
  const win_view = winsaveview()
  try
    execute a:cmd
  finally
    if win_getid() == curwin_id
      call winrestview(win_view)
    endif
  endtry
endfunction

" echo as function
function! mi#utils#echohl(hl) abort
  execute 'echohl' a:hl
endfunction
function! mi#utils#echo(...) abort
  execute 'echo' join(map(copy(a:000), 'string(v:val)'))
endfunction
function! mi#utils#echomsg(...) abort
  execute 'echomsg' join(map(copy(a:000), 'string(v:val)'))
endfunction

" use [text, hlgroup] like nvim_echo
function! mi#utils#echo_with_hl(...) abort
  for arg in a:000
    execute 'echohl' get(arg, 1, 'None')
    echon arg[0]
  endfor
  echohl None
endfunction

" pos1: [lnum1, col1]
" pos2: [lnum2, col2]
" eq_true(optional): return true when positions are same
function! mi#utils#pos_gt(pos1, pos2, eq_true = v:false) abort
  return a:pos1[0] != a:pos2[0] ? a:pos1[0] < a:pos2[0]
        \ : a:pos1[1] != a:pos2[1] ? a:pos1[1] < a:pos2[1]
        \ : a:eq_true
endfunction

function! mi#utils#match_at(pattern) abort
  if mode() !=# 'n'
    " not in normal mode
    return [[0, 0], [0, 0], '']
  endif
  let wv = winsaveview()
  let current_pos = getpos('.')[1:2]
  let start_pos = searchpos(a:pattern, 'bcW')
  if start_pos[0] == 0
    call winrestview(wv)
    return [[0, 0], [0, 0], '']
  endif
  normal! v
  let end_pos = searchpos(a:pattern, 'ceW')
  if mi#utils#pos_gt(current_pos, start_pos) || mi#utils#pos_gt(end_pos, current_pos)
    normal! v
    call winrestview(wv)
    return [[0, 0], [0, 0], '']
  endif
  let matched = mi#utils#get_current_selection()
  normal! v
  call winrestview(wv)
  return [start_pos, end_pos, matched]
endfunction

function! mi#utils#getcharstr_with_timeout(ms)
  if a:ms <= 0
    return getcharstr()
  endif

  let timeout = a:ms / 1000.0
  let starttime = reltime()
  let elapsed = reltimefloat(reltime(starttime))

  while getchar(1) == 0 && elapsed < timeout
    let elapsed = reltimefloat(reltime(starttime))
  endwhile

  return getcharstr(0)
endfunction

" run last one call in wait time
" https://github.com/lambdalisue/gin.vim/blob/d0fc41cc65d6e08f0291fec7f146f5f6a8129108/autoload/gin/util.vim#L23-L27
let s:debounce_timers = {}
function! mi#utils#debounce(fn, wait, args = []) abort
  let timer_name = string(funcref(a:fn))
  let timer = get(s:debounce_timers, timer_name, 0)
  call timer_stop(timer)
  let s:debounce_timers[timer_name] = timer_start(a:wait, {_ -> [
        \ call(a:fn, a:args),
        \ execute('unlet! s:debounce_timers[timer_name]', 'silent!')
        \ ]})
endfunction

" run first one call in wait time
let s:throttle_timers = {}
function! mi#utils#throttle(fn, wait, args = []) abort
  let timer_name = string(funcref(a:fn))
  if get(s:throttle_timers, timer_name, 0)
    return
  endif
  let s:throttle_timers[timer_name] = timer_start(a:wait, {_ -> [
        \ call(a:fn, a:args),
        \ execute('unlet! s:throttle_timers[timer_name]', 'silent!')
        \ ]})
endfunction
