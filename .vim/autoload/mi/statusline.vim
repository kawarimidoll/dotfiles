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
    return s:mode_str(m) .. ' %<%f%h%m%r%=%l,%c%V ' .. lines
  catch
    " to avoid to hang up when error in statusline
    echoerr v:exception
    return ''
  endtry
endfunction

function! mi#statusline#inactive()
  try
    return '%F%='
  catch
    " to avoid to hang up when error in statusline
    echoerr v:exception
    return ''
  endtry
endfunction

function! s:mode_str(mode)
  if a:mode =~ '^no'
    let m = 'OPE'
  elseif a:mode =~ '^ni'
    let m = 'N--'
  elseif a:mode == 'n'
    let m = 'NOR'
  elseif a:mode =~# '^v'
    let m = 'VIS'
  elseif a:mode =~# '^V'
    let m = 'V-L'
  elseif a:mode =~# "^\<c-v>"
    let m = 'V-B'
  elseif a:mode =~# '^s'
    let m = 'SEL'
  elseif a:mode =~# '^S'
    let m = 'S-L'
  elseif a:mode =~# "^\<c-s>"
    let m = 'S-B'
  elseif a:mode =~# '^i'
    let m = 'INS'
  elseif a:mode =~# '^R'
    let m = 'REP'
  elseif a:mode =~# '^c'
    let m = 'CMD'
  elseif a:mode =~# '^r'
    let m = 'PRO'
  elseif a:mode ==# '!'
    let m = '!SH'
  elseif a:mode ==# 't'
    let m = 'TER'
  else
    let m = '-?-'
  endif
  return printf('[%s]', m)
endfunction
