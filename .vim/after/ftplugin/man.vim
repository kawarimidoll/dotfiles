setlocal iskeyword-=(
setlocal iskeyword-=)

nnoremap <buffer> K <Plug>ManPreGetPage

if exists('b:undo_ftplugin')
  let b:undo_ftplugin ..= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin ..= 'setlocal iskeyword<'
let b:undo_ftplugin ..= '| silent! nunmap <buffer> K'
