augroup user_ftplugin_gleam
  autocmd!
  autocmd ColorScheme <buffer> if &filetype == 'gleam'
        \ | syntax enable
        \ | endif
augroup END
