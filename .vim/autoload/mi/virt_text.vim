" sample
" nnoremap sm <cmd>call mi#virt_text#display(line('.'), col('.'), getcharstr(), 'aak', 'overlay')<cr>
" nnoremap sk <cmd>call mi#virt_text#display(line('.'), col('.'), getcharstr(), 'aak', 'inline')<cr>
" nnoremap sn <cmd>call mi#virt_text#clear('aak')<cr>

function! s:valid_pos_arg(pos) abort
  " currently 'right_align' is not supported
  return index(['eol', 'overlay', 'inline'], a:pos)
endfunction

let s:namespaces = {}
let g:default_highlight = 'IncSearch'
let s:marker_id = 0

if has('nvim')
  function! mi#virt_text#add_group(group, hl) abort
    let s:namespaces[a:group] = {
          \ 'ns_id': nvim_create_namespace(a:group),
          \ 'marker_ids': [],
          \ 'highlight': a:hl}
  endfunction

  function! mi#virt_text#clear(group) abort
    for marker_id in s:namespaces[a:group].marker_ids
      call nvim_buf_del_extmark(0, s:namespaces[a:group].ns_id, marker_id)
    endfor
  endfunction

  function! mi#virt_text#delete_group(group) abort
    call nvim_buf_clear_namespace(0, a:group, 0, -1)
    unlet! s:namespaces[a:group]
  endfunction

  function! mi#virt_text#display(lnum, col, text, group, pos = 'eol') abort
    if !s:valid_pos_arg(a:pos)
      throw 'Invalid position argument'
    endif

    if !has_key(s:namespaces, a:group)
      call mi#virt_text#add_group(a:group, g:default_highlight)
    endif

    let s:marker_id += 1
    call add(s:namespaces[a:group].marker_ids, s:marker_id)

    " line and col in nvim_buf_set_extmark are 0-based
    let line = a:lnum - 1
    let col = max([0, a:col - 1])

    call nvim_buf_set_extmark(0, s:namespaces[a:group].ns_id, line, col, {
          \   'id': s:marker_id,
          \   'end_line': line,
          \   'end_col': col + strchars(a:text),
          \   'virt_text': [[a:text, s:namespaces[a:group].highlight]],
          \   'virt_text_pos': a:pos,
          \   'priority': 1000,
          \ })
  endfunction
else
  function! mi#virt_text#add_group(group) abort
    call prop_type_delete(a:group, {})
    call prop_type_add(a:group, {})
    call add(s:namespace_list, a:group)
  endfunction

  function! mi#virt_text#clear_group(group) abort
    call prop_clear(1, line('$'), {'type': a:group})
    call prop_type_delete(a:group, {})
    call filter(s:namespace_list, {_,val -> val !=# a:group})
  endfunction
endif
