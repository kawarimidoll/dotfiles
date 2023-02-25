" http://saihoooooooo.hatenablog.com/entry/2013/04/30/001908
function! mi#mark#auto_set() abort
  if !exists('b:last_mark')
    let b:last_mark = -1
  endif
  let b:last_mark = (b:last_mark + 1) % len(g:mi#const#alpha_lower)
  execute 'mark' g:mi#const#alpha_lower[b:last_mark]
endfunction

function! mi#mark#jump_to_last() abort
  if !exists('b:last_mark')
    return
  endif
  execute 'normal! g`' .. g:mi#const#alpha_lower[b:last_mark]
endfunction

" https://github.com/hrsh7th/vim-searchx/blob/eeaa168368/autoload/searchx/highlight.vim#L28-L87
let s:marker_ns = 'mi#mark#overlay_ns'
let s:marker_id = 1
if has('nvim')
  function! mi#mark#add_overlay(opts = {}) abort
    let opts = s:default_overlay_opts(a:opts)
    call nvim_buf_set_extmark(0, opts.ns, opts.lnum - 1, max([0, opts.col - 1]), {
          \   'id': opts.id,
          \   'virt_text': [[opts.char]],
          \   'virt_text_pos': 'overlay',
          \   'hl_group': opts.highlight,
          \   'priority': 1000,
          \ })
  endfunction

  function! mi#mark#clear_overlay(ns = '') abort
    let ns = nvim_create_namespace(a:ns ==# '' ? s:marker_ns : a:ns)
    call nvim_buf_clear_namespace(0, ns, 0, -1)
  endfunction
else
  function! mi#mark#add_overlay(opts = {}) abort
    let opts = s:default_overlay_opts(a:opts)
    silent! call prop_type_add(opts.ns, {})
    call prop_add(opts.lnum, opts.col + 1, {
          \   'type': opts.ns,
          \   'id': opts.id,
          \ })
    call popup_create(opts.char, {
          \   'line': -1,
          \   'col': -1,
          \   'textprop': opts.ns,
          \   'textpropid': opts.id,
          \   'width': 1,
          \   'height': 1,
          \   'highlight': opts.highlight
          \ })
  endfunction

  function! mi#mark#clear_overlay(ns = '') abort
    let ns = a:ns ==# '' ? s:marker_ns : a:ns
    call prop_remove({'type': ns, 'all': v:true})
    call prop_type_delete(ns)
  endfunction
endif

function! s:default_overlay_opts(opts = {}) abort
  let opts = { 'id': s:marker_id }
  let s:marker_id += 1
  " should be single letter
  let opts.char = get(a:opts, 'char', '.')
  let opts.lnum = get(a:opts, 'lnum', line('.'))
  let opts.col = get(a:opts, 'col', col('.'))
  let opts.highlight = get(a:opts, 'highlight', 'Text')
  let opts.ns = get(a:opts, 'ns', s:marker_ns)
  if has('nvim')
    let opts.ns = nvim_create_namespace(opts.ns)
  endif
  return opts
endfunction
