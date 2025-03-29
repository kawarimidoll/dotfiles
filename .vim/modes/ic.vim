" opts
set complete=.,w,k,b,u
set completeopt=menuone,noselect,fuzzy
set infercase
set ignorecase
set smartcase
set wildmode=longest,full

if has('nvim')
  set inccommand=split
else
  set backspace=indent,eol,start
  set completeopt+=popuphidden
  set hlsearch
  set incsearch
  set ttimeout
  set ttimeoutlen=50
  set wildmenu
  set wildoptions=pum,tagfile
  inoremap <C-u> <C-g>u<C-u>
  inoremap <C-w> <C-g>u<C-w>
endif

" perl -e 'print sort { length($a) <=> length($b) } <>' /usr/share/dict/words > ~/.cache/vim/sorted_words
set dictionary+=~/.cache/vim/sorted_words

let s:eng_10k_dict_path = expand('~/.cache/vim/google-10000-english-no-swears.txt')
let s:eng_10k_dict_url = 'https://raw.githubusercontent.com/first20hours/'
      \ .. 'google-10000-english/master/google-10000-english-no-swears.txt'
execute 'set dictionary+=' .. s:eng_10k_dict_path
command! -bang DownloadDictFile call mi#utils#download(s:eng_10k_dict_url, s:eng_10k_dict_path, <bang>0)

let s:dotfiles_dict_path = expand('~/dotfiles/.config/cspell/dotfiles.txt')
execute 'set dictionary+=' .. s:dotfiles_dict_path

command! -nargs=+ -bang -complete=expression NotifyShow call mi#notify#show([<args>], <bang>0 ? 3 : 2)
command! -bang NotifyHistory call mi#notify#history(<bang>0)
command! NotifyForget call mi#notify#forget()

command! SudoWrite write !sudo tee > /dev/null %

" command
function! s:cmd_slash() abort
  let cmdtype = getcmdtype()
  if cmdtype == '/'
    return '\/'
  endif
  if cmdtype == ':'
    let compltype = getcmdcompltype()
    let cmdline = getcmdline()
    let cmdpos = getcmdpos()
    if wildmenumode()
          \ && compltype =~ '\v^(file|dir)(_in_path)?$'
          \ && !empty(cmdline)
          \ && cmdpos > 3
          \ && cmdline[cmdpos - 2] == '/'
      return "\<right>"
    endif
  endif
  " fallback
  return '/'
endfunction
" cnoremap <expr> s getcmdtype() == ':' && getcmdline() == 's' ? '<BS>%s/' : 's'
cnoremap <expr> % getcmdtype() == ':' && getcmdpos() > 2 && getcmdline()[getcmdpos()-2] == '%' ?
      \ '<BS>' .. expand('%:h') .. '/' : '%'
cnoremap <expr> / <sid>cmd_slash()
cnoremap <expr> <C-n> wildmenumode() ? '<C-n>' : '<Down>'
cnoremap <expr> <C-p> wildmenumode() ? '<C-p>' : '<Up>'
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
cmap <c-h> <bs>
" cnoremap <C-r><C-r> <cmd>call <sid>sync_unnamed()<cr><C-r><C-r>"
cnoremap <nowait> <C-r><C-r> <C-r><C-r>"

" cnoremap <c-c> <home>Capture <cr>
cnoremap <expr> <C-k> repeat('<Del>', strchars(getcmdline()[getcmdpos() - 1:]))
cnoremap <s-cr> <cmd>call mi#cmdline#set_by_spec(extend(mi#cmdline#get_spec(), {'bang': v:true}))<cr><cr>
cnoremap <cr> <cmd>call mi#cmdline#proxy_convert()<cr><cr>
cnoremap <expr> <C-x> mi#magic#expr()

" {{{ AbbrevCmd
" expand abbreviations immediately in command-line
let s:abbrev_cmds = {}
function! s:abbrev_cmd(raw_rhs, cmd_lhs, ...) abort
  " backspace cmd_lhs
  let bs = repeat('<bs>', strchars(a:cmd_lhs) - 1)
  const rhs = a:raw_rhs ? string(bs) .. ".." .. join(a:000, ' ') :
        \ string(bs .. join(a:000, ' '))
  const [lhs_except_last, lhs_last] = matchlist(a:cmd_lhs, '^\(.*\)\(.\)$')[1:2]
  if !has_key(s:abbrev_cmds, lhs_last)
    let s:abbrev_cmds[lhs_last] = {}
  endif
  let s:abbrev_cmds[lhs_last][lhs_except_last] = rhs
  " can't use string() not to quote values
  const rhs_list = map(items(s:abbrev_cmds[lhs_last]), {_,val -> $"':{val[0]}':{val[1]}"})
  " range is not supported apart from visual selection
  const fmt = "cnoremap <expr> %s get({%s},getcmdtype()..getcmdline()->substitute(\"^'<,'>\",'',''),'%s')"
  execute printf(fmt, lhs_last, join(rhs_list, ','), lhs_last)
endfunction
command! -nargs=+ -bang AbbrevCmd call s:abbrev_cmd(<bang>0, <f-args>)
" }}}

AbbrevCmd cfi Cfilter
AbbrevCmd cap Capture
AbbrevCmd coc CopyLastCmd
AbbrevCmd cod CopyDirName
AbbrevCmd cof CopyFileName
AbbrevCmd coa CopyFullPath
AbbrevCmd cor CopyRelativePath
AbbrevCmd yep echo 'yep'
AbbrevCmd mes messages
AbbrevCmd mec messages clear
AbbrevCmd ec echo
AbbrevCmd ed edit
AbbrevCmd en enew
AbbrevCmd plgs PlugSync
AbbrevCmd plugs PlugSync
AbbrevCmd! sv 'saveas ' .. @% .. repeat('<left>', {v -> v>0 ? v+1 : 0}(expand('%:e')->strlen()))
AbbrevCmd! rn 'Rename ' .. @% .. repeat('<left>', {v -> v>0 ? v+1 : 0}(expand('%:e')->strlen()))
AbbrevCmd! ss '%s/' .. @/ .. '//g<Left><Left>'
" AbbrevCmd! ss '%s/' .. @/ .. "//g\<Left>\<Left>" olso ok
AbbrevCmd! gld 'global //d_<left><left><left>'

" cnoremap <expr> v getcmdtype() == ':' && getcmdline() == 's' ? '<c-u>saveas ' .. @% : 'v'
" cnoremap <expr> n getcmdtype() == ':' && getcmdline() == 'r' ? '<c-u>Rename ' .. @% : 'n'
" cnoremap <expr> s getcmdtype() == ':' && getcmdline() =~ '^plu\?g$' ? '<c-u>PlugSync' : 's'
cnoremap <expr> . getcmdtype() == '/' && getcmdpos() > 2 && getcmdline()[getcmdpos()-2] == ',' ?
      \ '<c-u>\<' .. substitute(getcmdline()[:-2], '\\v', '', 'gi') .. '\>' : '.'

" https://zenn.dev/monaqa/articles/2020-12-22-vim-abbrev
cnoreabbrev <expr> w getcmdtype() .. getcmdline() ==# ":'<,'>w" ? "\<C-u>w" : 'w'

" https://zenn.dev/vim_jp/articles/2023-06-30-vim-substitute-tips
" cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s/" .. escape(@/, '/') .. "//g<Left><Left>" : 's'

" " insert
" function s:next_or_cmp()
"   if pumvisible()
"     return feedkeys("\<c-n>", 'ni')
"   endif
"   call s:my_cmp()
" endfunction
" function s:my_cmp(phase = 0)
"   if pumvisible()
"     return
"   endif
"   let cmp_keys = ["\<c-f>", "\<c-v>", "\<c-n>", "\<c-k>"]
"   if &filetype != 'vim' && &filetype != 'help'
"     call remove(cmp_keys, 1)
"   endif
"   let col = col('.') - 2
"   let prev_char = col < 0 ? '' getline('.')[col]
"   if empty(prev_char) || prev_char =~ '\s'
"     call remove(cmp_keys, 0)
"   endif
"   let next_cmp = get(cmp_keys, a:phase, '')
"   if empty(next_cmp)
"     return feedkeys("\<c-n>", 'ni')
"   endif
"   let recall = $"\<cmd>call {expand('<SID>')}my_cmp({a:phase + 1})\<cr>"
"   call feedkeys($"\<c-x>{next_cmp}{recall}", 'ni')
" endfunction
" inoremap <tab> <cmd>call <sid>next_or_cmp()<cr>
" inoremap <c-x><c-y> <cmd>call <sid>my_cmp()<cr>

imap <c-h> <bs>
" inoremap <silent> <C-r><C-r> <cmd>call <sid>sync_unnamed()<cr><C-r><C-r>"
inoremap <nowait> <C-r><C-r> <C-r><C-r>"
inoremap <C-k> <C-o>D
inoremap <expr> <Tab>   pumvisible() ? '<C-n>' : '<C-t>'
inoremap <expr> <S-Tab> pumvisible() ? '<C-p>' : '<C-d>'
inoremap <C-g><C-u> <esc>gUiwgi
inoremap <C-g><C-l> <esc>guiwgi
inoremap <C-g><C-k> <esc>bgUlgi
inoremap <right> <c-g>U<right>
inoremap <left> <c-g>U<left>
inoremap <home> <c-g>U<home>
inoremap <end> <c-g>U<end>
imap <c-f> <right>
imap <c-b> <left>
imap <c-a> <home>
imap <c-e> <end>
inoremap <c-x><c-v> <c-x><c-v><c-n>

" https://zenn.dev/kawarimidoll/articles/262785e8ca05b0
inoremap <expr> <c-g><c-f> &completeopt =~ 'fuzzy'
      \    ? '<cmd>set completeopt-=fuzzy<cr>a<bs>'
      \    : '<cmd>set completeopt+=fuzzy<cr>a<bs>'

" https://zenn.dev/kawarimidoll/articles/54e38aa7f55aff
inoremap <expr> /
      \ complete_info(['mode']).mode == 'files' && complete_info(['selected']).selected >= 0
      \   ? '<c-x><c-f>'
      \   : '/'
inoremap <expr> .
      \ complete_info(['mode']).mode == 'files' && complete_info(['selected']).selected >= 0
      \   ? '.<c-x><c-f>'
      \   : '.'

function s:insert_jump() abort
  if getline('.')->len() != col('.')
    call search('\k\+\|[({\[\]})=]', 'cWe')
  endif
  call feedkeys("\<right>", 'ni')
endfunction
inoremap <s-cr> <cmd>call <sid>insert_jump()<cr>

" sticky-shift
" https://vim-jp.org/vim-users-jp/2009/08/09/Hack-54.html
function s:sticky_shift() abort
  let char = getcharstr()
  return char ==# ' ' ?
        \   ';'
        \ : char ==# "\<cr>" ?
        \   ";\<cr>"
        \ : char =~# '^\p$' ?
        \   mi#utils#upper_key(char)
        \ : ''
endfunction
noremap! <expr> ; <sid>sticky_shift()

function s:caps() abort
  if has('nvim')
    lua vim.notify("caps mode doesn't work on neovim")
    return
  endif
  if exists('#capslock#KeyInputPre')
    autocmd! capslock
    return
  endif
  augroup capslock
    autocmd!
    autocmd KeyInputPre * if v:char =~# '^\l'
          \ |   let v:char = mi#utils#upper_key(v:char)
          \ | endif
    autocmd CmdlineLeave,InsertLeave * autocmd! capslock
  augroup END
endfunction
noremap! C <Cmd>call <SID>caps()<CR>

" https://zenn.dev/vim_jp/articles/b4294351def1ba
function! s:symbol_cmp() abort
  let triggers = 'hjklnmfdsavcuiorew'->split('\zs')
  let comp_list = b:symbol_list->copy()
        \ ->map({i, v -> {'word': v, 'menu': get(triggers, i, '')}})
  call complete(col('.')-1, comp_list)
  augroup symbolselect
    autocmd!
    autocmd KeyInputPre * call s:symbol_select()
    autocmd ModeChanged * autocmd! symbolselect
  augroup END
endfunction

function! s:symbol_select() abort
  let items = complete_info(['items']).items
  let idx = indexof(items, {_,v -> get(v, 'menu', '') ==# v:char})
  if idx >= 0
    let v:char = "\<bs>"
    call feedkeys(items[idx].word, 'ni')
  endif
endfunction

inoremap <expr> , exists('b:symbol_list')
      \ ? ',<cmd>call <sid>symbol_cmp()<cr>'
      \ : ','

" function! s:imap_up() abort
"   if line('.') == 1
"     call feedkeys("\<c-g>U\<home>", 't')
"     return
"   endif
"   if exists('g:mi#dot_repeating')
"     call feedkeys("\<up>", 't')
"     return
"   endif
"   call appendbufline(0, line('.'), getline('.'))
"   call setbufline(0, line('.'), getline(line('.')-1))
"   call deletebufline(0, line('.')-1)
" endfunction
" function! s:imap_down() abort
"   if line('.') == line('$')
"     call feedkeys("\<c-g>U\<end>", 't')
"     return
"   endif
"   if exists('g:mi#dot_repeating')
"     call feedkeys("\<down>", 't')
"     return
"   endif
"   call appendbufline(0, line('.')-1, getline('.'))
"   call setbufline(0, line('.'), getline(line('.')+1))
"   call deletebufline(0, line('.')+1)
" endfunction
" if !has('nvim')
"   inoremap <c-l> <c-@>
"   inoremap <up> <cmd>call <sid>imap_up()<cr>
"   inoremap <down> <cmd>call <sid>imap_down()<cr>
" endif

let s:ft_expand_targets = {
      \ 'javascript': {
      \ ';p': "console.log()\<left>",
      \ ';if': "if() {}\<left>\<cr>\<c-o>\<up>\<home>\<c-o>f)",
      \ },
      \ 'vim': {
      \ ';p': 'echomsg ',
      \ ';if': "if\<cr>endif\<c-o>\<up>\<end> ",
      \ ';fun': "function!  abort\nendfunction\<up>\<c-o>E\<right>",
      \ },
      \ }
let s:expand_targets = {
      \ '%': { ->@% },
      \ ';p': "print()\<left>",
      \ }
let s:ft_aliases = {
      \ 'typescript': 'javascript',
      \ 'javascriptreact': 'javascript',
      \ 'typescriptreact': 'javascript',
      \ }
function! s:expand_snippet(fallback) abort
  const prev_idx = getcharpos('.')[2] - 2
  if prev_idx < 0
    return a:fallback
  endif
  const line = getline('.')
  const prev_cursor = line[:prev_idx]
  const prev_len = strlen(prev_cursor)
  const filetype = get(s:ft_aliases, &filetype, &filetype)
  const targets_current_ft = get(s:ft_expand_targets, filetype, {})
  const targets = extend(copy(s:expand_targets), targets_current_ft)
  for target_key in keys(targets)
    let match_idx = strridx(prev_cursor, target_key)
    if match_idx >= 0 && match_idx + strlen(target_key) == prev_len
      const replacement = type(targets[target_key]) == v:t_func ? targets[target_key]()
            \ : type(targets[target_key]) == v:t_list ? join(targets[target_key], "\<cr>")
            \ : targets[target_key]
      return repeat("\<bs>", strcharlen(target_key)) .. replacement
    endif
  endfor
  return a:fallback
endfunction
inoremap <expr> <c-x> <sid>expand_snippet("\<c-x>")

command! -nargs=+ -bang Grep  call mi#qf#async_grep(<q-args>, {'add': <bang>0})
command! -nargs=+ -bang GrepF call mi#qf#async_grep(<q-args>, {'add': <bang>0, 'fixed': 1})
command! -nargs=+ -bang LGrep  call mi#qf#async_grep(<q-args>, {'add': <bang>0, 'loc': 1})
command! -nargs=+ -bang LGrepF call mi#qf#async_grep(<q-args>, {'add': <bang>0, 'loc': 1, 'fixed': 1})

command! -nargs=1 -complete=file VDiff vertical diffsplit <args>
command! VDiffAlt vertical diffsplit #
