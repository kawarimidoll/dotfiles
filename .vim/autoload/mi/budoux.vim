" ref: https://github.com/koron/vim-budoux

let s:budoux_json_path = expand('~/.cache/vim/budoux-ja.json')
let s:budoux_model_url = 'https://raw.githubusercontent.com/google/budoux/main/budoux/models/ja.json'

function! mi#budoux#download_model(force = v:false) abort
  echo '[budoux#download_model] ' .. s:budoux_json_path
  if filereadable(s:budoux_json_path) && !a:force
    echo '[budoux#download_model] dictionary file is already exists.'
    echo '[budoux#download_model] add v:true argument to overwrite.'
    return
  endif
  echo '[budoux#download_model] start download...'
  echo system(printf('curl -fsSLo %s --create-dirs %s', s:budoux_json_path, s:budoux_model_url))
  echo '[budoux#download_model] done.'
endfunction

function! mi#budoux#load_model() abort
  try
    let raw = json_decode(join(readfile(s:budoux_json_path), "\n"))
  catch /^Vim\%((\a\+)\)\=:E484:/
    echohl ErrorMsg
    echomsg "[budoux#load_model] Can't read model file. Call budoux#download_model()"
    echohl NONE
    return v:false
  endtry

  let keys = ['UW1', 'UW2', 'UW3', 'UW4', 'UW5', 'UW6', 'BW1', 'BW2', 'BW3', 'TW1', 'TW2', 'TW3', 'TW4']

  " calculate base score (bias)
  let s:model = {}
  let sum = 0
  for key in keys
    let s:model[key] = get(raw, key, {})
    let sum += reduce(values(s:model[key]), { acc, val -> acc + val })
  endfor
  let s:model.base_score = -sum / 2
  return v:true
endfunction

function! mi#budoux#parse(str) abort
  if !exists('s:model') && !mi#budoux#load_model()
    " initialize failed
    return []
  endif

  if a:str == ''
    return []
  endif

  let chars = ['', ''] + split(a:str, '\zs') + ['', '']
  let chunks = [chars[2]] " first char of a:str

  for i in range(3, len(chars) - 3)
    let score = s:model.base_score

    " single
    let score += get(s:model.UW1, chars[i-3], 0)
    let score += get(s:model.UW2, chars[i-2], 0)
    let score += get(s:model.UW3, chars[i-1], 0)
    let score += get(s:model.UW4, chars[i  ], 0)
    let score += get(s:model.UW5, chars[i+1], 0)
    let score += get(s:model.UW6, chars[i+2], 0)

    " double
    let score += get(s:model.BW1, join(chars[i-2 : i  ]), 0)
    let score += get(s:model.BW2, join(chars[i-1 : i+1]), 0)
    let score += get(s:model.BW3, join(chars[i   : i+2]), 0)

    " triple
    let score += get(s:model.TW1, join(chars[i-3 : i  ]), 0)
    let score += get(s:model.TW2, join(chars[i-2 : i+1]), 0)
    let score += get(s:model.TW3, join(chars[i-1 : i+2]), 0)
    let score += get(s:model.TW4, join(chars[i   : i+3]), 0)

    if score > 0
      call add(chunks, chars[i])
    else
      let chunks[-1] ..= chars[i]
    endif
  endfor

  return chunks
endfunction
