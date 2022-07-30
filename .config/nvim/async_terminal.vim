" {{{ async_terminal
function s:async_terminal(...) abort
  let opts = []
  for i in range(a:000->len())
    let arg = a:000[i]
    if arg =~ '^-'
      call add(opts, substitute(arg, '^-\+', '', ''))
      continue
    endif

    " if !executable(arg)
    "   call s:error('[AsyncTerminal] command not found: ' .. arg)
    "   return
    " endif

    let command = a:000[i:]->join(' ')
    break
  endfor

  if !exists('command')
    call s:error('[AsyncTerminal] command is required')
    return
  endif

  let buf_open_cmd = #{
    \   dir: 'botright',
    \   size: 12,
    \   split: 'split',
    \ }
  let bufhidden = 'wipe'
  let watch = v:false
  for opt in opts
    if opt =~ '\d\+' && opt > 3
      let buf_open_cmd.size = opt
    elseif opt == 'b'
      let buf_open_cmd.dir = 'botright'
      let buf_open_cmd.split = 'split'
    elseif opt == 'r'
      let buf_open_cmd.dir = 'botright'
      let buf_open_cmd.split = 'vsplit'
    elseif opt == 't'
      let buf_open_cmd.dir = 'topleft'
      let buf_open_cmd.split = 'split'
    elseif opt == 'l'
      let buf_open_cmd.dir = 'topleft'
      let buf_open_cmd.split = 'vsplit'
    elseif opt == 'h'
      let bufhidden = 'hide'
    elseif opt == 'w'
      let watch = v:true
    endif
  endfor

  if bufhidden == 'hide'
    let current_bufhidden = &bufhidden
    set bufhidden=hide
    let bufnr = bufnr()
    keepalt enew
  else
    let winid = win_getid()
    execute buf_open_cmd.dir buf_open_cmd.size buf_open_cmd.split
  endif
  if has('nvim')
    terminal
    stopinsert
    call chansend(b:terminal_job_id, command .. "\<CR>")
  else
    " WIP
    execute 'terminal' '++curwin' command
  endif
  stopinsert
  normal! G
  setlocal nonumber norelativenumber
  execute 'set bufhidden=' .. bufhidden
  autocmd BufEnter,BufRead,WinEnter <buffer>
    \ if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    \ |   quit!
    \ | endif
  execute 'file' b:terminal_job_pid .. '/' .. command

  if bufhidden == 'hide'
    execute 'keepalt buffer' bufnr
    execute 'set bufhidden=' .. current_bufhidden
  else
    call win_gotoid(winid)
  endif

  if watch
    " autocmd BufWritePost <buffer> call s:async_terminal(a:000)
  endif
endfunction
" }}}


" {{{ error
function s:error(msg)
  if has('nvim') && get(g:, 'async_terminal_error_notify', 0)
    execute 'lua vim.notify("' a:msg '", vim.log.levels.ERROR, {})'
    return
  endif

  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction
" }}}

command! -nargs=+ AsyncTerminal call s:async_terminal(<f-args>)
" command! -nargs=+ Git call s:async_terminal('git', <f-args>)
