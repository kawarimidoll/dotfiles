" https://github.com/statox/FYT.vim/blob/master/autoload/FYT.vim
function! mi#highlight#on_yank(options = {}) abort
  if len(get(v:event, 'regtype', [])) == 0 || v:event.operator != 'y'
    return
  endif
  if (!exists('s:yanked_win_match_ids'))
    let s:yanked_win_match_ids = []
  endif

  let hlgroup = get(a:options, 'hlgroup', 'IncSearch')

  let start = getpos("'[")[1:2]
  let finish = getpos("']")[1:2]
  if start[0] > finish[0]
    let [start, finish] = [finish, start]
  endif
  if v:event.inclusive
    let finish[1] += 1
  endif

  let matchIds = []
  if v:event.regtype[0] == "\<C-V>"
    " blockwise-visual
    for lnum in range(start[0], finish[0])
      call add(matchIds, mi#highlight#range(hlgroup, [lnum, start[1]], [lnum, finish[1]])[0])
    endfor
  else
    let matchIds = mi#highlight#range(hlgroup, start, finish)
  endif

  let windowId = winnr()
  for matchId in matchIds
    call add(s:yanked_win_match_ids, [windowId, matchId])
  endfor

  let timeout = get(a:options, 'timeout', 1000)
  call timer_start(timeout, function('s:delete_highlight_yank'))
endfunction

function! s:delete_highlight_yank(timer_id) abort
  if (!exists('s:yanked_win_match_ids'))
    let s:yanked_win_match_ids = []
  endif
  while !empty(s:yanked_win_match_ids)
    try
      let [windowId, matchId] = remove(s:yanked_win_match_ids, 0)
      call matchdelete(matchId, windowId)
    endtry
  endwhile
endfunction

function! mi#highlight#range(hlgroup, start, finish)
  if type(a:hlgroup) != v:t_string ||
        \ type(a:start) != v:t_list ||
        \ len(a:start) != 2 ||
        \ type(a:finish) != v:t_list ||
        \ len(a:finish) != 2
    throw 'invalid type'
  endif

  let [start, finish] = [a:start, a:finish]
  if a:start[0] > a:finish[0]
    let [start, finish] = [a:finish, a:start]
  endif

  if start[0] == finish[0]
    let pos = [[start[0], start[1], finish[1] - start[1]]]
    return [matchaddpos(a:hlgroup, pos)]
  endif

  let matchIds = [
        \   mi#highlight#range(a:hlgroup, start, [start[0], v:maxcol])[0],
        \   mi#highlight#range(a:hlgroup, [finish[0], 1], finish)[0],
        \ ]
  if start[0] + 1 < finish[0]
    for lnum in range(start[0] + 1, finish[0] - 1)
      call add(matchIds, matchaddpos(a:hlgroup, [lnum]))
    endfor
  endif

  return matchIds
endfunction

" https://osyo-manga.hatenadiary.org/entry/20140121/1390309901
function! mi#highlight#cursorword(hlgroup)
  let c_char = getline('.')[col('.') - 1]
  if c_char !~ '\k'
    call s:clear_hl_cursorword()
    return
  endif

  let word = expand('<cword>')
  if get(b:, 'highlight_cursor_word', '') ==# word
    return
  endif

  call s:clear_hl_cursorword()

  let pattern = printf("\\V\\<%s\\>", word)
  silent! let b:highlight_cursor_word_id = matchadd(a:hlgroup, pattern, -1)
  let b:highlight_cursor_word = word
endfunction

if !exists('s:clear_autocmd_set')
  augroup mi#highlight#augroup
    autocmd BufLeave,WinLeave,InsertEnter * call s:clear_hl_cursorword()
  augroup END
  let s:clear_autocmd_set = 1
endif

function! s:clear_hl_cursorword()
  if exists('b:highlight_cursor_word_id') && exists('b:highlight_cursor_word')
    silent! call matchdelete(b:highlight_cursor_word_id)
    unlet! b:highlight_cursor_word_id
    unlet! b:highlight_cursor_word
  endif
endfunction
