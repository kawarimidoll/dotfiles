" deprecated
" Use vim's official open plugin instead
" {{{ mi#open#smart_open
function! mi#open#smart_open(query = '') abort
  " get query
  let query = get(a:, 'query', '')
  if query == ''
    let m = mode()
    if m == 'n'
      let query = expand('<cfile>')
    elseif m ==? 'v'
      normal! "zy
      let query = @z
    else
      throw 'this mode is not supported'
    endif
  endif
  let query = substitute(trim(query), '[[:space:]]\+', ' ', 'g')

  " is file path
  let fname = expand(query)
  if filereadable(fname)
    execute 'edit' fname
    return
  endif

  try
    let fname = mi#path#normalize(query)

    if filereadable(fname)
      execute 'edit' fname
      return
    endif

    if mi#path#is_node_repo()
      " resolve node path
      let node_require = mi#path#resolve_node_require(fname)
      if node_require != ''
        execute 'edit' node_require
        return
      endif
    endif
  catch
    " skip error
  endtry

  if query =~# '^https\?://'
    " is url
    let cmd = 'open "' .. query .. '"'
  elseif query =~# '\v^\w([.-]?\w)*/\w([.-]?\w)*$'
    " is repo
    let cmd = 'open "https://github.com/' .. query .. '"'
  elseif confirm('Are you sure to search: ' .. query, "Yes\nNo", 2) == 1
    " encode query
    " https://gist.github.com/atripes/15372281209daf5678cded1d410e6c16?permalink_comment_id=3634542#gistcomment-3634542
    let safe_query = ''
    for i in range(len(query))
      if query[i] =~ '[-._~[:alnum:]]'
        let safe_query ..= query[i]
      else
        let safe_query ..= printf('%%%02x', char2nr(query[i]))
      endif
    endfor

    " search online
    let cmd = 'open "https://google.com/search?q=' .. safe_query .. '"'
  else
    " quit
    return
  endif

  echo cmd

  " https://github.com/voldikss/vim-browser-search/blob/master/autoload/search.vim
  if exists('*jobstart')
    call jobstart(cmd)
  elseif exists('*job_start')
    call job_start(cmd)
  else
    call system(cmd)
  end
endfunction
" }}}

" {{{ edit_with_number
" https://github.com/wsdjeg/vim-fetch/blob/master/autoload/fetch.vim
function! mi#open#reopen_with_lnum() abort
  let filename = expand('%')
  let regex = '\v%(:\d+){1,2}%(:.*)?$'

  let pos_match = matchstr(filename, regex)
  if pos_match == ''
    return
  endif

  let positions = split(pos_match, ':')
  let lnum = positions[0]
  let col = get(positions, 1, 1)
  let filename = substitute(filename, regex, '', '')

  set buftype=nowrite bufhidden=delete
  execute 'keepalt edit' fnameescape(filename)
  call setcharpos('.', [0, lnum, col, 0])
  normal! zz
endfunction
" }}}
