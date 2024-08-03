function! s:errormsg(text) abort
  echohl ErrorMsg
  echomsg $'[mi#buf#delete] {a:text}'
  echohl None
endfunction

" https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/bufremove.lua
function! mi#buf#delete(option = {}) abort
  let bufnr = get(a:option, 'bufnr', bufnr())
  let force = get(a:option, 'force', v:false)
  let cmd = get(a:option, 'cmd', 'bdelete')

  let buf_info = getbufinfo(bufnr)
  if empty(buf_info)
    call s:errormsg($'Buffer {bufnr} is not exists.')
    return
  endif
  if buf_info[0].changed && !force
    call s:errormsg($'Buffer {bufnr} has unsaved changes.')
    return
  endif
  if cmd != 'bdelete' && cmd != 'bwipeout'
    call s:errormsg("cmd must be 'bdelete' or 'bwipeout'.")
    return
  endif

  let cur_winnr = winnr()

  for win_id in win_findbuf(bufnr)
    " can i use win_execute() ?
    execute win_id2win(win_id) .. 'wincmd w'

    " try using alt buffer
    let alt_buf = bufnr('#')
    if alt_buf != bufnr && buflisted(alt_buf)
      execute 'buffer' alt_buf
      continue
    endif

    " try using previous buffer
    bprevious
    if bufnr() != bufnr
      continue
    endif

    " otherwise create unlisted buffer
    call mi#buf#scratch()
  endfor

  execute cur_winnr .. 'wincmd w'

  " when buftype is delete/wipe, buffer is already removed
  if empty(getbufinfo(bufnr))
    echomsg $'[mi#buf#delete] Buffer {bufnr} is auto-remove buffer.'
    return
  endif

  if force
    let cmd ..= '!'
  endif
  execute cmd bufnr
endfunction

function! mi#buf#scratch() abort
  enew
  setlocal nobuflisted
  file [scratch]
endfunction
