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

" run last one call in wait time
" https://github.com/lambdalisue/gin.vim/blob/d0fc41cc65d6e08f0291fec7f146f5f6a8129108/autoload/gin/util.vim#L23-L27
let s:debounce_timers = {}
function! mi#utils#debounce(fn, wait, args = []) abort
  let timer_name = string(funcref(a:fn))
  let timer = get(s:debounce_timers, timer_name, 0)
  call timer_stop(timer)
  let s:debounce_timers[timer_name] = timer_start(a:wait, {_ -> [
        \ call(a:fn, a:args),
        \ execute('unlet! s:debounce_timers[a:timer_name]', 'silent!')
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
        \ execute('unlet! s:throttle_timers[a:timer_name]', 'silent!')
        \ ]})
endfunction
