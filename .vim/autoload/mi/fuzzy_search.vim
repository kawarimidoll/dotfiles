" ===========
" =   WIP   =
" ===========

function! s:fuzzy_search_start(direction, restore = 0) abort
  if a:direction != '/' && a:direction != '?'
    throw '[fuzzy_search] direction must be / or ?.'
  endif

  if a:restore
    let s:query = get(s:, 'query', '')
  else
    let s:query = ''
  endif

  while 1
    if s:query == ''
      call s:fuzzy_search_clear()
    else
      " escape characters and join by .\{-} (any character, as few as possible)
      let s:fuzzy_search_pattern = '\c.\{-}\zs' .. join(map(split(s:query, '\zs'), "escape(v:val, '^.$/')"), '.\{-}')
      call s:apply_fuzzy_highlight('IncSearch')
    endif
    redraw

    echo '[fuzzy_search]' a:direction '>' s:query

    let nr = getchar()
    if nr == 27
      " escape
      let s:fuzzy_search_pattern = ''
      call s:fuzzy_search_clear()
      redraw
      echo ''
      break
    endif

    if nr == "\x80kb" || nr == 8
      " backspace
      let s:query = slice(s:query, 0, -1)
    else
      let char = nr2char(nr)
      if char == "\<cr>"
        " enter
        call s:fuzzy_search_repeat(a:direction == '/' ? 'n' : 'N', 1)
        break
      elseif 31 < nr && nr < 127
        " only ascii characters
        let s:query ..= char
      endif
    endif
  endwhile
endfunction

function! s:apply_fuzzy_highlight(hlgroup) abort
  call s:fuzzy_search_clear()
  silent! let b:fuzzy_hl_id = matchadd(a:hlgroup, s:fuzzy_search_pattern)
endfunction
function! s:fuzzy_search_clear() abort
  if !exists('b:fuzzy_hl_id')
    return
  endif
  silent! call matchdelete(b:fuzzy_hl_id)
  unlet! b:fuzzy_hl_id
endfunction

let s:last_search = getreg('/')

function! s:fuzzy_search_repeat(direction, force = 0) abort
  if a:direction !=? 'n'
    throw '[fuzzy_search] direction must be n or N.'
  endif

  if !exists('s:fuzzy_search_pattern')
    let s:fuzzy_search_pattern = ''
  endif
  if !a:force
    let current_search = getreg('/')
    if s:last_search != current_search
      let s:fuzzy_search_pattern = current_search
    endif
  endif
  if s:fuzzy_search_pattern == ''
    return
  endif

  let dir_flag = a:direction ==# 'n' ? '' : 'b'

  call s:apply_fuzzy_highlight('Search')
  let [lnum, col] = searchpos(s:fuzzy_search_pattern, 'nw' .. dir_flag)

  if lnum == 0
    return
  endif
  call cursor(lnum, col)
endfunction

augroup mi#fuzzy_search#autocmd
  autocmd!
  autocmd CmdlineEnter [/?] let s:fuzzy_search_pattern = ''
augroup END

nnoremap s<cr> <cmd>call <sid>fuzzy_search_start('/')<cr>
nnoremap s<bs> <cmd>call <sid>fuzzy_search_start('/', v:true)<cr>
nnoremap sn <cmd>call <sid>fuzzy_search_repeat('n')<cr>
nnoremap sN <cmd>call <sid>fuzzy_search_repeat('N')<cr>
nnoremap <C-l> <Cmd>nohlsearch<Bar>diffupdate<Bar>call <sid>fuzzy_search_clear()<Bar>normal! <C-l><CR>
