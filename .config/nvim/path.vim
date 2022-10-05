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
  let split_paths = map(copy(a:paths), {_,path->split(path,'/')})
  let common_path = []

  let i = 0
  let loop = 1
  while loop
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

  return join(common_path, '/')
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
