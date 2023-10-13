if exists('g:mi#ready')
  finish
endif
const g:mi#ready = 1

call mi#git#ensure_root()
call mi#register#clear()

autocmd TextYankPost * call mi#register#collect_yank_history(10)
autocmd BufEnter,BufReadPost * call mi#mru#save()
autocmd FileType qf ++once packadd cfilter

call mi#cmdline#proxy_let('trim', 'Trim')
call mi#cmdline#proxy_let('cfilter', 'Cfilter')
" call mi#cmdline#proxy_let('s[ubstitute]', 'Substitute')
source ~/dotfiles/.vim/autoload/mi/subs.vim
" source ~/dotfiles/.vim/autoload/mi/neighbor.vim

if has('nvim')
  call mi#cmdline#proxy_let('L[spInfo]', 'LspInfo')
  call mi#cmdline#proxy_let('P[lugSync]', 'PlugSync')
  call mi#cmdline#proxy_let('p[lugsync]', 'PlugSync')

  " https://zenn.dev/vim_jp/articles/7cc48a1df6aba5
  " in nvim, remove cwindow since fzf-lua is used instead
  command! -bang SearchToQf execute (<bang>0 ? 'vimgrepadd' : 'vimgrep') '//gj %'
else
  command! -nargs=* -range=% -complete=custom,mi#common#__compl_trim Trim <line1>,<line2>call mi#common#trim([<f-args>])
  command! -range=% DeleteBlankLines <line1>,<line2>call mi#common#delete_blank_lines()

  command! -bang SearchToQf execute (<bang>0 ? 'vimgrepadd' : 'vimgrep') '//gj %' | cwindow

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

silent! delmarks ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890
silent! delmarks!
