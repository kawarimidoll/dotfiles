if exists('g:mi#ready')
  finish
endif
const g:mi#ready = 1

luafile ~/dotfiles/.vim/utils.lua

call mi#git#ensure_root()
call mi#register#clear()

autocmd TextYankPost * call mi#register#collect_yank_history(10)
autocmd BufEnter,BufReadPost * call mi#mru#save()
" autocmd FileType qf ++once packadd cfilter

" nnoremap <right> <cmd>let @* = @"<cr>
" nnoremap <left> <cmd>let @" = @*<cr>
" copy quotestar only focus changed
set clipboard&
let @" = @*
nnoremap gy <cmd>let @* = @"<cr>
" autocmd VimLeave,FocusLost * let @* = @"
autocmd FocusGained * let @" = @*

autocmd BufReadPost quickfix call mi#qed#start()

call mi#cmdline#proxy_let('trim', 'Trim')
call mi#cmdline#proxy_let('cfilter', 'Cfilter')
" call mi#cmdline#proxy_let('s[ubstitute]', 'Substitute')
source ~/dotfiles/.vim/autoload/mi/subs.vim
" source ~/dotfiles/.vim/autoload/mi/neighbor.vim

command! GitStatus 10new
      \ | setlocal buftype=nofile bufhidden=delete noswapfile
      \ | execute 'read !git status -suall'
      \ | execute 'normal! gg"_dd'
      \ | setlocal readonly nobuflsted
      \ | call mi#window#fit()

command! GitDiff new
      \ | setlocal buftype=nofile bufhidden=delete noswapfile
      \ | setfiletype gitcommit
      \ | execute 'read !git diff #'
      \ | setlocal readonly nobuflsted
      \ | normal! gg
      \ | call mi#window#fit()

if has('nvim')
  call mi#cmdline#proxy_let('L[spInfo]', 'LspInfo')
  call mi#cmdline#proxy_let('P[lugSync]', 'PlugSync')
  call mi#cmdline#proxy_let('p[lugsync]', 'PlugSync')

  " https://zenn.dev/vim_jp/articles/7cc48a1df6aba5
  " in nvim, remove cwindow since fzf-lua is used instead
  command! -bang SearchToQf execute (<bang>0 ? 'vimgrepadd' : 'vimgrep') '//gj %'
else
  command! -nargs=* -range=% -complete=custom,mi#common#__compl_trim Trim <line1>,<line2>call mi#common#trim([<f-args>])
  command! -range=% DeleteBlankLines <line1>,<line2>call mi#common#delete_blank_lines()

  command! -bang SearchToQf execute (<bang>0 ? 'vimgrepadd' : 'vimgrep') '//gj %' | cwindow

  " https://www.statox.fr/posts/2020/07/vim_flash_yanked_text/
  autocmd CursorMoved * call mi#highlight#cursorword('Underlined')
  autocmd CursorMoved,CursorMovedI * call mi#highlight#match_paren('Underlined')
  autocmd TextYankPost * silent! call mi#highlight#on_yank({'timeout': 500})
  autocmd WinEnter * call mi#qf#quit_if_last_buf()
  autocmd FileType qf call mi#qf#fit_window({'min': 3, 'max': 10})

  source ~/dotfiles/.vim/autoload/mi/searchprop.vim
  source ~/dotfiles/.vim/autoload/mi/substitutor.vim

  call mi#pair#keymap_set(['{}', '[]', '()', "''", '""', '``'])

  " highlight! link StatusLine GamingBg
  " highlight! link StatusLineNC GamingFg
  " " HACK: highlight-links are sometimes disabled when buffers are changed
  " autocmd BufEnter,ColorScheme * highlight! link StatusLine GamingBg | highlight! link StatusLineNC GamingFg
  " autocmd ModeChanged *:t highlight! link StatusLine NONE | highlight! link StatusLineNC NONE
  " call mi#gaming#start()
  set runtimepath+=~/ghq/github.com/kawarimidoll/kawarimiline.vim
  let kawarimiline_width = 30
  if exists('*kawarimiline#start')
    call kawarimiline#start({
          \ 'size': 22,
          \ 'lnum': 1,
          \ 'left_margin': &columns-kawarimiline_width,
          \ 'right_margin': 0,
          \ 'enable': {-> len(gettabinfo()) == 1},
          \ 'wave': v:true,
          \ })
  endif
  " let s:info_popup_id = popup_create('', {
  "       \ 'line': 1,
  "       \ 'col': &columns,
  "       \ 'pos': 'topright',
  "       \ 'maxheight': 2,
  "       \ 'minheight': 2,
  "       \ 'maxwidth': kawarimiline_width+1,
  "       \ 'minwidth': kawarimiline_width+1,
  "       \ 'zindex': 300,
  "       \ 'posinvert': v:false,
  "       \ })
  call mi#notify#setwidth(kawarimiline_width+1)

  " autocmd WinEnter,BufEnter,CursorHold,CursorHoldI,ModeChanged * call s:update_info()
  function s:update_info() abort
    let curpos = getcurpos()[1:2]
    let pos_info = join(curpos, ',')
    " let another_col = getcursorcharpos()[2]
    let another_col = screencol()
    if another_col != curpos[1]
      let pos_info ..= '-' .. string(another_col)
    endif
    let win_info = get(getwininfo(win_getid()), 0, {})
    let buf_info = win_info.loclist ? 'L' : toupper(slice(&buftype,0,1))

    let info_list = [
          \ mi#statusline#mode_str(),
          \ pos_info,
          \ (&modified ? '+' : !&modifiable ? '-' : ''),
          \ (&readonly ? 'RO' : ''),
          \ buf_info,
          \ ]->filter('!empty(v:val)')
    call popup_settext(s:info_popup_id, ['', info_list->join('┊')])
    if mode() == 'c'
      redraw
    endif
  endfunction
  " call s:update_info()

  set runtimepath+=~/ghq/github.com/kawarimidoll/tuskk.vim
  let base_table = tuskk#opts#builtin_kana_table()
  if exists('*tuskk#opts#builtin_kana_table')
    inoremap <c-j> <cmd>call tuskk#toggle()<cr>
    cnoremap <c-j> <cmd>call tuskk#cmd_buf()<cr>
    let azik_table = tuskk#opts#extend_azik_table()
    let az_keys = azik_table->keys()
    for k in az_keys
      if k[0] == k[1]
        unlet! azik_table[k]
      endif
    endfor
    unlet! azik_table[';']
    unlet! azik_table['q']
    let kana_table = extendnew(base_table, azik_table)

    let uj = expand('~/.cache/vim/SKK-JISYO.user')
    " \   { 'path': '~/.cache/vim/SKK-JISYO.nicoime', 'encoding': 'utf-8', 'mark': '[N]' },
    " \ 'suggest_wait_ms': 200,
    " \ 'suggest_prefix_match_minimum': 5,

    call tuskk#initialize({
          \ 'user_jisyo_path': uj,
          \ 'jisyo_list':  [
          \   { 'path': '~/.cache/vim/SKK-JISYO.L', 'encoding': 'euc-jp', 'mark': '[L]' },
          \   { 'path': '~/.cache/vim/SKK-JISYO.geo', 'encoding': 'euc-jp', 'mark': '[G]' },
          \   { 'path': '~/.cache/vim/SKK-JISYO.station', 'encoding': 'euc-jp', 'mark': '[S]' },
          \   { 'path': '~/.cache/vim/SKK-JISYO.jawiki', 'encoding': 'utf-8', 'mark': '[W]' },
          \   { 'path': '~/.cache/vim/SKK-JISYO.emoji', 'encoding': 'utf-8' },
          \ ],
          \ 'kana_table': kana_table,
          \ 'suggest_sort_by': 'length',
          \ 'debug_log': '',
          \ 'use_google_cgi': v:true,
          \ 'merge_tsu': v:true,
          \ 'trailing_n': v:true,
          \ 'abbrev_ignore_case': v:true,
          \ 'put_hanpa': v:true,
          \ })

    augroup tuskk_indicator
      autocmd!
      autocmd User tuskk_enable_post set cursorline
      autocmd User tuskk_disable_pre set nocursorline
    augroup END
  else
    function s:setup_tuskk() abort
      echomsg 'ghq get tuskk'
      call system('ghq get https://github.com/kawarimidoll/tuskk.vim')
      echomsg 'ghq get skk-dict'
      call system('ghq get https://github.com/skk-dev/dict')
      echomsg 'ghq get jawiki-dict'
      call system('ghq get https://github.com/tokuhirom/jawiki-kana-kanji-dict')
      echomsg 'make links'
      call system('mkdir -p ~/.cache/vim')
      call system('ln -sf ~/ghq/github.com/skk-dev/dict/SKK-JISYO.L ~/.cache/vim/SKK-JISYO.L')
      call system('ln -sf ~/ghq/github.com/skk-dev/dict/SKK-JISYO.geo ~/.cache/vim/SKK-JISYO.geo')
      call system('ln -sf ~/ghq/github.com/skk-dev/dict/SKK-JISYO.station ~/.cache/vim/SKK-JISYO.station')
      call system('ln -sf ~/ghq/github.com/skk-dev/dict/SKK-JISYO.emoji ~/.cache/vim/SKK-JISYO.emoji')
      call system('ln -sf ~/ghq/github.com/tokuhirom/jawiki-kana-kanji-dict/SKK-JISYO.jawiki ~/.cache/vim/SKK-JISYO.jawiki')
      echomsg 'done'
    endfunction
    command! SetupTuskk call <sid>setup_tuskk()
  endif

  set runtimepath+=~/ghq/github.com/kawarimidoll/textra.vim
  call textra#setup({
        \ 'name': 'kawarimidoll',
        \ 'key': getenv('TEXTRA_API_KEY'),
        \ 'secret': getenv('TEXTRA_API_SECRET')
        \ })
  function s:display_result(result) abort
    let bufnr = bufadd('textra_result')
    call bufload(bufnr)
    call appendbufline(bufnr, '$', ['', a:result])
    let winnr = bufwinnr(bufnr)
    if winnr < 0
      new
      execute 'buffer' bufnr
      setlocal nobuflisted buftype=nofile bufhidden=hide noswapfile
      " autocmd WinEnter <buffer> if winnr('$') == 1 | quit | endif
      execute winnr('#') 'wincmd w'
    endif
  endfunction
  function s:cmd_translate() abort
    let src = mode() == 'v'
          \ ? getregion(getpos('v'), getpos('.'), #{ type: mode(1) })->join(' ')
          \ : getreg('')
    " default: en->ja
    let [from_lang, to_lang] = ['EN', 'JA']
    if src =~ '[ぁ-ゖァ-ヺ]'
      " if japanese found: ja->en
      let [from_lang, to_lang] = ['JA', 'EN']
    endif
    echo $'[textra] translate {from_lang} -> {to_lang} ...'
    let dst = textra#translate(substitute(src, '[[:space:]]\+', ' ', 'g'), from_lang, to_lang)
    " redraw to remove echo
    redraw!
    call s:display_result(dst)
  endfunction
  command! Textra call s:cmd_translate()
  nnoremap <space>T <cmd>Textra<cr>
  xnoremap <space>T <cmd>Textra<cr>
endif

silent! delmarks ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890
silent! delmarks!
