" https://github.com/tyru/capture.vim
function! mi#capture#run(force_new, cmd = '') abort
  try
    if get(s:, 'running', v:false)
      throw '[Capture] nesting is not allowed.'
    endif
    let s:running = v:true
    let cmd = a:cmd == '' ? getreg(':') : a:cmd
    let output = execute(cmd)
    let s:capture_buf = get(s:, 'capture_buf', -1)
    let is_new_buf = a:force_new || !bufloaded(s:capture_buf)
    if is_new_buf
      let s:capture_cnt = get(s:, 'capture_cnt', 0) + 1
      execute 'new' printf('[capture %d]', s:capture_cnt)
      autocmd WinEnter <buffer> if winnr('$') == 1 | quit | endif
      let s:capture_buf = bufnr()
    else
      if !win_gotoid(bufwinid(s:capture_buf))
        split
        execute 'buffer' s:capture_buf
      endif
      call append('$', [''])
    endif
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal noswapfile
    let lastline = line('$') + 1
    call append('$', [repeat('=', 20), cmd, repeat('=', 20), ''])
    call append('$', split(output, '\n'))
    if is_new_buf
      " remove unnecessary first line in new buffer
      call deletebufline(s:capture_buf, 1)
      call cursor(1, 0)
    else
      call cursor(lastline, 0)
    endif
    let s:running = v:false
  catch
    echohl ErrorMsg
    echomsg v:exception
    echohl None
  endtry
endfunction
