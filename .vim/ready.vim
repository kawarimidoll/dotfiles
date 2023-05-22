if exists('g:mi#ready')
  finish
endif
const g:mi#ready = 1

delfunction! EditProjectMru

call mi#git#ensure_root()
call mi#register#clear()

autocmd TextYankPost * call mi#register#collect_yank_history(10)
autocmd BufEnter,BufReadPost * call mi#mru#save()
autocmd FileType qf ++once packadd cfilter

call mi#cmdline#proxy_let('trim', 'Trim')
call mi#cmdline#proxy_let('cfilter', 'Cfilter')

if has('nvim')
" currently no commands
else
  command! -nargs=* -range=% -complete=custom,mi#common#__compl_trim Trim <line1>,<line2>call mi#common#trim([<f-args>])

  " https://www.statox.fr/posts/2020/07/vim_flash_yanked_text/
  autocmd CursorMoved * call mi#highlight#cursorword('Underlined')
  autocmd CursorMoved,CursorMovedI * call mi#highlight#match_paren('Underlined')
  autocmd TextYankPost * silent! call mi#highlight#on_yank({'timeout': 500})
  autocmd WinEnter * call mi#qf#quit_if_last_buf()
  autocmd FileType qf call mi#qf#fit_window({'min': 3, 'max': 10})

  source ~/dotfiles/.vim/autoload/mi/searchprop.vim
  source ~/dotfiles/.vim/autoload/mi/substitutor.vim

  call mi#pair#keymap_set(['{}', '[]', '()', "''", '""', '``'])

  highlight! link StatusLine GamingBg
  highlight! link StatusLineNC GamingFg
  call mi#gaming#start()
endif
