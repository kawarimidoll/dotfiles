function! s:has_window_to(direction) abort
  if a:direction !~# '[hjkl]'
    return v:false
  endif
  return winnr() != winnr(a:direction)
endfunction

" https://github.com/simeji/winresizer/blob/master/plugin/winresizer.vim
function! mi#window#resize(size = {}) abort
  if winnr('$') == 1
    echo '[window] only one window'
    return
  endif
  let restcmd = winrestcmd()
  let original_win = winnr()

  let v_resize = get(a:size, 'v', 10)
  let h_resize = get(a:size, 'h', 3)

  while 1
    echo '[window] hjkl: resize, HJKL: focus, q: cancel, other: exit'
    redraw
    let c = getcharstr()

    if stridx('hjkl', c) >= 0
      let sign = s:has_window_to(c) ? '+' : '-'
      let size = c =~# '[jk]' ? h_resize : v_resize
      let cmd = c =~# '[jk]' ? 'resize' : 'vertical resize'
      execute cmd sign .. size
    elseif stridx('HJKL', c) >= 0
      execute 'wincmd' tolower(c)
    elseif c ==# 'q'
      execute restcmd
      execute original_win .. 'wincmd w'
      let msg = 'cancelled.'
      break
    else
      let msg = 'done.'
      break
    endif
  endwhile
  redraw

  echo '[window]' msg
endfunction
