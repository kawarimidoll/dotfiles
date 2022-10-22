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

command! DiagnosticToQf lua vim.diagnostic.setqflist()

" {{{ terminal_autoclose
function! s:terminal_autoclose(cmd) abort
  let bn = bufnr()
  let cmd = get(a:, 'cmd', '')
  if cmd == ''
    let cmd = &shell
  endif

  let opts = { 'on_exit': { -> { execute(bn .. 'bwipeout', 'silent!') } } }
  call termopen(cmd, opts)
  set nobuflisted
  normal! G
endfunction
command! -nargs=* TerminalAutoclose call s:terminal_autoclose(<q-args>)
command! -nargs=* TA call s:terminal_autoclose(<q-args>)

command! Nyancat botright split +enew
    \ | call s:terminal_autoclose('nyancat')
    \ | set bufhidden=wipe | wincmd p
command! -bang GhGraph botright 10 split +enew
    \ | execute 'terminal gh graph' (<bang>0 ? ' --scheme=random' : '')
    \ | set bufhidden=wipe | wincmd p
command! Cmatrix botright 10 split +enew
    \ | call s:terminal_autoclose('cmatrix -u 8 -s')
    \ | set bufhidden=wipe | wincmd p
" }}}

" {{{ Dex
function! s:dex_complete(A,L,P) abort
  return ['--quiet']->join("\n")
endfunction
function! s:deno_dex(no_clear, opt_args) abort
  if expand('%:t') =~ '\v^m?[jt]sx?$'
    lua vim.notify('This is not executable by deno', vim.log.levels.ERROR)
    return
  endif

  let cmd = [
    \   'deno',
    \   (expand('%:t:r') =~ '\v^(.*[._])?test$' ? 'test' : 'run'),
    \   '--no-check --allow-all --unstable --watch',
    \   (a:no_clear ? '--no-clear-screen' : ''),
    \   a:opt_args,
    \   expand('%:p')
    \ ]->join(' ')

  botright 12 split +enew
  call s:terminal_autoclose(cmd)
  set bufhidden=wipe
  stopinsert
  execute 'file Dex' .. (a:no_clear ? '!' : '')
  wincmd p
endfunction
command! -nargs=* -bang -complete=custom,s:dex_complete Dex call s:deno_dex(<bang>0, <q-args>)
" }}}

" {{{ s:term_on_floatwin
function! s:term_on_floatwin(cmd, winconf, localopts, singleton_key) abort
  if get(g:, 'term_on_floatwin_' .. a:singleton_key)
    lua vim.notify('process is running!', vim.log.levels.ERROR)
    return
  endif

  " create empty buffer
  let buf = nvim_create_buf(v:false, v:true)
  if buf < 1
    lua vim.notify('failed to create buffer', vim.log.levels.ERROR)
    return
  endif

  " create float window
  let winconf = extend({
    \   'style': 'minimal', 'relative': 'editor',
    \   'width': nvim_get_option('columns'),
    \   'height': nvim_get_option('lines'),
    \   'row': 1, 'col': 1, 'focusable': v:false
    \ }, a:winconf)
  let win = nvim_open_win(buf, v:true, winconf)
  if win < 1
    lua vim.notify('failed to create buffer', vim.log.levels.ERROR)
    return
  endif

  " set local options
  for key in keys(a:localopts)
    call nvim_set_option_value(key, a:localopts[key], { 'scope': 'local' })
  endfor

  " run command
  let on_exit_execute = buf .. 'bwipeout'
  if a:singleton_key != ''
    let on_exit_execute = on_exit_execute .. ' | unlet! g:term_on_floatwin_' .. a:singleton_key
    call nvim_set_var('term_on_floatwin_' .. a:singleton_key, buf)
  endif
  let opts = { 'on_exit': { -> { execute(on_exit_execute, 'silent!') } } }
  call termopen(a:cmd, opts)
  normal! G

  if winconf['focusable']
    " enter to the created window
    startinsert
  else
    " back to the previous window
    stopinsert
    wincmd p
  endif
endfunction
command! SL call s:term_on_floatwin('sl', {}, { 'bufhidden': 'wipe', 'winblend': 100 }, 'sl')
command! Cacafire call s:term_on_floatwin('cacafire', {}, { 'bufhidden': 'wipe', 'winblend': 100 }, 'cacafire')
command! LazyGit call s:term_on_floatwin('lazygit', { 'focusable': v:true }, { 'bufhidden': 'wipe' }, 'lazygit')

command! StartBadApple call s:term_on_floatwin(
  \ 'cd /Users/kawarimidoll/ghq/github.com/Reyansh-Khobragade/bad-apple-nodejs && yarn start',
  \ {
  \   'width': 48, 'height': 20, 'anchor': 'NE',
  \   'row': 2,
  \   'col': nvim_get_option('columns'),
  \ },
  \ { 'bufhidden': 'wipe', 'winblend': 100 },
  \ 'bad_apple')
command! StopBadApple if get(g:, 'term_on_floatwin_bad_apple')
  \ |   silent! execute g:term_on_floatwin_bad_apple .. 'bwipeout!'
  \ |   unlet! g:term_on_floatwin_bad_apple
  \ | endif
" }}}

" {{{ Sh
function! s:sh(cmd, opts) abort
  if a:cmd == ''
    return
  endif

  let cmd = get(a:opts, 'expand_each_word', v:true)
    \ ? join(map(split(a:cmd, '\s\+'), 'expand(v:val)'), ' ')
    \ : a:cmd
  let send_cmd = printf('echo ❯ %s && %s', cmd, cmd)
  let opts = {}

  execute 'botright' winheight(0)/3 'split +enew'
  setlocal nonumber norelativenumber
  let bn = bufnr()

  let sleep_sec = get(a:opts, 'auto_exit_sec', 0)
  if sleep_sec > 0
    let cnt = sleep_sec * 10
    " let sleep_cmd = printf("printf '%s\r';for i in $(seq %s);do;sleep .1;printf '#';done;", repeat('=', cnt), cnt)
    let sleep_cmd = printf("printf '%%%ss]\r[';%s", cnt+1, repeat('sleep .1;printf =;', cnt))
    let send_cmd = printf('%s && echo && %s', send_cmd, sleep_cmd)
    let opts['on_exit'] = {_->execute(bn .. 'bdelete')}
  endif
  call termopen(send_cmd, opts)

  stopinsert
  let b:term_title = bn .. ':' .. cmd
  execute 'file' b:term_title
  execute 'normal! G'
  set bufhidden=wipe
  execute 'autocmd BufEnter <buffer> if winnr("$") == 1 | quit! | endif'
  wincmd p
endfunction
command! -nargs=+ -bang -count=2 -complete=shellcmd Sh
  \ call s:sh(<q-args>, { 'expand_each_word': <bang>1, 'auto_exit_sec': <count> })
" }}}

" {{{ Keymap
" https://zenn.dev/kawarimidoll/articles/513d603681ece9
function! s:keymap(modes, ...) abort
  let arg = join(a:000, ' ')
  for mode in split(a:modes, '.\zs')
    if index(split('nvsxoilct', '.\zs'), mode) < 0
      echoerr 'Invalid mode is detected: ' . mode
      continue
    endif
    execute mode .. 'noremap' arg
  endfor
endfunction
command! -nargs=+ Keymap call s:keymap(<f-args>)
" }}}

" {{{ SmartOpen
function! s:smart_open(query) abort
  " get query
  let query = get(a:, 'query', '')
  if query == ''
    let m = mode()
    if m == 'n'
      let query = expand('<cfile>')
    elseif m ==? 'v'
      normal! "zy
      let query = @z
    else
      throw 'this mode is not supported'
    endif
  endif
  let query = query->trim()->substitute('[[:space:]]\+', ' ', 'g')

  " is file path
  let fname = expand(query)
  if filereadable(fname)
    execute 'edit' fname
    return
  endif

  if !exists('*path#normalize')
    source ~/dotfiles/.config/nvim/path.vim
  endif

  try
    let fname = path#normalize(query)

    if filereadable(fname)
      execute 'edit' fname
      return
    endif

    if path#is_node_repo()
      " resolve node path
      let node_require = path#resolve_node_require(fname)
      if node_require != ''
        execute 'edit' node_require
        return
      endif
    endif
  catch /.*/
    " nothing to do
  endtry

  if query =~# '^https\?://'
    " is url
    let cmd = 'open "' .. query .. '"'
  elseif query =~# '\v^\w([.-]?\w)*/\w([.-]?\w)*$'
    " is repo
    let cmd = 'open "https://github.com/' .. query .. '"'
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

    if confirm('Are you sure to search: ' .. safe_query, "Yes\nNo", 2) != 1
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
command! -nargs=* SmartOpen call <sid>smart_open(<q-args>)
" }}}

" {{{ BackLinks
function s:back_links() abort
  if !executable('rg')
    echoerr 'rg is required.'
    return
  endif

  let grep_list = systemlist("rg --vimgrep --hidden --trim --glob '!**/.git/*' " .. expand('%:b'))

  if !exists('*path#normalize')
    source ~/dotfiles/.config/nvim/path.vim
  endif
  let fname = expand('%:p')

  let qflist = []
  for item in grep_list
    let [f, lnum, col; m] = split(item, ':')
    let text = join(m, ':')
    let detected  = matchstr(text[:col-1], '\v\f+$') .. matchstr(text[col:], '\v^\f+')

    if fname ==# path#normalize(detected)
      call add(qflist, {'filename': f, 'lnum': lnum, 'col': col, 'text': text})
    endif
  endfor
  if empty(qflist)
    if has('nvim')
      lua vim.notify('no back_links are found.')
    else
      echo 'no back_links are found.'
    endif
    return
  endif

  call setqflist(qflist, 'r')
  cwindow
endfunction
command! BackLinks call s:back_links()
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
command! -nargs=1 HalfMove call s:half_move(<f-args>)
" }}}

" {{{ MergeHighlight
" https://zenn.dev/kawarimidoll/articles/cf6caaa7602239
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

" source ~/dotfiles/.config/nvim/termal.vim
