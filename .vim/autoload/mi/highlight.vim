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
" https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/cursorword.lua
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

function! s:clear_hl_cursorword()
  if exists('b:highlight_cursor_word_id') && exists('b:highlight_cursor_word')
    silent! call matchdelete(b:highlight_cursor_word_id)
    unlet! b:highlight_cursor_word_id
    unlet! b:highlight_cursor_word
  endif
endfunction

function! mi#highlight#syn_attr(expr = '.', trans = 1)
  let [lnum, col] = getpos(a:expr)[1:2]
  let id = synID(lnum, col, a:trans)
  return { 'name': synIDattr(id, 'name'),
        \  'fg': synIDattr(id, 'fg'),
        \  'bg': synIDattr(id, 'bg'),
        \  'font': synIDattr(id, 'font'),
        \  'sp': synIDattr(id, 'sp'),
        \  'ul': synIDattr(id, 'ul'),
        \  'fg#': synIDattr(id, 'fg#'),
        \  'bg#': synIDattr(id, 'bg#'),
        \  'sp#': synIDattr(id, 'sp#'),
        \  'bold': synIDattr(id, 'bold'),
        \  'italic': synIDattr(id, 'italic'),
        \  'reverse': synIDattr(id, 'reverse'),
        \  'inverse': synIDattr(id, 'inverse'),
        \  'standout': synIDattr(id, 'standout'),
        \  'underline': synIDattr(id, 'underline'),
        \  'undercurl': synIDattr(id, 'undercurl'),
        \  'strike': synIDattr(id, 'strike'),
        \ }
endfunction

" :h match-parens
function! mi#highlight#match_paren(hlgroup) abort
  call s:clear_hl_paren()

  let [c_lnum, c_col] = getpos('.')[1:2]

  let current_char = getline(c_lnum)[c_col - 1]
  let plist = split(&matchpairs, ':\|,')
  let i = index(plist, current_char)
  if i < 0
    return
  endif

  if i % 2 == 0
    let s_flags = 'nW'
    let p_open = current_char
    let p_close = plist[i + 1]
  else
    let s_flags = 'nbW'
    let p_open = plist[i - 1]
    let p_close = current_char
  endif

  if p_open == '['
    let p_open = '\['
    let p_close = '\]'
  endif

  let [m_lnum, m_col] = searchpairpos(p_open, '', p_close, s_flags)

  if m_lnum > 0 && m_lnum >= line('w0') && m_lnum <= line('w$')
    let s:paren_hl_id = matchaddpos(a:hlgroup, [[c_lnum, c_col], [m_lnum, m_col]])
  endif
endfunction

function! s:clear_hl_paren()
  if exists('s:paren_hl_id')
    silent! call matchdelete(s:paren_hl_id)
    unlet! s:paren_hl_id
  endif
endfunction

function! mi#highlight#get(group) abort
  let result = {}
  try
    let output = execute('highlight ' .. a:group)
  catch /^Vim\%((\a\+)\)\=:E411:/
    " no such highlight
    return result
  endtry

  if output =~ '.*links\s\+to\>'
    let link_to = substitute(output, '.*links\s\+to\>\s\+', '', '')
    return mi#highlight#get(link_to)
  endif

  let settings = substitute(output, '.*xxx\s\+', '', '')
        \ ->split('\s\+')

  for kv in settings
    let [k, v] = split(kv, '=')
    let result[k] = v
  endfor

  return [a:group, result]
endfunction

function! mi#highlight#set(group, settings) abort
  execute 'highlight' a:group
        \ a:settings->items()->map('join(v:val, "=")')->join(' ')
endfunction

" {{{ MergeHighlight
" https://zenn.dev/kawarimidoll/articles/cf6caaa7602239
function! s:merge_highlight(args) abort
  let l:args = split(a:args)
  if len(l:args) < 2
    echoerr '[MergeHighlight] At least 2 arguments are required.'
    echoerr 'New highlight name and source highlight names.'
    return
  endif

  " skip 'links' and 'cleared'
  execute 'highlight' l:args[0] l:args[1:]
      \ ->map({_, val -> execute('highlight ' .. val)->substitute('^\S\+\s\+xxx\s', '', '')})
      \ ->filter({_, val -> val !~? '^links to' && val !=? 'cleared'})
      \ ->join()
endfunction
" Set in vimrc:
"  command! -nargs=+ -complete=highlight MergeHighlight call s:merge_highlight(<q-args>)
" Use like this:
"  MergeHighlight markdownH1 Red Bold
" }}}

if !exists('s:clear_autocmd_set')
  augroup mi#highlight#augroup
    autocmd BufLeave,WinLeave,InsertEnter * call s:clear_hl_cursorword()
    autocmd BufLeave,WinLeave,InsertEnter * call s:clear_hl_paren()
  augroup END
  let s:clear_autocmd_set = 1
endif
