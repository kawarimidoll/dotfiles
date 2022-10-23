function! mi#fzf#files() abort
  let fzf_preview_cmd='head -50'
  if executable('bat')
    let fzf_preview_cmd='bat --color=always --style=header,grid --line-range :50 {}'
  endif
  let s:winid_to_open = win_getid()

  execute 'terminal ++norestore ++close ++shell find_for_vim'
        \ .. " | FZF_DEFAULT_OPTS='' fzf --multi --exit-0 --cycle --reverse --preview='" .. fzf_preview_cmd
        \ .. "' | xargs --no-run-if-empty -I{} echo -e '\\x1b]51;[\"call\", \"Tapi_fzf_file_open\", [\"{}\"]]\\x07'"
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
