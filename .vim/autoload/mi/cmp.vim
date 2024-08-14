" ref: sample below :h e840
function! mi#cmp#findstart(opt = {}) abort
  let line = getline('.')
  let [before_cursor, after_cursor] = mi#utils#str_divide(line, col('.')-1)

  if get(a:opt, 'multibyte', v:false)
    let start = matchend(before_cursor, '.*[^[:keyword:]]')
    if start < 0
      let start = 0
    endif
  else
    let start = strlen(before_cursor)
    while start > 0 && before_cursor[start - 1] =~ '\k'
      let start -= 1
    endwhile
  endif

  let [before_word, lastword] = mi#utils#str_divide(before_cursor, start)
  let s:cmp_info = l:
  return start
endfunction

function! mi#cmp#get_info() abort
  return s:cmp_info
endfunction

function! s:escaped_filetype() abort
  return substitute(&filetype, '\W', '_', 'g')
endfunction

function! mi#cmp#syn_omnifunc(findstart, base) abort
  if a:findstart
    return mi#cmp#findstart()
  endif

  let filetype = s:escaped_filetype()
  if !has_key(s:syn_cmp_cache, filetype)
    let s:syn_cmp_cache[filetype] = mi#cmp#syn_keywords()
          " \ ->map(keywords, $"\{'word':v:val, 'menu':'syn-{filetype}'\}")
  endif
  let compl_list = s:syn_cmp_cache[filetype]

  " let base = s:prepended . a:base
  let base = substitute(s:cmp_info.lastword, "'", "''", 'g')
        \ ->escape('\\/.*$^~[]')

  if empty(base)
    return compl_list
  endif

  " Filter the list based on the first few characters the user entered
  return filter(deepcopy(compl_list), $"v:val =~# '^{base}.*'")
endfunction

function! s:syn_keywords_file_name() abort
  return expand($'~/.cache/vim/syn-keywords-{s:escaped_filetype()}')
endfunction

function! mi#cmp#gen_syn_keywords_file(syn_prefix_list = []) abort
  let compl_list = mi#cmp#syn_keywords()
  let filename = s:syn_keywords_file_name(a:syn_prefix_list)
  call writefile(compl_list, filename)
  echo $'[mi#cmp#gen_syn_keywords_file] successfully write keywords to {filename}'
endfunction

function! mi#cmp#apply_syn_keywords_dict() abort
  setlocal dictionary<
  let &l:dictionary .= ',' .. s:syn_keywords_file_name()
endfunction

" ref: syntaxcomplete#OmniSyntaxList()
function! mi#cmp#syn_keywords(syn_prefix_list = []) abort
  redir => syntax_output
  silent! execute 'syntax list'
  redir END

  if syntax_output =~ 'E28\|E411\|E415\|No Syntax items'
    return []
  endif

  let keywords = []

  let filetype = s:escaped_filetype()
  " As default, this uses current filetype as a prefix.
  " e.g. vim syntax has keywords for vim (e.g. vimOption) and for lua (e.g. luaStatement)
  " then, this plugin filters keywords only starts with 'vim'.
  " to use lua syntax, add prefixes to argument
  " call mi#cmp#syn_keywords(['lua'])
  let syn_prefix_list = a:syn_prefix_list
  if index(syn_prefix_list, filetype)
    call add(syn_prefix_list, filetype)
  endif
  if exists('b:current_syntax') && index(syn_prefix_list, b:current_syntax)
    call add(syn_prefix_list, b:current_syntax)
  endif

  let has_correct_syn_prefix = v:false
  for line in split(syntax_output, "\n")
    if line =~ '^\S'
      let has_correct_syn_prefix = v:false
      for syn_prefix in syn_prefix_list
        let syn_regex = '^' .. syn_prefix .. '\w\+\s\+xxx\s\+'
        if line =~ syn_regex
          let has_correct_syn_prefix = v:true
          break
        endif
      endfor
    endif
    if !has_correct_syn_prefix
      continue
    endif

    if line =~ 'match\s\+\H\|links\s\+to' || line =~ '\zs\%(start\|end\|skip\|cluster\|in\)\ze='
      continue
    endif

    " format sample:
    " SyntaxName xxx keyword1 keyword2  keyword3
    "                keyword4 contained nextgroup=Group1
    " parse sample:
    " keyword1 keyword2 keyword3 keyword4
    "
    " strategy:
    " 1. remove syntax name and 'xxx'
    " 2. remove reserved words like nextgroup
    " 3. remove one-character keywords (they're useless for completion)
    " 4. remove unnecessary white spaces
    let syn_keywords = line->substitute('^\%(\w\+\s\+xxx\)\?\s\+', '', '')
          \ ->substitute('nextgroup=\S\+\|contained\|skipwhite', '', 'g')
          \ ->substitute('^.\s\|\s.\s\|\s.$', ' ', 'g')
          \ ->substitute('\s\+', ' ', 'g')

    call extend(keywords, split(syn_keywords, ' '))
  endfor

  call uniq(sort(keywords))

  " in filetype vim, remove abbreviated commands
  "   e.g. 'edi' is abbreviated form of 'edit'
  if &filetype == 'vim'
    let short_keywords = []
    for i in range(len(keywords) - 1)
      if keywords[i + 1] !~ $'^{keywords[i]}.$'
        call add(short_keywords, keywords[i])
      endif
    endfor
    let keywords = short_keywords
  endif

  return keywords
endfunction
