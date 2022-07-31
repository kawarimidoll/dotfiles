let s:termal_terminals = []

function! s:ui_select(items, ...) abort
  let opts = get(a:000, 0, {})
  let prompt = get(opts, 'prompt', 'Select one of:')
  let s:format_item = get(opts, 'format_item', {item->item})
  let items = map(a:items[:], {idx,item-> (idx + 1) .. ': ' .. s:format_item(item)})

  let input = inputlist(insert(items, prompt))
  let choice = input > 0 ? get(a:items, input - 1, '') : ''
  let idx = choice == '' ? -1 : input -1

  return [choice, idx]
endfunction

function! s:echoerr(msg) abort
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction

function! s:termal_select(...) abort
  let opts = get(a:000, 0, {})
  let len = len(s:termal_terminals)
  if len < 1
    s:echoerr('No terminals of termal are exist.')
    return {}
  endif

  if len == 1
    return get(s:termal_terminals, 0)
  endif

  let titles = map(s:termal_terminals[:], 'v:val.title')
  if has('nvim') && !exists('g:termal_not_use_nvim_select')
    let b:termal_titles = titles
    let b:termal_opts = opts
    let b:termal_idx = -1
    lua vim.ui.select(vim.b.termal_titles, vim.b.termal_opts, function(_, idx) if idx then vim.b.termal_idx = idx - 1 end end)
    let idx = b:termal_idx
    unlet b:termal_titles
    unlet b:termal_opts
    unlet b:termal_idx
  else
    let [_, idx] = s:ui_select(titles, opts)
  endif

  return idx >= 0 ? get(s:termal_terminals, idx, {}) : {}
endfunction
command! TermalSelect echo s:termal_select()

if has('nvim')
  let s:terminal_open_command = 'keepalt terminal'
  function! s:termal_sendkeys(termal_target, keys) abort
    call chansend(a:termal_target.job_id, a:keys)
  endfunction
else
  let s:terminal_open_command = 'keepalt terminal ++curwin'
  function! s:termal_sendkeys(termal_target, keys) abort
    call term_sendkeys(a:termal_target.bufnr, a:keys)
  endfunction
endif

function! s:termal_run(no_run, ...) abort
  if !len(s:termal_terminals)
    call s:termal_open()
  endif

  let termal_target = s:termal_select()
  if empty(termal_target)
    return
  endif

  let args = []
  for arg in a:000
    call add(args, expand(arg))
  endfor

  let command = join(args, ' ')

  call s:termal_sendkeys(termal_target, command .. (a:no_run ? '' : "\<CR>"))

  if command =~ '^\s*$'
    return
  endif

  let bufnr = termal_target.bufnr
  let title = bufnr .. '%' .. command
  for idx in range(len(s:termal_terminals))
    if s:termal_terminals[idx].bufnr == bufnr
      let s:termal_terminals[idx].title = title
      if has('nvim')
        let b:term_title = title
      endif
      break
    endif
  endfor
endfunction
command! -nargs=* -bang TermalRun call s:termal_run(<bang>0, <f-args>)

function! s:termal_open() abort
  let winid = win_getid()

  " default: bottom, 12
  let buf_open_cmd = ['botright', 12, 'split']
  let termal_dir = get(g:, 'termal_default_dir')
  if termal_dir == 'bottom'
    let buf_open_cmd[0] = 'botright'
    let buf_open_cmd[2] = 'split'
  elseif termal_dir == 'right'
    let buf_open_cmd[0] = 'botright'
    let buf_open_cmd[2] = 'vsplit'
  elseif termal_dir == 'top'
    let buf_open_cmd[0] = 'topleft'
    let buf_open_cmd[2] = 'split'
  elseif termal_dir == 'left'
    let buf_open_cmd[0] = 'topleft'
    let buf_open_cmd[2] = 'vsplit'
  endif

  let termal_size = get(g:, 'termal_default_size')
  if termal_size =~ '^[1-9]\+\d*$' && termal_size > 3
    let buf_open_cmd[1] = termal_size
  end

  execute join(buf_open_cmd, ' ')
  execute s:terminal_open_command
  stopinsert
  setlocal nonumber norelativenumber
  normal! G
  let bufnr = bufnr()
  let title = bufnr .. '%' .. &shell
  if has('nvim')
    let b:term_title = title
  endif
  call add(s:termal_terminals, {
    \   'job_id': get(b:, 'terminal_job_id'),
    \   'bufnr': bufnr,
    \   'title': title
    \ })
  execute 'autocmd BufDelete <buffer> call s:remove_from_termal_list(' .. bufnr .. ')'
  call win_gotoid(winid)
endfunction
command! TermalOpen call s:termal_open()

function! s:remove_from_termal_list(bufnr) abort
  for idx in range(len(s:termal_terminals))
    if s:termal_terminals[idx].bufnr == a:bufnr
      unlet s:termal_terminals[idx]
      break
    endif
  endfor
endfunction

function! s:termal_wipe(all_kill) abort
  if a:all_kill
    for tarmal_target in s:termal_terminals
      execute termal_target.bufnr 'bwipeout!'
    endfor
    return
  endif

  let termal_target = s:termal_select()
  if empty(termal_target)
    return
  endif

  execute termal_target.bufnr 'bwipeout!'
endfunction
command! -bang TermalWipe call s:termal_wipe(<bang>0)

let s:subcommands = ['open', 'wipe', 'send', 'run', 'select']
function! s:termal_comp(ArgLead, CmdLine, CursorPos) abort
  let cmd = get(split(a:CmdLine, '\s\+'), 1, '')
  if index(s:subcommands, cmd) > -1
    return ''
  endif
  return join(s:subcommands, "\n")
endfunction

function! s:snake_to_camel(str) abort
  return substitute(substitute(a:str, '^\l', '\u\0', ''), '_\(\l\)', '\u\1', 'g')
endfunction

function! termal#do(args) abort
  if a:args =~ '^\s*$'
    s:echoerr('[Termal] Subcommand is required')
    return
  endif

  let [subcommand; args] = split(a:args, '\s\+')
  if index(s:subcommands, subcommand) < 0
    s:echoerr('[Termal] Subcommand not found: ' .. subcommand)
    return
  endif

  echo 's:termal_' .. subcommand .. '("' .. join(args, ' ') .. '")'

  call insert(args, 'Termal' .. s:snake_to_camel(subcommand))

  let command = join(args, ' ')

  " execute command
  echo command

endfunction
command! -nargs=+ -complete=custom,s:termal_comp Termal call termal#do(<q-args>)
