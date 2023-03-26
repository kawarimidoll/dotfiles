setlocal number
setlocal nobuflisted

nnoremap <buffer> xx <cmd>call mi#qf#remove()<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin ..= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin ..= 'setlocal number< buflisted<'
let b:undo_ftplugin ..= '| silent! nunmap <buffer> xx'
