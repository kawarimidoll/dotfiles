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
    return $'[{s:mode_str(m)}] %<%f%h%m%r%=%l,%c%V {lines}'
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

function! s:mode_str(mode)
  return a:mode =~ '^no' ? 'OPE'
        \ : a:mode =~ '^ni' ? 'N--'
        \ : a:mode == 'n' ? 'NOR'
        \ : a:mode =~# '^v' ? 'VIS'
        \ : a:mode =~# '^V' ? 'V-L'
        \ : a:mode =~# "^\<c-v>" ? 'V-B'
        \ : a:mode =~# '^s' ? 'SEL'
        \ : a:mode =~# '^S' ? 'S-L'
        \ : a:mode =~# "^\<c-s>" ? 'S-B'
        \ : a:mode =~# '^i' ?
        \   &iminsert ? 'IIM'
        \   : exists('*tuskk#is_enabled') && tuskk#is_enabled() ? 'SKK'
        \   : 'INS'
        \ : a:mode =~# '^R' ? 'REP'
        \ : a:mode =~# '^c' ?
        \   &iminsert ?
        \     'CIM'
        \   : 'CMD'
        \ : a:mode =~# '^r' ? 'PRO'
        \ : a:mode ==# '!' ? '!SH'
        \ : a:mode ==# 't' ? 'TER'
        \ : '-?-'
endfunction

function! mi#statusline#horizontal_line()
  return repeat('-', &columns)
endfunction
