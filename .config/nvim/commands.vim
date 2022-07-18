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

command! DiagnosticToQf <cmd>lua vim.diagnostic.setqflist()<CR>

" {{{ Dex
function s:dex_complete(A,L,P)
  return ['--quiet', '--compat']->join("\n")
endfunction
command! -nargs=* -bang -complete=custom,s:dex_complete Dex silent only! | botright 12 split |
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
      normal! gFzz
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
    for i in query->len()->range()
      if query[i] =~ '[-._~[:alnum:]]'
        let safe_query ..= query[i]
      else
        let safe_query ..= printf('%%%02x', char2nr(query[i]))
      endif
    endfor

    if confirm('Are you sure to search: ' .. safe_query, "Yes\nNo", 2) == 2
      return
    endif

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
    edit #<1
    return
  endif
  for file in v:oldfiles
    if file =~ root .. '/' && file !~ '\.git/' && filereadable(file)
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
  let regs = '"abcdefghijk'->split('\zs')
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
function! s:edit_with_number(filename) abort
  let regex = '\m\%(:\d\+\)\{1,2}\%(:.*\)\?$'

  let pos_match = a:filename->matchstr(regex)
  if pos_match == ''
    return
  endif

  let positions = pos_match->split(':')
  let lnum = positions[0]
  let col = get(positions, 1, 0)
  let filename = a:filename->substitute(regex, '\1', '')

  set buftype=nowrite
  set bufhidden=delete
  execute 'keepalt edit' fnameescape(filename)
  call setcharpos('.', [0, lnum, col, ''])
  autocmd BufReadPost * ++once edit
  " NOTE: currently re-opening the file is need to set file type
endfunction

autocmd commands.vim BufNewFile * call <sid>edit_with_number(expand('<afile>'))
" }}}

" {{{ HalfMove
function! s:half_move(direction) abort
  let [bufnum, lnum, col, off] = getpos('.')
  if a:direction == 'left'
    let col = col / 2
  elseif a:direction == 'right'
    let col = (len(getline('.')) + col) / 2
  elseif a:direction == 'center'
    let col = len(getline('.')) / 2
  elseif a:direction == 'up'
    let lnum = (line('w0') + lnum) / 2
  elseif a:direction == 'down'
    let lnum = (line('w$') + lnum) / 2
  else
    echoerr "HalfMove direction must be one of ['left', 'right', 'center', 'up', 'down']"
  endif
  call setpos('.', [bufnum, lnum, col, off])
endfunction
command! -nargs=1 HalfMove call <SID>half_move(<f-args>)
" }}}

" {{{ MergeHighlight
function! s:merge_highlight(args) abort
  let l:args = split(a:args)
  if len(l:args) < 2
    echoerr '[MergeHighlight] At least 2 arguments are required.'
    echoerr 'New highlight name and source highlight names.'
    return
  endif

  " skip 'links' and 'cleared'
  execute 'highlight' l:args[0] l:args[1:]
      \ ->map({_, val -> execute('highlight ' . val)->substitute('^\S\+\s\+xxx\s', '', '')})
      \ ->filter({_, val -> val !~? '^links to' && val !=? 'cleared'})
      \ ->join()
endfunction
command! -nargs=+ -complete=highlight MergeHighlight call s:merge_highlight(<q-args>)
" Use like this:
"  MergeHighlight markdownH1 Red Bold
" }}}

" {{{ restore-cursor
autocmd commands.vim BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   execute 'normal! g`"'
  \ |   execute 'normal! zz'
  \ | endif
" }}}

" {{{ ensure_dir
" [vim-jp » Hack #202: 自動的にディレクトリを作成する](https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html)
function! s:ensure_dir(dir, force)
  if !isdirectory(a:dir) && (a:force || confirm('"' . a:dir . '" does not exist. Create?', "y\nN"))
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd commands.vim BufWritePre * call s:ensure_dir(expand('<afile>:p:h'), v:cmdbang)
" }}}
