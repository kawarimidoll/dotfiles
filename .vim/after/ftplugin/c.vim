let s:undo_abbrev = []

function s:def_abbrev(key) abort
  call add(s:undo_abbrev, a:key)
  let eatchar = '<c-r>=mi#utils#eatchar(''\s'')<cr>'

  let main_part = (a:key ==# 'else') ?
        \   $"{a:key} {{<cr>}}<up><end><cr>"
        \ : (a:key ==# 'case') ?
        \   $"{a:key} _:<left><bs>"
        \ : $"{a:key} () {{<cr>}}<up><end><left><left><left>"
  execute $'inoreabbrev <silent><buffer> {a:key} {main_part}{eatchar}'
endfunction

call s:def_abbrev('if')
call s:def_abbrev('for')
call s:def_abbrev('elseif')
call s:def_abbrev('else')
call s:def_abbrev('while')
call s:def_abbrev('switch')
call s:def_abbrev('case')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin ..= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin ..= s:undo_abbrev->copy()->map({_,v->$'iunabbrev <buffer> {v}'})->join('|')
