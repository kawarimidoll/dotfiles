function! mi#tiny_segmenter#load_model(json_path) abort
  " let json_path = a:json_path ==# 'JA' ? DEFAULT_PATH : a:json_path
  let json_path = a:json_path
  let raw = json_decode(join(readfile(json_path), "\n"))
  let keys = ['UP1', 'UP2', 'UP3', 'BP1', 'BP2',
        \ 'UW1', 'UW2', 'UW3', 'UW4', 'UW5', 'UW6',
        \ 'BW1', 'BW2', 'BW3', 'TW1', 'TW2', 'TW3', 'TW4',
        \ 'UC1', 'UC2', 'UC3', 'UC4', 'UC5', 'UC6',
        \ 'BC1', 'BC2', 'BC3', 'TC1', 'TC2', 'TC3', 'TC4', 'TC5',
        \ 'UQ1', 'UQ2', 'UQ3', 'BQ1', 'BQ2', 'BQ3', 'BQ4',
        \ 'TQ1', 'TQ2', 'TQ3', 'TQ4' ]

  let model = { 'parse': function('s:parse'), 'base_score': get(raw, 'BIAS', 0) }
  for key in keys
    let model[key] = get(raw, key, {})
  endfor

  return model
endfunction

function! s:ctype(char) abort
  return  a:char =~# '[一二三四五六七八九十百千万億兆]' ? 'M'
        \ : a:char =~# '[一-龠々〆ヵヶ]' ? 'H'
        \ : a:char =~# '[ぁ-ん]' ? 'I'
        \ : a:char =~# '[ァ-ヴーｱ-ﾝﾞｰ]' ? 'K'
        \ : a:char =~# '[a-zA-Zａ-ｚＡ-Ｚ]' ? 'A'
        \ : a:char =~# '[0-9０-９]' ? 'N'
        \ : 'O'
endfunction

function! s:parse(str = '') abort dict
  if a:str == ''
    return []
  endif

  " wrap with dummy items to avoid access outside the list
  let seg = ['B3', 'B2', 'B1'] + split(a:str, '\zs') + ['E1', 'E2', 'E3']

  let [p1, p2, p3] = ['U', 'U', 'U']
  let [c1, c2, c3, c4, c5] = ['O', 'O', 'O', s:ctype(seg[4]), s:ctype(seg[5])]

  " initialize with first char of a:str
  let result = [seg[3]]

  for i in range(4, len(seg) - 4)
    " from i-3 to i+2 are must be in list index
    let [w1, w2, w3, w4, w5, w6] = seg[i-3 : i+2]

    " c1-c6 are ctypes of w1-w6
    let c6 = s:ctype(w6)

    let score = self.base_score
    let score += get(self.UP1, p1, 0)
    let score += get(self.UP2, p2, 0)
    let score += get(self.UP3, p3, 0)
    let score += get(self.BP1, p1 .. p2, 0)
    let score += get(self.BP2, p2 .. p3, 0)
    let score += get(self.UW1, w1, 0)
    let score += get(self.UW2, w2, 0)
    let score += get(self.UW3, w3, 0)
    let score += get(self.UW4, w4, 0)
    let score += get(self.UW5, w5, 0)
    let score += get(self.UW6, w6, 0)
    let score += get(self.BW1, w2 .. w3, 0)
    let score += get(self.BW2, w3 .. w4, 0)
    let score += get(self.BW3, w4 .. w5, 0)
    let score += get(self.TW1, w1 .. w2 .. w3, 0)
    let score += get(self.TW2, w2 .. w3 .. w4, 0)
    let score += get(self.TW3, w3 .. w4 .. w5, 0)
    let score += get(self.TW4, w4 .. w5 .. w6, 0)
    let score += get(self.UC1, c1, 0)
    let score += get(self.UC2, c2, 0)
    let score += get(self.UC3, c3, 0)
    let score += get(self.UC4, c4, 0)
    let score += get(self.UC5, c5, 0)
    let score += get(self.UC6, c6, 0)
    let score += get(self.BC1, c2 .. c3, 0)
    let score += get(self.BC2, c3 .. c4, 0)
    let score += get(self.BC3, c4 .. c5, 0)
    let score += get(self.TC1, c1 .. c2 .. c3, 0)
    let score += get(self.TC2, c2 .. c3 .. c4, 0)
    let score += get(self.TC3, c3 .. c4 .. c5, 0)
    let score += get(self.TC4, c4 .. c5 .. c6, 0)
    " let score += get(self.TC5, c4 .. c5 .. c6, 0)
    let score += get(self.UQ1, p1 .. c1, 0)
    let score += get(self.UQ2, p2 .. c2, 0)
    let score += get(self.UQ3, p3 .. c3, 0)
    let score += get(self.BQ1, p2 .. c2 .. c3, 0)
    let score += get(self.BQ2, p2 .. c3 .. c4, 0)
    let score += get(self.BQ3, p3 .. c2 .. c3, 0)
    let score += get(self.BQ4, p3 .. c3 .. c4, 0)
    let score += get(self.TQ1, p2 .. c1 .. c2 .. c3, 0)
    let score += get(self.TQ2, p2 .. c2 .. c3 .. c4, 0)
    let score += get(self.TQ3, p3 .. c1 .. c2 .. c3, 0)
    let score += get(self.TQ4, p3 .. c2 .. c3 .. c4, 0)

    if score > 0
      call add(result, seg[i])
      let [p1, p2, p3] = [p2, p3, 'B']
    else
      let result[-1] ..= seg[i]
      let [p1, p2, p3] = [p2, p3, 'O']
    endif

    " use previous values to avoid re-calculation
    let [c1, c2, c3, c4, c5] = [c2, c3, c4, c5, c6]
  endfor

  return result
endfunction

" let s:tiny_segmenter_json_path = expand('~/.cache/vim/tiny_segmenter_model.json')
" let m = mi#tiny_segmenter#load_model(s:tiny_segmenter_json_path)
" echo m.parse('あなたに寄り添う最先端のテクノロジー')
" echo m.parse('私の名前は中野です')
" echo m.parse('わずか25kバイトのソースコードで、日本語の新聞記事であれば文字単位で95%程度の精度で分かち書きが行えます。Yahoo!の形態素解析のようにサーバーサイドで解析するのではなく、全てクライアントサイドで解析を行うため、セキュリティの観点から見ても安全です。')
