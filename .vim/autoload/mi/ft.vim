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
      \  'j': 'JｊＪ〄',
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

function! mi#ft#repeat(key) abort
  if a:key != ';' && a:key != ','
    return
  endif

  let charsearch = getcharsearch()

  let char = charsearch.char
  if char == ''
    return
  endif

  if get(g:, 'mi#ft#fix_direction', s:defaults.fix_direction)
    let direction = a:key == ';' ? 1 : -1
  else
    let direction = (charsearch.forward && a:key == ';') ||
          \ (!charsearch.forward && a:key == ',') ? 1 : -1
  endif

  let pattern = escape(char, '$^*\\')
  if has_key(g:mi#ft#key_table, char)
    let pattern = '[' .. char .. g:mi#ft#key_table[char] .. ']'
  endif

  if direction > 0
    let flag = 'W'
    if charsearch.until
      let pattern = '\_.\ze' .. pattern
    endif
  else
    let flag = 'beW'
    if charsearch.until
      let pattern = pattern .. '\@<=\_.'
    endif
  endif

  if !get(g:, 'mi#ft#multiline', s:defaults.multiline)
    " in current line
    let stopline = line('.')
  elseif direction > 0
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

function! s:echo_one(...) abort
  echo a:1
  let s:message_enable = 1
endfunction

function! mi#ft#smart(key) abort
  if a:key !=? 'f' && a:key !=? 't'
    return
  endif

  if !exists('g:mi#dot_repeating')
    let timer_id = timer_start(1000, funcref('s:echo_one', ['[ft] input search char:']))
    let char = nr2char(getchar())
    call timer_stop(timer_id)
    if char == get(g:, 'mi#ft#digraph_marker', s:defaults.digraph_marker)
      unlet! s:message_enable
      redraw
      echo '[ft] input digraph:'
      let d1 = nr2char(getchar())
      redraw
      if d1 !~ '\p'
        return
      endif
      echo '[ft] input digraph:' d1
      let d2 = nr2char(getchar())
      redraw
      if d2 !~ '\p'
        return
      endif
      let char = get(split(digraph_get(d1 .. d2)), 0, '')
      echo '[ft] input digraph:' d1 d2 '->' char
    endif
    if char !~ '\p'
      return
    endif
    if exists('s:message_enable')
      redraw
      echo '[ft] input search char:' char
      unlet! s:message_enable
    endif

    let forward = a:key ==# 'f' || a:key ==# 't'
    let until = a:key ==? 't'
    call setcharsearch({'char': ''})
    call setcharsearch({'forward': forward, 'char': char, 'until': until})
    let s:lastchar = char
  endif

  call mi#ft#repeat(';')
endfunction

function! mi#ft#smart_expr(key) abort
  return "v\<cmd>call mi#ft#smart('" .. a:key .. "')\<CR>"
endfunction
function! mi#ft#repeat_expr(key) abort
  return "v\<cmd>call mi#ft#repeat('" .. a:key .. "')\<CR>"
endfunction

" https://github.com/echasnovski/mini.nvim/blob/main/lua/mini/jump.lua
