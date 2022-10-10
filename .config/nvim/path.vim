function! path#normalize(fname, ...) abort
  let fname = expand(a:fname)

  " remove meanless part
  let fname = fname->substitute('\v^(\./)+|/$', '', '')->substitute('/\./', '/', 'g')
  while fname =~ '\v/[^/]+/\.\./'
    let fname = substitute(fname, '\v/[^/]+/\.\./', '/', 'g')
  endwhile

  if fname[0] == '/'
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

  return fnamemodify(base, modifier) .. '/' .. fname
endfunction

function! s:_join(paths) abort
  let joined = ''
  for e in a:paths
    let joined ..= substitute(e, '[^/]$', '/', '')
  endfor
  return joined
endfunction

function! path#join(...) abort
  return s:_join(a:000)
endfunction

function! path#resolve(...) abort
  return path#normalize(s:_join(a:000))
endfunction

function! path#dirname(path) abort
  return substitute(a:path, '\v/[^/]+$', '', '')
endfunction

function! path#basename(path) abort
  return substitute(a:path, '\v.*/', '', '')
endfunction

function! path#extname(path) abort
  return substitute(a:path, '\v.*\.', '.', '')
endfunction

function! path#common(paths) abort
  if len(a:paths) == 0
    return ''
  elseif len(a:paths) == 1
    return path#dirname(a:paths[0])
  endif

  let is_absolute = 0
  let split_paths = []
  for path in a:paths
    if path[0] == '~' || path[0] == '/'
      call add(split_paths, expand(path))
      let is_absolute = 1
    else
      call add(split_paths, path)
    endif
  endfor

  call map(split_paths, {_,path->split(path,'/')})
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

  return (is_absolute ? '/' : '') .. join(common_path, '/')
endfunction

function! path#relative(from, to) abort
  let common_dir = path#common([a:from, a:to])
  let from = substitute(a:from, '^' .. common_dir, '', '')
  let from = substitute(from, '\v^/|/$', '', 'g')
  let to = substitute(a:to, '^' .. common_dir, '', '')
  let to = substitute(to, '\v^/|/$', '', 'g')
  if from == to
    return ''
  endif

  if from == ''
    return to
  endif

  let from = substitute(from, '\v[^/]+', '..', 'g')

  if to == ''
    return from
  endif

  return from .. '/' .. to
endfunction

function! path#is_node_repo() abort
  if !exists('s:is_node_repo')
    let s:is_node_repo = filereadable('package.json')
  endif
  return s:is_node_repo
endfunction

function! path#resolve_node_require(basename) abort
  for b in ['.', '/index.']
    for x in ['js', 'ts', 'jsx', 'tsx']
      if filereadable(a:basename .. b .. x)
        return a:basename .. b .. x
      endif
    endfor
  endfor
  return ''
endfunction
