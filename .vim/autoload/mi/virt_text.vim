" sample
" nnoremap sm <cmd>call mi#virt_text#display(line('.'), col('.'), getcharstr(), 'aak', 'overlay')<cr>
" nnoremap sk <cmd>call mi#virt_text#display(line('.'), col('.'), getcharstr(), 'aak', 'inline')<cr>
" nnoremap sn <cmd>call mi#virt_text#clear('aak')<cr>

function! s:valid_pos_arg(pos) abort
  return index(['eol', 'right_align', 'overlay', 'inline'], a:pos) >= 0
endfunction

let s:namespaces = {}
let g:default_highlight = 'IncSearch'
let s:marker_id = 0

if has('nvim')
  function! mi#virt_text#add_group(group, hl = g:default_highlight) abort
    let s:namespaces[a:group] = {
          \ 'ns_id': nvim_create_namespace(a:group),
          \ 'marker_ids': [],
          \ 'highlight': a:hl
          \ }
  endfunction

  function! mi#virt_text#clear(group) abort
    for marker_id in s:namespaces[a:group].marker_ids
      call nvim_buf_del_extmark(0, s:namespaces[a:group].ns_id, marker_id)
    endfor
  endfunction

  function! mi#virt_text#delete_group(group) abort
    call nvim_buf_clear_namespace(0, s:namespaces[a:group].ns_id, 0, -1)
    if has_key(s:namespaces, a:group)
      unlet! s:namespaces[a:group]
    endif
  endfunction

  function! mi#virt_text#display(lnum, col, text, group, pos = 'eol') abort
    if !s:valid_pos_arg(a:pos)
      throw '[mi#virt_text] Invalid position argument: ' .. a:pos
    endif

    if !has_key(s:namespaces, a:group)
      call mi#virt_text#add_group(a:group)
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
  function! mi#virt_text#add_group(group, hl = g:default_highlight) abort
    " call prop_type_add(a:group, {})
    call prop_type_add(a:group, {'highlight': a:hl})
    let s:namespaces[a:group] = {
          \ 'marker_ids': [],
          \ 'highlight': a:hl
          \ }
  endfunction

  function! mi#virt_text#clear(group) abort
    " call prop_clear(1, line('$'), {'type': a:group})
    call prop_remove({'type': a:group, 'all': v:true})
  endfunction

  function! mi#virt_text#delete_group(group) abort
    call prop_type_delete(a:group, {})
    if has_key(s:namespaces, a:group)
      unlet! s:namespaces[a:group]
    endif
  endfunction

  function! mi#virt_text#display(lnum, col, text, group, pos = 'eol') abort
    if !s:valid_pos_arg(a:pos)
      throw '[mi#virt_text] Invalid position argument: ' .. a:pos
    endif

    if !has_key(s:namespaces, a:group)
      call mi#virt_text#add_group(a:group)
    endif

    let s:marker_id += 1

    if a:pos ==# 'overlay'
      call s:add_overlay(a:lnum, a:col, a:text, a:group)
      return
    endif

    let col = a:pos ==# 'inline' ? a:col : 0
    let opts =  {
          \ 'type': a:group,
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

  function! s:add_overlay(lnum, col, text, group) abort
    call prop_add(a:lnum, a:col, {
          \ 'type': a:group,
          \ 'id': s:marker_id,
          \ })
    let p_id = popup_create(a:text, {
          \ 'line': -1,
          \ 'col': 0,
          \ 'textprop': a:group,
          \ 'textpropid': s:marker_id,
          \ 'highlight': s:namespaces[a:group].highlight
          \ })
  endfunction
endif
