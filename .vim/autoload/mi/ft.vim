let g:mi#ft#key_table = {
      \  '1': '!１！①',
      \  '2': '@２＠②',
      \  '3': '#３＃③',
      \  '4': '$４＄④',
      \  '5': '%５％⑤',
      \  '6': '^６＾⑥',
      \  '7': '&７＆⑦',
      \  '8': '*８＊⑧',
      \  '9': '(９（⑨',
      \  '0': ')０）',
      \  '`': '~〜',
      \  'a': 'AａＡぁあァア',
      \  'b': 'BｂＢばびぶべぼバビブベボ',
      \  'c': 'CｃＣ',
      \  'd': 'DｄＤだぢづでどダヂヅデド',
      \  'e': 'EｅＥぇえェエ',
      \  'f': 'FｆＦ',
      \  'g': 'GｇＧがぎぐげごガギグゲゴ',
      \  'h': 'HｈＨはひふへほハヒフヘホ',
      \  'i': 'IｉＩぃいィイ',
      \  'j': 'JｊＪじジ〄',
      \  'k': 'KｋＫかきくけこカキクケコヵヶ',
      \  'l': 'LｌＬ',
      \  'm': 'MｍＭまみむめもマミムメモ',
      \  'n': 'NｎＮなにぬねのナニヌネノんン',
      \  'o': 'OｏＯぉおォオ',
      \  'p': 'PｐＰぱぴぷぺぽパピプペポ',
      \  'q': 'QｑＱ',
      \  'r': 'RｒＲらりるれろラリルレロ',
      \  's': 'SｓＳさしすせそサシスセソ',
      \  't': 'TｔＴたちっつてとタチッツテト',
      \  'u': 'UｕＵぅうゥウ',
      \  'v': 'VゔｖＶヴ',
      \  'w': 'WｗＷゎわゐゑをヮワヰヱヲ',
      \  'x': 'XｘＸ',
      \  'y': 'Yｙｚゃやゅゆょよャヤュユョヨ',
      \  'z': 'ZＹＺざじずぜぞザジズゼゾ',
      \  '=': '+＋＝',
      \  '\': '|＼｜',
      \  '|': '|',
      \  ';': ':：；',
      \  "'": '"゜゛',
      \  ',': '<、，〈《',
      \  '.': '>。．〉》',
      \  '/': '?・？／',
      \  '-': '_ー＿',
      \  '[': '{｛「『【〔〖',
      \  ']': '}｝」』】〕〗',
      \  ' ': '　',
      \  }

let s:defaults = {
      \  'fix_direction': 0,
      \  'multiline': 0,
      \  'digraph_marker': "\<C-k>",
      \  }

" # variables
"
" when enable this, ';' always search forward, ',' always search backward.
" let g:mi#ft#fix_direction = 0
"
" when enable this, search char in visible lines, not only current line.
" let g:mi#ft#multiline = 0
"
" the key to use digraph
" let g:mi#ft#digraph_marker = "\<C-k>"

let s:sid = expand('<SID>')

function! s:repeat(same_direction) abort
  let charsearch = getcharsearch()

  let char = charsearch.char
  if char == ''
    return
  endif

  let forward = get(g:, 'mi#ft#fix_direction', s:defaults.fix_direction)
        \ ? a:same_direction
        \ : charsearch.forward == a:same_direction

  let pattern = has_key(g:mi#ft#key_table, char)
        \ ? $'[{char}{g:mi#ft#key_table[char]}]'
        \ : escape(char, '$^*~\')

  if forward
    let flag = 'W'
    if charsearch.until
      let pattern = $'\_.\ze{pattern}'
    endif
  else
    let flag = 'beW'
    if charsearch.until
      let pattern = $'{pattern}\@<=\_.'
    endif
  endif

  if !get(g:, 'mi#ft#multiline', s:defaults.multiline)
    " in current line
    let stopline = line('.')
  elseif forward
    " to visible bottom
    let stopline = line('w$')
  else
    " to visible top
    let stopline = line('w0')
  endif

  for i in range(v:count1)
    let [lnum, col] = searchpos(pattern, flag, stopline)

    if lnum == 0
      " not found
      return
    endif
  endfor

  call cursor(lnum, col)
endfunction

function! s:getchar() abort
  let timer_id = timer_start(1000, {-> execute("echo '[ft] input search char:'", '')})
  let char = nr2char(getchar())
  call timer_stop(timer_id)

  if char == get(g:, 'mi#ft#digraph_marker', s:defaults.digraph_marker)
    redraw
    echo '[ft] input digraph:'
    let d1 = nr2char(getchar())
    redraw
    if d1 !~ '\p'
      return ''
    endif
    echo '[ft] input digraph:' d1
    let d2 = nr2char(getchar())
    redraw
    if d2 !~ '\p'
      return ''
    endif
    let char = get(split(digraph_get(d1 .. d2)), 0, '')
    echo '[ft] input digraph:' d1 d2 '->' char
  else
    echo '[ft] input search char:' char
  endif

  return char
endfunction

function! s:omap_prefix() abort
  " operator-pending mode の時だけ v を付ける (characterwise)
  return mode(1) =~# '^no' ? 'v' : ''
endfunction

function! mi#ft#expr(key) abort
  if a:key =~? '[ft]'
    let char = s:getchar()
    if char !~ '\p'
      return ''
    endif
    call setcharsearch({'char': char, 'forward': a:key =~# '\l', 'until': a:key ==? 't'})
    let same_direction = v:true
  elseif a:key == ';'
    let same_direction = v:true
  elseif a:key == ','
    let same_direction = v:false
  else
    echoerr 'mi#ft#expr: invalid key:' a:key
    return ''
  endif

  return s:omap_prefix() .. $"\<cmd>call {s:sid}repeat({same_direction})\<CR>"
endfunction

" :h getchar()
" https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/jump.lua
