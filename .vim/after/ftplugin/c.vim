let s:undo_abbrev = []

function s:abbrev(key) abort
  " call mi#utils#eatchar('\s')
  let c = nr2char(getchar(0))
  echomsg c
  if (c ==# "\<esc>")
    return $"{a:key}\<esc>"
  endif

  if a:key ==# 'else'
    return $"{a:key} {{\<cr>}}\<up>\<end>\<cr>"
  elseif a:key ==# 'case'
    return $"{a:key} _:\<left>\<bs>"
  endif
  return $"{a:key} () {{\<cr>}}\<up>\<end>\<left>\<left>\<left>"
endfunction

inoreabbrev <expr><buffer> if <sid>abbrev('if')

function s:def_abbrev(key) abort
  call add(s:undo_abbrev, a:key)
  let eatchar = '<c-r>=mi#utils#eatchar(''\s'')<cr>'

  let main_part = (a:key ==# 'else') ?
        \   $"{a:key} {{<cr>}}<up><end><cr>"
        \ : (a:key ==# 'case') ?
        \   $"{a:key} _:<left><bs>"
        \ : $"{a:key} () {{<cr>}}<up><end><left><left><left>"
  if a:key ==# 'elif'
    let main_part = substitute(main_part, 'elif', 'else if', '')
  endif
  execute $'inoreabbrev <silent><buffer> {a:key} {main_part}{eatchar}'
endfunction

" call s:def_abbrev('if')
call s:def_abbrev('for')
call s:def_abbrev('elif')
call s:def_abbrev('else')
call s:def_abbrev('while')
call s:def_abbrev('switch')
call s:def_abbrev('case')

" inoreabbrev <expr><buffer> if <sid>abbrev('if')
" inoreabbrev <expr><buffer> for <sid>abbrev('for')
" inoreabbrev <expr><buffer> elseif <sid>abbrev('elseif')
" inoreabbrev <expr><buffer> else <sid>abbrev('else')
" inoreabbrev <expr><buffer> while <sid>abbrev('while')
" inoreabbrev <expr><buffer> switch <sid>abbrev('switch')
" inoreabbrev <expr><buffer> case <sid>abbrev('case')

let b:undo_abbrev = s:undo_abbrev

if exists('b:undo_ftplugin')
  let b:undo_ftplugin ..= '|'
else
  let b:undo_ftplugin = ''
endif
" let b:undo_ftplugin ..= 'iunabbrev <buffer> if'
" let b:undo_ftplugin ..= s:undo_abbrev->copy()->map('"| iunabbrev <buffer>" .. v:val')->join('')
let b:undo_ftplugin ..= s:undo_abbrev->copy()->map({_,v->$'iunabbrev <buffer> {v}'})->join('|')
