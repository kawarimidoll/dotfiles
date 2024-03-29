function! s:project_root() abort
  let root = mi#git#get_root()
  if root == ''
    return root
  endif
  return mi#path#ensure_last_separator(root)
endfunction

function! s:init_mru() abort
  let root = s:project_root()
  if root == ''
    return v:oldfiles
  endif

  let root_pattern = '^' .. root
  let mru = []
  for file in v:oldfiles
    let file = expand(file)
    if file =~ root_pattern && file !~ '\.git/' && filereadable(file)
      call add(mru, file)
    endif
  endfor
  return mru
endfunction

function! mi#mru#save(file = '%') abort
  if !exists('s:project_mru')
    let s:project_mru = s:init_mru()
  endif
  let root_pattern = '^' .. s:project_root()
  let file = fnamemodify(expand(a:file), ':p')
  if file =~ root_pattern && file !~ '\.git/' && filereadable(file)
    let file = substitute(file, root_pattern, '', '')
    call insert(filter(s:project_mru, 'v:val != file'), file, 0)
  endif
endfunction

function! mi#mru#list(full_path = v:false) abort
  if !exists('s:project_mru')
    let s:project_mru = s:init_mru()
  endif
  if a:full_path
    return s:project_mru
  endif

  let root = s:project_root()

  if root == ''
    return s:project_mru
  endif

  let root_pattern = '^' .. root
  return map(copy(s:project_mru), "substitute(v:val, root_pattern, '', '')")
endfunction

if !has('nvim')
  let s:popup_keys = '0123456789abcdefghijklmnopqrstuvwxyz'
  function! s:selector_with_num()
    let options = { 'title': ' MRU ' }
    let list = mi#mru#list()[:36]

    function! s:num_key_filter(id, key) abort closure
      let idx = stridx(s:popup_keys, a:key)
      if idx >= 0
        return popup_close(a:id, idx)
      endif
      return popup_filter_menu(a:id, a:key)
    endfunction
    let options.filter = 's:num_key_filter'

    function! s:edit_selected(_, selected) abort closure
      if a:selected < 0
        return
      endif
      execute 'edit' list[a:selected]
    endfunction
    let options.callback = 's:edit_selected'

    call popup_menu(copy(list)->map({key, val -> s:popup_keys[key] .. '  ' .. val}), options)
  endfunction

  command! EditMru call s:selector_with_num()
  " nnoremap <space>h <Cmd>EditMru<CR>
endif
