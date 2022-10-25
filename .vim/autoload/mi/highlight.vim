" https://github.com/statox/FYT.vim/blob/master/autoload/FYT.vim
function! mi#highlight#on_yank(options = {}) abort
  if len(get(v:event, 'regtype', [])) == 0 || v:event.operator != 'y'
    return
  endif
  if (!exists('s:yanked_win_match_ids'))
    let s:yanked_win_match_ids = []
  endif

  let windowId = winnr()

  let matchPattern = ".\\%>'\\[\\_.*\\%<'].."
  if v:event.regtype[0] == "\<C-V>"
    " blockwise-visual
    let lineStart = line("'<") - 1
    let lineStop = line("'>") + 1
    let columnStart = col("'<") - 1
    let columnStop = col("'>") + 1
    " :h /\%l /\%c
    let matchPattern = "\\%>" .. lineStart .. "l\\%<" .. lineStop .. "l\\%>" .. columnStart .. "c\\%<" .. columnStop .. "c"
  endif

  let highlight_group = get(a:options, 'highlight_group', 'IncSearch')
  let matchId = matchadd(highlight_group, matchPattern)

  call add(s:yanked_win_match_ids, [windowId, matchId])

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

  let pattern = printf("\\<%s\\>", word)
  silent! let b:highlight_cursor_word_id = matchadd(a:hlgroup, pattern)
  let b:highlight_cursor_word = word

  if !exists('s:clear_autocmd_set')
    autocmd BufLeave,WinLeave,InsertEnter * call s:clear_hl_cursorword()
    let s:clear_autocmd_set = 1
  endif
endfunction

function! s:clear_hl_cursorword()
  if exists('b:highlight_cursor_word_id') && exists('b:highlight_cursor_word')
    silent! call matchdelete(b:highlight_cursor_word_id)
    unlet! b:highlight_cursor_word_id
    unlet! b:highlight_cursor_word
  endif
endfunction
