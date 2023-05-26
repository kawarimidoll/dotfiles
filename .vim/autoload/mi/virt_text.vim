let s:namespace_list = []

if has('nvim')
  function! mi#virt_text#add_group(group) abort
    call nvim_create_namespace(a:group)
    call add(s:namespace_list, a:group)
  endfunction

  function! mi#virt_text#clear_group(group) abort
    call nvim_buf_clear_namespace(0, a:group, 0, -1)
    call filter(s:namespace_list, {_,val -> val !=# a:group})
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
