" https://zenn.dev/kawarimidoll/articles/4564e6e5c2866d
setlocal comments=nb:>
      \ comments+=b:*\ [\ ],b:*\ [x],b:*
      \ comments+=b:+\ [\ ],b:+\ [x],b:+
      \ comments+=b:-\ [\ ],b:-\ [x],b:-
      \ comments+=b:1.\ [\ ],b:1.\ [x],b:1.
      \ formatoptions-=c formatoptions+=jro

function! s:markdown_checkbox() abort
  let from = line('.')
  let to = line('v')
  if from > to
    let [from, to] = [to, from]
  endif

  let curpos = getcursorcharpos()

  let lnum = from
  while lnum <= to
    let line = getline(lnum)

    let list_pattern = '\v^\s*([*+-]|\d+\.)\s+'
    if line !~ list_pattern
      " not list -> add list marker and blank box
      let line = substitute(line, '\v\S|$', '- [ ] \0', '')
      if lnum == curpos[1]
        let curpos[2] += 6
      endif
    elseif line =~ list_pattern .. '\[ \]\s+'
      " blank box -> check
      let line = substitute(line, '\[ \]', '[x]', '')
    elseif line =~ list_pattern .. '\[x\]\s+'
      " checked box -> uncheck
      let line = substitute(line, '\[x\]', '[ ]', '')
    else
      " list but no box -> add box after list marker
      let line = substitute(line, '\v\S+', '\0 [ ]', '')
      " let line = substitute(line, '\v([*+-]|\d+\.)', '\0 [ ]', '')
      if lnum == curpos[1]
        let curpos[2] += 4
      endif
    endif

    call setline(lnum, line)
    let lnum += 1
  endwhile
  call setcursorcharpos(curpos[1], curpos[2])
endfunction

nnoremap <buffer> <CR> <Cmd>call <sid>markdown_checkbox()<CR>
xnoremap <buffer> <CR> <Cmd>call <sid>markdown_checkbox()<CR>
if has('nvim')
  inoremap <buffer> <C-CR> <Cmd>call <sid>markdown_checkbox()<CR>
endif

function! s:markdown_outline() abort
  let fname = @%
  let current_win_id = win_getid()

  " # heading
  execute 'vimgrep /^#\{1,6} .*$/j' fname

  " heading
  " ===
  execute 'vimgrepadd /\zs\S\+\ze\n[=-]\+$/j' fname

  let qflist = getqflist()
  if len(qflist) == 0
    cclose
    return
  endif

  " make sure to focus original window because synID works only in current window
  call win_gotoid(current_win_id)
  call filter(qflist,
        \ 'synIDattr(synID(v:val.lnum, v:val.col, 1), "name") != "markdownCodeBlock"'
        \ )
  call sort(qflist, {a,b -> a.lnum - b.lnum})
  call setqflist(qflist)
  call setqflist([], 'r', {'title': fname .. ' TOC'})
  copen
endfunction

nnoremap <buffer> gO <Cmd>silent call <sid>markdown_outline()<CR>

function! s:markdown_open_wikilink() abort
  " cursor is in wikilink like [[filename]], [[filename | display]]
  if search('\V[[', 'bcn', line('.')) > 0 && search('\V]]', 'cn', line('.')) > 0

    call search('[[', 'bce', line('.'))
    noautocmd normal! l

    " save current z register
    const save_reg = getreginfo('z')

    " get file name through z register
    if search('|.{-}]]', 'cn', line('.')) > 0
      " [[filename]]
      noautocmd normal! "zyt|
    else
      " [[filename | display]]
      noautocmd normal! "zyi[
    endif
    const fname = escape(trim(@z, ' '), ' ') .. '.md'

    " restore z register
    call setreg('z', save_reg)

    " use timer to avoid error about re-define this function
    return timer_start(1, {->execute('edit ' .. fname)})
  endif

  " fallback
  call mi#open#smart_open()
endfunction

nnoremap <buffer> gf <Cmd>call <sid>markdown_open_wikilink()<CR>
nnoremap <buffer> so <Cmd>Arto<CR>

if exists('b:undo_ftplugin')
  let b:undo_ftplugin ..= '|'
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin ..= 'setlocal comments< formatoptions<'
let b:undo_ftplugin ..= '| silent! nunmap <buffer> <CR>'
let b:undo_ftplugin ..= '| silent! xunmap <buffer> <CR>'
let b:undo_ftplugin ..= '| silent! iunmap <buffer> <C-CR>'
let b:undo_ftplugin ..= '| silent! nunmap <buffer> gO'
let b:undo_ftplugin ..= '| silent! nunmap <buffer> gf'
