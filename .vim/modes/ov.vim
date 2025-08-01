" visual

" xnoremap p <cmd>call <sid>sync_unnamed()<cr>P
xnoremap p P
xnoremap y mzy`z
xnoremap x "_x
xnoremap < <gv
xnoremap > >gv
" xmap <Tab>   >
" xmap <S-Tab> <
xnoremap <silent><C-k> :m'<-2<CR>gv=gv
xnoremap <silent><C-j> :m'>+1<CR>gv=gv
" xnoremap S "zy:%s/<C-r>z//gce<Left><Left><Left><Left>
xnoremap S "zy:%s/\V<C-r><C-r>=escape(@z,'/\')<cr>//gce<Left><Left><Left><Left>
" ref: https://github.com/monaqa/dotfiles/blob/f214e9628cbac0803ad9d9bc2ad1582c696c4e6b/.config/nvim/scripts/keymap.vim#L63-L69
xnoremap * "zy/\V<C-r><C-r>=substitute(escape(@z, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>``
xnoremap # "zy?\V<C-r><C-r>=substitute(escape(@z, '/\'), '\_s\+', '\\_s\\+', 'g')<CR><CR>``
xnoremap R "zy:,$s//<C-r><C-r>=escape(@z, '/\&~')<CR>/gce<Bar>1,''-&&<CR>

xnoremap so :source<cr><cmd>nohlsearch<cr>gv

xnoremap qg :global/^/normal<Space>

xnoremap <Space>2 :copy'<-1<CR>gv
xnoremap <Space>3 :copy'>+0<CR>gv

" operator
onoremap x d

Keymap xo il <Cmd>call mi#textobject#line()<CR>
Keymap xo al <Cmd>call mi#textobject#line({'no_trim': 1})<CR>
Keymap xo iu <Cmd>call mi#textobject#fname()<CR>
Keymap xo iy <Cmd>call mi#textobject#lastpaste()<CR>
Keymap xo id <Cmd>call mi#textobject#datetime()<CR>
Keymap xo iA <Cmd>call mi#textobject#alphabet()<CR>
Keymap xo aA <Cmd>call mi#textobject#alphabet({'with_num': 1})<CR>
Keymap xo ie <Cmd>call mi#textobject#entire()<CR>
Keymap xo ae <Cmd>call mi#textobject#entire({'charwise': 1})<CR>
Keymap xo iS <Cmd>call mi#textobject#space()<CR>
Keymap xo aS <Cmd>call mi#textobject#space({'with_tab': 1})<CR>
Keymap xo io <Cmd>call mi#textobject#outline()<CR>
Keymap xo ao <Cmd>call mi#textobject#outline({'from_parent': 1, 'with_blank': 1})<CR>

if !has('nvim')
  Keymap xo i<space> iW
  Keymap xo ib <cmd>call mi#textobject#pair('i')<cr>
  Keymap xo ab <cmd>call mi#textobject#pair('a')<cr>
  Keymap xo iq <cmd>call mi#textobject#quote('i')<cr>
  Keymap xo aq <cmd>call mi#textobject#quote('a')<cr>
  " Keymap xo i<space> <cmd>call mi#textobject#between(' ', 0)<cr>
  Keymap xo a<space> <cmd>call mi#textobject#between(' ', 1)<cr>
  Keymap xo i<bar> <cmd>call mi#textobject#between("\<bar>", 0)<cr>
  Keymap xo a<bar> <cmd>call mi#textobject#between("\<bar>", 1)<cr>
  " does not works <bslash>...
  " Keymap xo i<bslash> <cmd>call mi#textobject#between("\<bslash>", 0)<cr>
  " Keymap xo a<bslash> <cmd>call mi#textobject#between("\<bslash>", 1)<cr>
  for i in range(33, 126)
    let c = nr2char(i)
    if c !~ '[[:punct:]]' || stridx('\|<>(){}[]"`''', c) >= 0
      continue
    endif
    execute 'Keymap xo i' .. c .. ' <cmd>call mi#textobject#between(''' .. c .. ''', 0)<cr>'
    execute 'Keymap xo a' .. c .. ' <cmd>call mi#textobject#between(''' .. c .. ''', 1)<cr>'
  endfor
  Keymap xo i? <cmd>call mi#textobject#input(0)<cr>
  Keymap xo a? <cmd>call mi#textobject#input(1)<cr>
endif
