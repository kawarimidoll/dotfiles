" " sample
" nnoremap s1 <cmd>call mi#virt_mark#display(line('.'), col('.'), 'foo', 'my_group', 'IncSearch', 'overlay')<cr>
" nnoremap s2 <cmd>call mi#virt_mark#display(line('.'), col('.'), 'bar', 'my_group', 'Visual', 'inline')<cr>
" nnoremap s3 <cmd>call mi#virt_mark#display(line('.'), col('.'), 'baz', 'my_group', 'Search', 'eol')<cr>
" nnoremap s4 <cmd>call mi#virt_mark#display(line('.'), col('.'), 'quz', 'my_group', 'ErrorMsg', 'right_align')<cr>
" nnoremap sn <cmd>call mi#virt_mark#clear('my_group')<cr>

function! s:valid_pos_arg(pos) abort
  return index(['eol', 'right_align', 'overlay', 'inline'], a:pos) >= 0
endfunction

let s:marker_id = 0

if has('nvim')
  let s:ns_ids = {}

  function! mi#virt_mark#clear(group) abort
    if !has_key(s:ns_ids, a:group)
      return
    endif
    call nvim_buf_clear_namespace(0, s:ns_ids[a:group], 0, -1)
    unlet! s:ns_ids[a:group]
  endfunction

  function! mi#virt_mark#display(lnum, col, text, group, hl, pos) abort
    if !s:valid_pos_arg(a:pos)
      throw '[mi#virt_mark] Invalid position argument: ' .. a:pos
    endif

    if !has_key(s:ns_ids, a:group)
      let s:ns_ids[a:group] = nvim_create_namespace(a:group)
      " echomsg s:ns_ids
    endif

    let s:marker_id += 1

    " line and col in nvim_buf_set_extmark are 0-based
    let line = a:lnum - 1
    let col = max([0, a:col - 1])

    call nvim_buf_set_extmark(0, s:ns_ids[a:group], line, col, {
          \   'id': s:marker_id,
          \   'end_line': line,
          \   'end_col': col + strchars(a:text),
          \   'virt_text': [[a:text, a:hl]],
          \   'virt_text_pos': a:pos,
          \   'priority': 1000,
          \ })
  endfunction
else
  let s:prop_types = {}

  function! mi#virt_mark#clear(group) abort
    if !has_key(s:prop_types, a:group)
      return
    endif
    for prop_type in s:prop_types[a:group]
      call prop_type_delete(prop_type, {})
    endfor
    unlet! s:prop_types[a:group]
  endfunction

  function! mi#virt_mark#display(lnum, col, text, group, hl, pos) abort
    if !s:valid_pos_arg(a:pos)
      throw '[mi#virt_mark] Invalid position argument: ' .. a:pos
    endif

    let prop_type = a:group .. '-' .. a:hl
    if empty(prop_type_get(prop_type))
      call prop_type_add(prop_type, {'highlight': a:hl})
      if !has_key(s:prop_types, a:group)
        let s:prop_types[a:group] = []
      endif
      call add(s:prop_types[a:group], prop_type)
    endif

    let s:marker_id += 1

    if a:pos ==# 'overlay'
      call s:add_overlay(a:lnum, a:col, a:text, prop_type, a:hl)
      return
    endif

    let col = a:pos ==# 'inline' ? a:col : 0
    let opts =  {
          \ 'type': prop_type,
          \ 'id': s:marker_id,
          \ 'text': a:text,
          \ }
    if a:pos ==# 'eol'
      let opts.text_align = 'after'
      let opts.text_padding_left = 1
    elseif a:pos ==# 'right_align'
      let opts.text_align = 'right'
    endif

    call prop_add(a:lnum, col, opts)
  endfunction

  function! s:add_overlay(lnum, col, text, prop_type, hl) abort
    call prop_add(a:lnum, a:col, {
          \ 'type': a:prop_type,
          \ 'id': s:marker_id,
          \ })
    call popup_create(a:text, {
          \ 'line': -1,
          \ 'col': 0,
          \ 'textprop': a:prop_type,
          \ 'textpropid': s:marker_id,
          \ 'highlight': a:hl
          \ })
  endfunction
endif
