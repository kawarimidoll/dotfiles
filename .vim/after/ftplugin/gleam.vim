let b:quickrun_config = {
      \ 'command': 'gleam',
      \ 'cmdopt': '--module',
      \ 'exec': '%c run %o %s:p:t:r %a',
      \ }

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
