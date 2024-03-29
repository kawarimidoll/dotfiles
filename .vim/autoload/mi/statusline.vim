function! mi#statusline#active()
  try
    let m = mode(1)
    if m =~# '^v'
      let [cl, cc] = getcharpos('.')[1:2]
      let [vl, vc] = getcharpos('v')[1:2]
      let lines = (cl == vl ? abs(cc - vc) : abs(cl - vl)) + 1
    elseif m =~# '^V'
      let lines = abs(line('.') - line('v')) + 1
    elseif m =~# "^\<c-v>"
      let [cl, cc] = getcharpos('.')[1:2]
      let [vl, vc] = getcharpos('v')[1:2]
      let lines = printf('%sx%s', abs(cl - vl) + 1, abs(cc - vc) + 1)
    else
      let lines = '%P'
    endif
    return $'[{mi#statusline#mode_str()}] %<%f%h%m%r%=%l,%c%V {lines}'
  catch
    " to avoid to hang up when error in statusline
    echomsg v:exception
    return ''
  endtry
endfunction

function! mi#statusline#inactive()
  try
    return '%F%='
  catch
    " to avoid to hang up when error in statusline
    echomsg v:exception
    return ''
  endtry
endfunction

function! mi#statusline#mode_str()
  let m = mode(1)
  return m =~ '^no' ? 'OPE'
        \ : m =~ '^ni' ? 'N--'
        \ : m == 'n' ? 'NOR'
        \ : m =~# '^v' ? 'VIS'
        \ : m =~# '^V' ? 'V-L'
        \ : m =~# "^\<c-v>" ? 'V-B'
        \ : m =~# '^s' ? 'SEL'
        \ : m =~# '^S' ? 'S-L'
        \ : m =~# "^\<c-s>" ? 'S-B'
        \ : m =~# '^i' ?
        \   &iminsert ? 'IIM'
        \   : exists('*tuskk#is_enabled') && tuskk#is_enabled() ? 'SKK'
        \   : 'INS'
        \ : m =~# '^R' ? 'REP'
        \ : m =~# '^c' ?
        \   &iminsert ?
        \     'CIM'
        \   : 'CMD'
        \ : m =~# '^r' ? 'PRO'
        \ : m ==# '!' ? '!SH'
        \ : m ==# 't' ? 'TER'
        \ : '-?-'
endfunction

function! mi#statusline#horizontal_line()
  return repeat('-', &columns)
endfunction
