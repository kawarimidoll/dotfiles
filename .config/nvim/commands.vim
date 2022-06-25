augroup commands.vim
  autocmd!
augroup END

" to use RcEdit and RcReload, define g:my_vimrc after sourcing
" source ~/dotfiles/.config/nvim/commands.vim
" let g:my_vimrc = expand('<sfile>:p')

let g:my_vimrc = $MYVIMRC

command! RcEdit execute 'edit' g:my_vimrc
command! RcReload write | execute 'source' g:my_vimrc | nohlsearch | redraw | echo g:my_vimrc . ' is reloaded.'

command! CopyFullPath     let @*=expand('%:p') | echo 'copy full path'
command! CopyDirName      let @*=expand('%:h') | echo 'copy dir name'
command! CopyFileName     let @*=expand('%:t') | echo 'copy file name'
command! CopyRelativePath let @*=expand('%:h').'/'.expand('%:t') | echo 'copy relative path'

command! VimShowHlGroup echo synID(line('.'), col('.'), 1)->synIDtrans()->synIDattr('name')

command! -nargs=* T split | wincmd j | resize 12 | terminal <args>

" {{{ Dex
function s:dex_complete(A,L,P)
  return ['--quiet', '--compat']
endfunction
command! -nargs=* -bang -complete=customlist,s:dex_complete Dex silent only! | botright 12 split |
  \ execute 'terminal' (has('nvim') ? '' : '++curwin') 'deno run --no-check --allow-all'
  \    '--unstable --watch' (<bang>0 ? '' : '--no-clear-screen') <q-args> expand('%:p') |
  \ stopinsert | execute 'normal! G' | set bufhidden=wipe |
  \ execute 'autocmd BufEnter <buffer> if winnr("$") == 1 | quit! | endif' |
  \ file Dex<bang> | wincmd k
" }}}

" {{{ Keymap
function! s:keymap(force_map, modes, ...) abort
  let arg = join(a:000, ' ')
  let cmd = (a:force_map || arg =~? '<Plug>') ? 'map' : 'noremap'
  for mode in split(a:modes, '.\zs')
    if index(split('nvsxoilct', '.\zs'), mode) < 0
      echoerr 'Invalid mode is detected: ' . mode
      continue
    endif
    execute mode .. cmd arg
  endfor
endfunction
command! -nargs=+ -bang Keymap call <SID>keymap(<bang>0, <f-args>)
" }}}

" {{{ SmartOpen
function! s:smart_open() abort
  " get query
  if mode() == 'n'
    let query = expand('<cfile>')
  else
    normal! "zy
    let query = @z->trim()->substitute('[[:space:]]\+', ' ', 'g')
  endif

  " is file path
  if filereadable(query->expand())
    if mode() == 'n'
      normal gf
    else
      execute 'edit' query
    endif
    return
  endif

  " is url
  if query =~# '^https\?://\S\+\.\S\+'
    let cmd = 'open "' .. query .. '"'
  else
    " encode query
    " https://gist.github.com/atripes/15372281209daf5678cded1d410e6c16?permalink_comment_id=3634542#gistcomment-3634542
    let safe_query = ''
    for char in query->split('.\zs')
      if char =~ '[-._~[:alnum:]]'
        let safe_query = safe_query .. char
      else
        let safe_query = safe_query .. '%' .. printf('%02x', char2nr(char))
      endif
    endfor

    " search online
    let cmd = 'open "https://google.com/search?q=' .. safe_query .. '"'
  endif

  " https://github.com/voldikss/vim-browser-search/blob/master/autoload/search.vim
  if exists('*jobstart')
    call jobstart(cmd)
  elseif exists('*job_start')
    call job_start(cmd)
  else
    call system(cmd)
  end

  echo cmd
endfunction
command! SmartOpen call <sid>smart_open()
" }}}

" {{{ EditProjectMru()
function! EditProjectMru() abort
  let cmd = 'git rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1'
  let root = system(cmd)->trim()->expand()
  if root == ''
    return
  endif
  for file in v:oldfiles
    if file =~ root && file !~ '\.git/' && filereadable(file)
      execute 'edit' file
      break
    endif
  endfor
endfunction

" remove function because it is only for `$ nvim -c 'call EditProjectMru()'`
autocmd commands.vim VimEnter * ++once delfunction! EditProjectMru
" }}}

" {{{ collect_yank_history
function! s:collect_yank_history() abort
  " regs should be start with double quote
  let regs = '"abcde'->split('\zs')
  for index in range(len(regs)-1, 1, -1)
    call setreg(regs[index], getreginfo(regs[index-1]))
  endfor
endfunction
autocmd commands.vim TextYankPost * call <SID>collect_yank_history()
" }}}

" {{{ ClearRegs
function! s:clear_regs() abort
  for r in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/'->split('\zs')
    call setreg(r, [])
  endfor
endfunction
command! ClearRegs call <SID>clear_regs()

autocmd commands.vim VimEnter * ++once ClearRegs
" }}}

" {{{ edit_with_number
" https://github.com/wsdjeg/vim-fetch/blob/master/autoload/fetch.vim
function s:edit_with_number(filename) abort
  let regex = '\m\%(:\d\+\)\{1,2}\%(:.*\)\?$'

  let pos_match = a:filename->matchstr(regex)
  if pos_match == ''
    return
  endif

  let positions = pos_match->split(':')
  let lnum = positions[0]
  let col = get(positions, 1, 0)
  let filename = a:filename->substitute(regex, '\1', '')

  echo [filename, lnum, col]
  set buftype=nowrite
  set bufhidden=wipe
  execute 'keepalt edit' fnameescape(filename)
  call setcharpos('.', [0, lnum, col, ''])
endfunction

autocmd commands.vim BufNewFile * call <sid>edit_with_number(expand('<afile>'))
" }}}
