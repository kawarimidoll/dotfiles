if has('nvim')
  finish
endif

augroup user_ftplugin_gleam
  autocmd!
  autocmd ColorScheme * if &filetype == 'gleam'
        \ | syntax enable
        \ | endif
augroup END
