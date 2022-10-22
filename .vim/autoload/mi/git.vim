function! mi#git#get_root() abort
  if !exists('s:git_root')
    let cmd = 'git rev-parse --show-superproject-working-tree --show-toplevel 2>/dev/null | head -1'
    let root = system(cmd)->trim()->expand()
    if isdirectory(root)
      let s:git_root = root .. '/'
    else
      let s:git_root = ''
    endif
  endif
  return s:git_root
endfunction

" {{{ ensure_git_root
" https://zenn.dev/kawarimidoll/articles/30693f48096eb1
function! mi#git#ensure_root() abort
  let root = mi#git#get_root()
  if isdirectory(root) && root != getcwd()
    execute 'cd' root
  endif
endfunction
" }}}
