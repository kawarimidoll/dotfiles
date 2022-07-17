augroup qfutils.vim
  autocmd!
augroup END

" {{{ BCycle
" BPrevious/BNext SkipQF
function! s:b_cycle(count) abort
  let index = 0
  if a:count > 0
    let cmd = 'bnext'
    let count = a:count
  else
    let cmd = 'bprevious'
    let count = -a:count
  endif
  while index < count
    execute cmd
    if &filetype == 'qf'
      execute cmd
    endif
    let index = index + 1
  endwhile
endfunction
command! -nargs=1 BCycle call s:b_cycle(<q-args>)
" }}}

" {{{ CCycle
function! s:c_cycle(count) abort
  echo a:count
  let qf_info = getqflist({ 'idx': 0, 'size': 0 })
  let size = qf_info->get('size')
  if size == 0
    return
  endif

  let idx = qf_info->get('idx')

  let num = (idx + size + a:count) % size

  if num == 0
    let num = size
  endif

  execute num .. 'cc'
endfunction
command! -nargs=1 CCycle call s:c_cycle(<q-args>)
" }}}

" {{{ CClear
command! CClear call setqflist([], 'r') | cclose
autocmd FileType qf nnoremap <buffer> X <cmd>CClear<CR>
" }}}

" {{{ CToggle
" https://github.com/drmingdrmer/vim-toggle-quickfix/blob/master/autoload/togglequickfix.vim
function! s:c_toggle() abort
  let qf_info = getqflist({ 'winid': 0, 'size': 0 })
  let winid = qf_info->get('winid')
  let size = qf_info->get('size')

  if winid == 0 && size != 0
    copen
  else
    cclose
  endif
endfunction
command! CToggle call s:c_toggle()
" }}}

" {{{ CAdd
function! s:c_add() abort
  caddexpr [expand('%'), line('.'), col('.'), getline('.')->trim()]->join(':')
endfunction
command! CAdd call s:c_add()
" }}}

" {{{ CRemove
" ref: https://stackoverflow.com/a/48817071
function! s:c_remove() abort
  let size = getqflist({ 'size': 0 })->get('size')
  if size < 2
    CClear
    return
  endif

  if &filetype == 'qf'
    let idx = line('.') - 1
  else
    let idx = getqflist({ 'idx': 0 })->get('idx') - 1
  endif

  let qfall = getqflist()
  call remove(qfall, idx)
  call setqflist(qfall, 'r')
  copen

  if &filetype == 'qf'
    execute 'normal! ' .. (idx + 1) .. 'G'
  endif
endfunction
command! CRemove call s:c_remove()
" Use map <buffer> to only map in the quickfix window like this:
" autocmd FileType qf nnoremap <buffer> dd <cmd>CRemove<cr>
autocmd FileType qf nnoremap <buffer> x <cmd>CRemove<CR>
autocmd qfutils.vim FileType qf set number
" }}}

" {{{ Qfutils
function! s:qfutils_comp(ArgLead, CmdLine, CursorPos) abort
  let qfu_cmds = ['BCycle', 'CCycle', 'CClose', 'CClear', 'CToggle', 'CAdd', 'CRemove']
  let cmd = a:CmdLine->split('\s')->get(1, '')
  if qfu_cmds->index(cmd) > -1
    return ''
  endif
  return qfu_cmds->join("\n")
endfunction
function! s:qfutils(args) abort
  let args = a:args->split('\s')
  let cmd = get(args, 0, '')
  let arg = get(args, 1, '')

  execute cmd arg
endfunction
command! -nargs=+ -complete=custom,s:qfutils_comp Qfutils call s:qfutils(<q-args>)
" }}}
