function! s:has_window_to(direction) abort
  if a:direction !~ '[hjkl]'
    throw 'invalid direction'
  endif
  if winnr('$') == 1
    return v:false
  endif

  let from = winnr()
  execute 'wincmd' a:direction
  let to = winnr()
  execute from 'wincmd w'
  return from != to
endfunction

" https://github.com/simeji/winresizer/blob/master/plugin/winresizer.vim
function! mi#window#resize(size = {}) abort
  if winnr('$') == 1
    echo 'only one window'
    return
  endif
  let restcmd = winrestcmd()

  let v_resize = get(a:size, 'v', 10)
  let h_resize = get(a:size, 'h', 3)

  while 1
    echo 'hj: expand kl: shrink HJKL-focus q-cancel other-exit'
    redraw
    let c = getcharstr()

    if c ==# 'h'
      execute 'vertical resize +' .. v_resize
    elseif c ==# 'j'
      execute 'resize +' .. h_resize
    elseif c ==# 'k'
      execute 'resize -' .. h_resize
    elseif c ==# 'l'
      execute 'vertical resize -' .. v_resize
    elseif stridx('HJKL', c) >= 0
      execute 'wincmd' tolower(c)
    elseif c ==# 'q'
      execute restcmd
      break
    else
      break
    endif
  endwhile
  redraw
endfunction
