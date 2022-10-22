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
  while !empty(s:yanked_win_match_ids)
    try
      let [windowId, matchId] = remove(s:yanked_win_match_ids, 0)
      call matchdelete(matchId, windowId)
    endtry
  endwhile
endfunction
