" Two-way diff instead of three-way diff
" inspired by: https://github.com/whiteinge/diffconflicts

function s:echomsg(msg) abort
  echohl WarningMsg | echo a:msg | echohl None
endfunction

function mi#mergetool#better_vimdiff() abort
  " check if vim is called as `vimdiff (vim -d) LOCAL BASE REMOTE conflicted`
  " see :h start-vimdiff
  let [local, base, remote; _] = argv() + ['', '', '']
  if !(argc() == 4 && local =~# 'LOCAL' && base =~# 'BASE' && remote =~# 'REMOTE')
    call s:echomsg("Not correct diff arguments.")
    return
  endif

  if !search('^<<<<<<< ', 'cnw')
    call s:echomsg("No conflict markers found.")
    return
  endif

  set laststatus=2

  diffoff
  only!
  buffer 1

  " Open UPSTREAM as new tabpage.
  " silent tabnew #1

  " Set up the right-hand side.
  let &l:statusline = '[UPSTREAM] <left> to use'
  setlocal buftype=nowrite bufhidden=delete
  diffthis

  " Set up the left-hand side.
  silent leftabove vsplit #4
  %delete_
  silent read #3
  1delete_
  let &l:statusline = '[MERGING] %f%m <right> to use'
  diffthis

  diffupdate

  nnoremap <up> [c
  nnoremap <down> ]c
  nnoremap <expr><left> winnr() == 1 ? 'do' : 'dp'
  nnoremap <expr><right> winnr() == 2 ? 'do' : 'dp'

  let &g:undolevels = &g:undolevels

  call timer_start(0, {->s:echomsg("Resolve conflicts leftward then save. :xa to finish. :cq to abort.")})
endfunction
