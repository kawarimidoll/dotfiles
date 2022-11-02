function! mi#path#separator() abort
  if !exists('s:sep')
    let s:sep = fnamemodify('.', ':p')[-1:]
  endif
  return s:sep
endfunction

function! mi#path#ensure_last_separator(path) abort
  return mi#path#trim_last_separator(a:path) .. mi#path#separator()
endfunction
function! mi#path#trim_last_separator(path) abort
  return substitute(a:path, mi#path#separator() .. '\+$', '', '')
endfunction

function! mi#path#normalize(fname, ...) abort
  let fname = expand(a:fname)

  " remove meanless part
  let fname = fname->substitute('\v^(\./)+|/$', '', '')->substitute('/\./', '/', 'g')
  while fname =~ '\v/[^/]+/\.\./'
    let fname = substitute(fname, '\v/[^/]+/\.\./', '/', 'g')
  endwhile

  if fname[0] == mi#path#separator()
    return fname
  endif

  " resolve relative path
  let base = expand(get(a:, 1, '%'))
  if !filereadable(base) && !isdirectory(base)
    throw 'does not exist: ' .. base
  endif

  let modifier = ':p:h'
  while fname =~ '^\.\./'
    " parent dir
    let fname = fname[3:]
    let modifier ..= ':h'
  endwhile

  return fnamemodify(base, modifier) .. mi#path#separator() .. fname
endfunction

function! s:_join(paths) abort
  let joined = ''
  for path in a:paths
    let joined ..= mi#path#ensure_last_separator(path)
  endfor
  return joined
endfunction

function! mi#path#join(...) abort
  return s:_join(a:000)
endfunction

function! mi#path#resolve(...) abort
  return mi#path#normalize(s:_join(a:000))
endfunction

function! mi#path#dirname(path) abort
  return substitute(a:path, '\v/[^' .. mi#path#separator() .. ']+$', '', '')
endfunction

function! mi#path#basename(path) abort
  return substitute(a:path, '\v.*' .. mi#path#separator(), '', '')
endfunction

function! mi#path#extname(path) abort
  return substitute(a:path, '\v.*\.', '.', '')
endfunction

function! mi#path#common(paths) abort
  if len(a:paths) == 0
    return ''
  elseif len(a:paths) == 1
    return mi#path#dirname(a:paths[0])
  endif

  let sep = mi#path#separator()

  let is_absolute = 0
  let split_paths = []
  for path in a:paths
    if path[0] == '~' || path[0] == sep
      call add(split_paths, expand(path))
      let is_absolute = 1
    else
      call add(split_paths, path)
    endif
  endfor

  call map(split_paths, {_,path->split(path, sep)})
  let common_path = []

  let i = 0
  let loop = 1
  while i < len(split_paths[0])
    let current = split_paths[0][i]
    for path_array in split_paths
      if i >= len(path_array) || current !=# path_array[i]
        let loop = 0
        break
      endif
    endfor
    if !loop
      break
    endif
    call add(common_path, current)
    let i += 1
  endwhile

  return (is_absolute ? sep : '') .. join(common_path, sep)
endfunction

function! mi#path#relative(from, to) abort
  let common_dir = mi#path#common([a:from, a:to])
  let sep = mi#path#separator()
  let pat =  '\v^' .. sep .. '|' .. sep .. '$'
  let from = substitute(a:from, '^' .. common_dir, '', '')
  let from = substitute(from, sep, '', 'g')
  let to = substitute(a:to, '^' .. common_dir, '', '')
  let to = substitute(to, sep, '', 'g')
  if from == to
    return ''
  endif

  if from == ''
    return to
  endif

  let from = substitute(from, '\v[^' .. sep .. ']+', '..', 'g')

  if to == ''
    return from
  endif

  return from .. sep .. to
endfunction

function! mi#path#is_node_repo() abort
  if !exists('s:is_node_repo')
    let s:is_node_repo = filereadable('package.json')
  endif
  return s:is_node_repo
endfunction

function! mi#path#resolve_node_require(basename) abort
  for b in ['.', mi#path#separator() .. 'index.']
    for x in ['js', 'ts', 'jsx', 'tsx']
      if filereadable(a:basename .. b .. x)
        return a:basename .. b .. x
      endif
    endfor
  endfor
  return ''
endfunction
