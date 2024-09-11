function s:endwise(keyword, eatchar = v:false) abort
  if a:eatchar
    call mi#utils#eatchar('\s')
  endif
  call mi#cmp#findstart()
  if mi#cmp#get_info().before_cursor =~# $'^\s*{a:keyword}$'
    if a:keyword == 'augroup'
      return $"{a:keyword} \<end>_\<cr>{a:keyword} END\<c-o>Oautocmd!\<up>\<end>\<bs>"
    else
      return $"{a:keyword}\<end>\<cr>end{a:keyword}\<left>\<left>\<left>\<up>"
    endif
  endif
  return a:keyword
endfunction

inoreabbrev <expr><buffer> if <sid>endwise("if")
inoreabbrev <expr><buffer> for <sid>endwise("for")
inoreabbrev <expr><buffer> while <sid>endwise("while")
inoreabbrev <expr><buffer> augroup <sid>endwise("augroup", v:true)

function s:cr_jump() abort
  if !exists("s:cr_jump_list") || empty(s:cr_jump_list)
    echomsg 'unmap'
    silent! iunmap <buffer> <cr>
    " if exists("s:cr_jump_saved_map")
    "   call mapset(s:cr_jump_saved_map)
    "   unlet! s:cr_jump_saved_map
    " endif
    call feedkeys("\<cr>")
    return ''
  endif
  let target = remove(s:cr_jump_list, 0)

  return $"\<c-o>{target}"
endfunction

function s:functionwise() abort
  let keyword = 'function'
  call mi#cmp#findstart()
  if mi#cmp#get_info().before_cursor =~# $'^\s*{keyword}$'
    let s:cr_jump_list = ['f)', 'o']
    let s:cr_jump_saved_map = maparg('<cr>', 'i', v:false, v:true)
    inoremap <expr><buffer> <cr> <sid>cr_jump()
    autocmd ModeChanged i:n ++once silent! iunmap <buffer> <cr>
    " inoremap <buffer> <cr> <cmd>call <sid>cr_jump()<cr>
    return $"{keyword}\<end>() abort\<cr>end{keyword}\<left>\<left>\<left>\<up>"
  endif
  return keyword
endfunction
inoreabbrev <expr><buffer> function <sid>functionwise()

" if exists('b:undo_ftplugin')
"   let b:undo_ftplugin ..= '|'
" else
"   let b:undo_ftplugin = ''
" endif
" let b:undo_ftplugin ..= 'setlocal noexpandtab< tabstop<'
