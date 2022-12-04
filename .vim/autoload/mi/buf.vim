" https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/bufremove.lua
function! mi#buf#delete(option = {}) abort
  let bufnr = get(a:option, 'bufnr', bufnr())
  let force = get(a:option, 'force', v:false)
  let cmd = get(a:option, 'cmd', 'bdelete')

  let buf_info = getbufinfo(bufnr)
  if empty(buf_info)
    echoerr 'Buffer ' .. bufnr .. ' is not exists.'
    return
  endif
  if buf_info[0].changed && !force
    echoerr 'Buffer ' .. bufnr .. ' has unsaved changes.'
    return
  endif
  if cmd != 'bdelete' && cmd != 'bwipeout'
    echoerr "cmd must be 'bdelete' or 'bwipeout'."
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
