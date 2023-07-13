let s:PREV = 'prev'
let s:NEXT = 'next'

let s:nei_prev_keys = []
let s:nei_next_keys = []

let s:config = {}

function! s:nei(dir, key) abort
  let dir = a:dir
  while v:true
    if dir ==# s:PREV
      execute s:config[a:key][0]
    elseif dir ==# s:NEXT
      execute s:config[a:key][1]
    else
      if dir !=# ''
        call feedkeys(dir)
      endif
      return
    endif
    redraw
    let c = mi#utils#getcharstr_with_timeout(1000)
    if mi#utils#includes(s:nei_prev_keys, c)
      let dir = s:PREV
    elseif mi#utils#includes(s:nei_next_keys, c)
      let dir = s:NEXT
    else
      let dir = c
    endif
  endwhile
endfunction

function! mi#neighbor#define_prefix(prev_keys, next_keys) abort
  let s:nei_prev_keys = a:prev_keys
  let s:nei_next_keys = a:next_keys
endfunction

function! mi#neighbor#map(key, rhs_pair) abort
  let s:config[a:key] = a:rhs_pair
  for prev_key in s:nei_prev_keys
    let lhs = prev_key .. a:key
    execute printf("nnoremap %s <cmd>call <sid>nei('%s', '%s')<cr>", lhs, s:PREV, a:key)
  endfor
  for next_key in s:nei_next_keys
    let lhs = next_key .. a:key
    execute printf("nnoremap %s <cmd>call <sid>nei('%s', '%s')<cr>", lhs, s:PREV, a:key)
  endfor
endfunction

call mi#neighbor#define_prefix(['[', "\<bs>"], [']', "'"])
call mi#neighbor#map('b', ['bprevious', 'bnext'])
call mi#neighbor#map('q', ['call mi#qf#cycle_p()', 'call mi#qf#cycle_n()'])
call mi#neighbor#map('w', ['wincmd w', 'wincmd W'])
call mi#neighbor#map('m', ['normal! [`', 'normal! ]`'])
call mi#neighbor#map('p', ['normal! {', 'normal! }'])

if has('nvim')
  call mi#neighbor#map('d', ['Lspsaga diagnostic_jump_prev', 'Lspsaga diagnostic_jump_next'])
  call mi#neighbor#map('c', [
        \ "&diff ? 'normal! [c' : 'Gitsigns prev_hunk'",
        \ "&diff ? 'normal! ]c' : 'Gitsigns next_hunk'"
        \ ])
endif

