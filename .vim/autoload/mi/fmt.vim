" ref: https://github.com/mattn/vim-sqlfmt/blob/master/ftplugin/sql/sqlfmt.vim
" function! mi#fmt#range(cmd) abort range
function! mi#fmt#run(cmd) abort
  let [firstline, lastline] = [1, line('$')]
  if mode() == 'v'
    let [firstline, lastline] = [line('.'), line('v')]
    if firstline > lastline
      let [firstline, lastline] = [lastline, firstline]
    endif
  endif

  let cmd = a:cmd
  " let cmd = get(g:, 'sqlfmt_program', 'sqlformat -r -k upper -o %outfile% -')

  if stridx(cmd, '%outfile%') > -1
    let tmpfile = tempname()
    defer delete(tmpfile)
    let cmd = substitute(cmd, '%outfile%', tr(tmpfile, '\', '/'), 'g')
  endif

  let sources = getline(firstline, lastline)
  let lines = systemlist(cmd, iconv(join(sources, "\n"), &encoding, 'utf-8'))
  if v:shell_error != 0
    echohl WarningMsg
    for line in lines
      echomsg substitute(line, '\e[[0-9]\{-1,}m', '', 'g')
    endfor
    echohl None
    return
  endif

  if exists('tmpfile')
    let lines = readfile(tmpfile)
  endif

  defer setpos('.', getcurpos())
  call append(lastline, lines)
  silent! execute $'{firstline},{lastline}delete _'
endfunction

" function! mi#fmt#run(cmd) abort
"   %call mi#fmt#run(a:cmd)
" endfunction
