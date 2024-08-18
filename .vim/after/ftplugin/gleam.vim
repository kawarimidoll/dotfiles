let b:quickrun_config = {
      \ 'command': 'gleam',
      \ 'cmdopt': '--module',
      \ 'exec': '%c run %o %s:p:t:r %a',
      \ }

setlocal commentstring=//\ %s

let s:undo_abbrev = []

function! s:gleam_symbol_cmp() abort
  call complete(col('.')-1, [
        \ {'word': '->', 'menu': 'h'},
        \ {'word': '|>', 'menu': 'j'},
        \ {'word': '<>', 'menu': 'k'},
        \ {'word': '<-', 'menu': 'l'},
        \ {'word': '_ ->', 'menu': ';'},
        \ ])
endfunction
inoremap <buffer> ; ;<cmd>call <sid>gleam_symbol_cmp()<cr>
inoreabbrev <buffer> ;h ->
inoreabbrev <buffer> ;j <bar>>
inoreabbrev <buffer> ;k <>
inoreabbrev <buffer> ;l <-
inoreabbrev <buffer> ;; _ ->
let s:undo_abbrev += [';h', ';j', ';k', ';l', ';;']

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
let b:undo_ftplugin ..= s:undo_abbrev->copy()->map('"| iunabbrev " .. v:val')->join('')
