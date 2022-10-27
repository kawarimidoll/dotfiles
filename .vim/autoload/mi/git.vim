function! mi#git#get_root() abort
  if !exists('s:git_root')
    let cmd = 'git rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1'
    let root = system(cmd)->trim()->expand()
    call s:set_git_root(root)
  endif
  return s:git_root
endfunction

" {{{ ensure_git_root
" https://zenn.dev/kawarimidoll/articles/30693f48096eb1
function! mi#git#ensure_root() abort
  function! s:cd_to_root() abort
    let root = get(s:, 'git_root', '')
    if isdirectory(root) && root != getcwd()
      execute 'cd' root
    endif
  endfunction

  if exists('s:git_root')
    call s:cd_to_root()
    return
  endif

  function! s:on_stdout(_, msg, ...) abort
    if exists('s:git_root')
      " set once
      return
    endif

    " a:msg is list in neovim, string in vim
    let s:git_root = type(a:msg) == v:t_list ? a:msg[0] : a:msg
    call s:cd_to_root()
  endfunction

  let cmd = 'git rev-parse --show-superproject-working-tree --show-toplevel'
  if exists('*jobstart')
    " neovim-async
    call jobstart(split(cmd), { 'on_stdout': function('s:on_stdout') })
  elseif exists('*job_start')
    " vim-async
    call job_start(split(cmd), { 'out_cb': function('s:on_stdout') })
  else
    " sequential run
    let s:git_root = trim(systemlist(cmd)[0])
    call s:cd_to_root()
  endif
endfunction
" }}}

function! s:set_git_root(root) abort
  if isdirectory(a:root)
    let s:git_root = a:root .. '/'
  else
    let s:git_root = ''
  endif
endfunction
