" ref: https://github.com/koron/vim-budoux

function! mi#budoux#load_model(json_path) abort
  " let json_path = a:json_path ==# 'JA' ? DEFAULT_PATH : a:json_path
  let json_path = a:json_path
  let raw = json_decode(join(readfile(json_path), "\n"))
  let keys = ['UW1', 'UW2', 'UW3', 'UW4', 'UW5', 'UW6', 'BW1', 'BW2', 'BW3', 'TW1', 'TW2', 'TW3', 'TW4']

  let model = { 'parse': function('s:parse') }
  let sum = 0
  for key in keys
    let model[key] = get(raw, key, {})
    let sum += reduce(values(model[key]), { acc, val -> acc + val })
  endfor
  let model.base_score = -sum / 2

  return model
endfunction

function! s:parse(str) abort dict
  if a:str == ''
    return []
  endif

  " wrap with dummy items to avoid access outside the list
  let chars = ['', ''] + split(a:str, '\zs') + ['', '']

  " initialize with first char of a:str
  let chunks = [chars[2]]

  for i in range(3, len(chars) - 3)
    let score = self.base_score

    " single
    let score += get(self.UW1, chars[i-3], 0)
    let score += get(self.UW2, chars[i-2], 0)
    let score += get(self.UW3, chars[i-1], 0)
    let score += get(self.UW4, chars[i  ], 0)
    let score += get(self.UW5, chars[i+1], 0)
    let score += get(self.UW6, chars[i+2], 0)

    " double
    let score += get(self.BW1, join(chars[i-2 : i  ]), 0)
    let score += get(self.BW2, join(chars[i-1 : i+1]), 0)
    let score += get(self.BW3, join(chars[i   : i+2]), 0)

    " triple
    let score += get(self.TW1, join(chars[i-3 : i  ]), 0)
    let score += get(self.TW2, join(chars[i-2 : i+1]), 0)
    let score += get(self.TW3, join(chars[i-1 : i+2]), 0)
    let score += get(self.TW4, join(chars[i   : i+3]), 0)

    if score > 0
      call add(chunks, chars[i])
    else
      let chunks[-1] ..= chars[i]
    endif
  endfor

  return chunks
endfunction

" let s:budoux_json_path = expand('~/.cache/vim/budoux-ja.json')
" " let s:budoux_model_url = 'https://raw.githubusercontent.com/google/budoux/main/budoux/models/ja.json'
" " call mi#utils#download(s:budoux_model_url, s:budoux_json_path)
" let m = mi#budoux#load_model(s:budoux_json_path)
" echo m.parse('あなたに寄り添う最先端のテクノロジー')
