let s:pop_ids = get(s:, 'pop_ids', [])
let s:notify_history = []
let s:opts = {}

let s:line_base = 4
let s:line_offset = 1

" from neovim vim.log.levels map
let s:levels = { 'TRACE': 0, 'DEBUG': 1, 'INFO': 2, 'WARN': 3, 'ERROR': 4, 'OFF': 5 }

let s:width = 20
function mi#notify#setwidth(width) abort
  let s:width = a:width
endfunction

function s:opts(overwrite) abort
  return extendnew(s:opts, a:overwrite)
endfunction

function mi#notify#level(level_string) abort
  return get(s:levels, a:level_string, 0)
endfunction

function mi#notify#show(msg, level = 2, opts = {}) abort
  let msg = type(a:msg) == v:t_list ? a:msg->join("\n") : a:msg

  call add(s:notify_history, get(s:levels->keys(), a:level, 'UNKNOWN') .. ' ' .. msg)

  if has('nvim')
    call luaeval('vim.notify(_A[1], _A[2], _A[3])', [msg, a:level, a:opts])
    return
  endif

  let hlgroup = a:level == 3 ? 'WarningMsg'
        \ : a:level == 4 ? 'ErrorMsg'
        \ : 'Normal'

  " try to avoid overlap with another notifications
  let line = s:line_base
  for pid in s:pop_ids
    let pos = popup_getpos(pid)
    if empty(pos)
      continue
    endif
    let m = pos.line - 1 + pos.height
    if m >= line
      let line = m + s:line_offset
    endif
  endfor
  if line >= &lines
    " if can't avoid to overlap, put on top in the hope that message goes away soon
    let line = s:line_base
  endif

  let pop_id = popup_create(msg, {
        \ 'line': line,
        \ 'col': &columns,
        \ 'pos': 'topright',
        \ 'maxwidth': s:width,
        \ 'minwidth': s:width,
        \ 'posinvert': v:false,
        \ 'time': 3000,
        \ 'highlight': 'hlgroup',
        \ 'callback': 's:notify_closed',
        \ })

  call add(s:pop_ids, pop_id)
  " echowindow s:pop_ids
endfunction

function s:notify_closed(id, _) abort
  let idx = index(s:pop_ids, a:id)
  if idx < 0
    return
  endif
  call remove(s:pop_ids, idx)
  " echowindow s:pop_ids
endfunction

function mi#notify#history(write = v:false) abort
  if a:write
    new notify_history
    setlocal buftype=nofile bufhidden=delete nobuflisted noswapfile
    call append('$', s:notify_history)
  else
    echo s:notify_history->join("\n")
  endif
endfunction
