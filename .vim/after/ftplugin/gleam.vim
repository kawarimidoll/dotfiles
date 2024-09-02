let b:quickrun_config = {
      \ 'command': 'gleam',
      \ 'cmdopt': '--module',
      \ 'exec': '%c run %o %s:p:t:r %a',
      \ }

setlocal commentstring=//\ %s

let s:undo_abbrev = []

function s:abbrev(original, converted) abort
  " call mi#utils#eatchar('\s')
  call mi#cmp#findstart()
  if mi#cmp#get_info().before_cursor =~# $'^\s*{a:original}$'
    return a:converted
  endif
  return a:original
endfunction

inoreabbrev <expr><buffer> le <sid>abbrev('le', 'let =<left><left>')
inoreabbrev <expr><buffer> la <sid>abbrev('la', 'let assert =<left><left>')
inoreabbrev <expr><buffer> fn <sid>abbrev('fn', 'fn () -> {<cr>}<up><right>')
inoreabbrev <expr><buffer> pfn <sid>abbrev('pfn', 'pub fn () -> {<cr>}<up>' .. repeat('<right>', 5))
inoreabbrev <expr><buffer> tfn <sid>abbrev('pfn', 'pub fn _test() {<cr>}<up>' .. repeat('<right>', 5))
inoreabbrev <expr><buffer> afn <sid>abbrev('afn', 'fn() {}' .. repeat('<left>', 4))
inoreabbrev <expr><buffer> case <sid>abbrev('case', 'case {<cr>}<up>' .. repeat('<right>', 3))
inoreabbrev <expr><buffer> ty <sid>abbrev('ty', 'type {<cr>}<up>' .. repeat('<right>', 3))
inoreabbrev <expr><buffer> pty <sid>abbrev('pty', 'pub type {<cr>}<up>' .. repeat('<right>', 7))
inoreabbrev <expr><buffer> im <sid>abbrev('im', 'import gleam')
let s:undo_abbrev += ['le', 'la', 'fn', 'pfn', 'tfn', 'afn', 'cs', 'ty', 'pty', 'im']

if !has('nvim')
  augroup user_ftplugin_gleam
    autocmd!
    autocmd ColorScheme * if &filetype == 'gleam'
          \ | syntax enable
          \ | endif
  augroup END
endif

if exists('b:undo_ftplugin')
  let b:undo_ftplugin ..= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin ..= 'unlet! b:quickrun_config'
let b:undo_ftplugin ..= '| setlocal commentstring<'
let b:undo_ftplugin ..= '| iunmap ;'
let b:undo_ftplugin ..= s:undo_abbrev->copy()->map('"| iunabbrev <buffer>" .. v:val')->join('')
