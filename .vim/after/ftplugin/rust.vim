let s:undo_abbrev = []

function s:abbrev(lhs, rhs) abort
  let [lhs, rhs] = [a:lhs, a:rhs->string()]
  call add(s:undo_abbrev, lhs)
  execute $'inoreabbrev <expr><buffer> {lhs}'
        \ $'(nr2char(getchar(0)) ==# "\<esc>") ? "{lhs}\<esc>" : {rhs}'
endfunction

call s:abbrev('le', 'let  =<c-o>F ')
call s:abbrev('lm', 'let mut  =<c-o>F ')
call s:abbrev('if', 'if {<cr>}<up><c-o>f{')
call s:abbrev('fn', 'fn () {<cr>}<up><c-o>f(')
call s:abbrev('pfn', 'pub fn () {<cr>}<up><c-o>f(')
call s:abbrev('mh', 'match {<cr>}<up><c-o>f{')
call s:abbrev('match', 'match {<cr>}<up><c-o>f{')
call s:abbrev('st', 'struct {<cr>}<up><c-o>f{')
call s:abbrev('pst', 'pub struct {<cr>}<up><c-o>f{')

if exists('b:undo_ftplugin')
  let b:undo_ftplugin ..= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin ..= s:undo_abbrev->copy()->map('"| iunabbrev <buffer>" .. v:val')->join('')
