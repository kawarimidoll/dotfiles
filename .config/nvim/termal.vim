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

function! s:termal_select(...) abort
  let opts = get(a:000, 0, {})
  let len = len(s:termal_terminals)
  if len < 1
    echoerr 'No terminals of termal are exist.'
    return {}
  endif

  if len == 1
    return get(s:termal_terminals, 0)
  endif

  let titles = map(s:termal_terminals[:], 'v:val.title')
  " if has('nvim') && exists(g:termal_use_nvim_select)
  if has('nvim')
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

function! s:termal_run(no_run, ...) abort
  if !len(s:termal_terminals)
    call s:termal_open()
  endif

  let termal_target = s:termal_select()
  if empty(termal_target)
    return
  endif

  let job_id = termal_target.job_id

  let args = []
  for arg in a:000
    call add(args, expand(arg))
  endfor

  let command = args->join(' ')

  call chansend(job_id, command .. (a:no_run ? '' : "\<CR>"))

  if command =~ '\s\+'
    return
  endif

  for idx in range(len(s:termal_terminals))
    if s:termal_terminals[idx].job_id == job_id
      let pid = s:termal_terminals[idx].pid
      let s:termal_terminals[idx].title = pid .. '%' .. command
      break
    endif
  endfor
endfunction
command! -nargs=* -bang TermalRun call s:termal_run(<bang>0, <f-args>)

function! s:termal_open() abort
  let winid = win_getid()
  botright 12 split
  keepalt terminal
  stopinsert
  setlocal nonumber norelativenumber
  normal! G
  let pid = b:terminal_job_pid
  let title = pid .. '%' .. &shell
  execute 'file' title
  call add(s:termal_terminals, {
    \   'job_id': b:terminal_job_id,
    \   'pid': pid,
    \   'bufnr': bufnr(),
    \   'title': title
    \ })
  call win_gotoid(winid)
endfunction
command! TermalOpen call s:termal_open()

function! s:termal_wipe() abort
  let termal_target = s:termal_select()
  if empty(termal_target)
    return
  endif

  let bufnr = termal_target.bufnr
  execute bufnr 'bwipeout!'

  for idx in range(len(s:termal_terminals))
    if s:termal_terminals[idx].bufnr == bufnr
      unlet s:termal_terminals[idx]
      break
    endif
  endfor
endfunction
command! TermalWipe call s:termal_wipe()
