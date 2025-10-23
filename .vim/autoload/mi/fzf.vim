function! mi#fzf#run(arg = {}) abort
  let s:winid_to_open = win_getid()

  let list_cmd = ''
  if has_key(a:arg, 'cmd')
    let list_cmd = a:arg.cmd
  elseif has_key(a:arg, 'list')
    let list_cmd = 'echo -e "' .. join(a:arg.list, '\\n') .. '"'
  else
    throw 'cmd or list is required'
    return
  endif

  execute 'terminal ++norestore ++close ++shell ' .. list_cmd
        \ .. " | FZF_DEFAULT_OPTS='' fzf --multi --exit-0 --cycle --reverse --preview='fffe -p {}'"
        \ .. " | xargs --no-run-if-empty -I{} echo -e '\\x1b]51;[\"call\", \"Tapi_fzf_file_open\", [\"{}\"]]\\x07'"
endfunction

function! mi#fzf#files() abort
  call mi#fzf#run({'cmd': 'fffe -f'})
endfunction

function! mi#fzf#mru() abort
  call mi#fzf#run({'list': mi#mru#list()})
endfunction

function! mi#fzf#bufs() abort
  let bufs = getbufinfo({'buflisted': 1})
  call mi#fzf#run({'list': map(bufs, 'v:val.name')})
endfunction

" tr "\n" ","
" function! Tapi_fzf_file_open(_bufnum, arglist) abort
"   if len(a:arglist) < 1
"     return
"   endif
"   let files = split(a:arglist[0], ',')
"   if len(files) < 1
"     return
"   endif
"   for file in files[1:]
"     execute 'badd' file
"   endfor
"   wincmd p
"   execute 'edit' files[0]
" endfunction

function! Tapi_fzf_file_open(_bufnum, arglist) abort
  if len(a:arglist) < 1
    return
  endif

  if exists('s:winid_to_open') && s:winid_to_open != win_getid()
    execute win_id2win(s:winid_to_open) .. 'wincmd w'
    unlet! s:winid_to_open
  endif
  execute 'edit' a:arglist[0]
endfunction
