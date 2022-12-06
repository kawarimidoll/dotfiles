" https://zenn.dev/uochan/articles/2021-12-08-vim-conventional-commits
nnoremap <buffer> <CR>
      \ <Cmd>silent! execute 'normal! ^w"zdiw"_dip"zPA: ' <bar> startinsert!<CR>

call cursor(1, 1)
let fold_pattern = 'Changes not staged for commit:\|Untracked files:'
let fold_from = search(fold_pattern, 'n')
if fold_from
  execute fold_from .. ',/--- >8 ---/fold'
endif

if exists('b:undo_ftplugin')
  let b:undo_ftplugin ..= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin ..= 'nunmap <buffer> <CR>'
