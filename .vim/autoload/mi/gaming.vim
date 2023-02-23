" ref: https://github.com/tamago324/vim-gaming-line

" 0 - 100
let s:saturation = 100
let s:brightness = 50

let s:interval = 10

let s:num_colors = 720

function! s:abs(num) abort
  return a:num < 0 ? -a:num : a:num
endfunction

" all of h, s, b, r, g, b are in 0.0~1.0
" https://ja.wikipedia.org/wiki/HSV色空間#HSVからRGBへの変換
function! s:hsv2rgb(h, s, v) abort
  let s = a:s
  let r = a:v
  let g = a:v
  let b = a:v

  if s <= 0.0
    return [r, g, b]
  endif

  let h = a:h * 6
  let i = float2nr(h)
  let f = h - i

  if i == 0
    let g *= 1 - s * (1 - f)
    let b *= 1 - s
  elseif i == 1
    let r *= 1 - s * f
    let b *= 1 - s
  elseif i == 2
    let r *= 1 - s
    let b *= 1 - s * (1 - f)
  elseif i == 3
    let r *= 1 - s
    let g *= 1 - s * f
  elseif i == 4
    let r *= 1 - s * (1 - f)
    let g *= 1 - s
  elseif i == 5
    let g *= 1 - s
    let b *= 1 - s * f
  endif

  return [r, g, b]
endfunction

function! s:rgb2hex(r, g, b) abort
  return printf('#%02x%02x%02x', a:r, a:g, a:b)
endfunction

function! s:gen_colors() abort
  let colors = []
  let s = s:saturation / 100.0
  let v = s:brightness / 100.0

  for i in range(s:num_colors)
    let h = 1.0 * i / s:num_colors
    let [r, g, b] = s:hsv2rgb(h, s, v)
    call add(colors, s:rgb2hex(float2nr(r*255), float2nr(g*255), float2nr(b*255)))
  endfor

  return colors
endfunction

let s:colors = s:gen_colors()

let s:counter = 0

" called by timer
function! s:set_color(_timer) abort
  let s:counter += 1
  if s:counter >= s:num_colors
    let s:counter = 0
  endif
  " let s:opposite = s:counter + s:num_colors / 2
  " if s:opposite >= s:num_colors
  "   let s:opposite -= s:num_colors
  " endif

  " execute printf('highlight Gaming gui=%s guibg=%s', s:colors[s:counter], s:colors[s:opposite])
  execute printf('highlight Gaming gui=reverse guibg=%s', s:colors[s:counter])
  execute printf('highlight GamingFg guifg=%s', s:colors[s:counter])
  execute printf('highlight GamingBg guibg=%s', s:colors[s:counter])
endfunction
highlight Gaming guibg=black guifg=white
highlight GamingFg guibg=black guifg=white
highlight GamingBg guibg=black guifg=white

function! mi#gaming#start() abort
  if exists('s:timer_id')
    return
  endif
  let s:timer_id = timer_start(s:interval, function('s:set_color'), {'repeat': -1})
endfunction

function! mi#gaming#stop() abort
  silent! call timer_stop(s:timer_id)
  unlet! s:timer_id
endfunction

function! mi#gaming#toggle() abort
  if exists('s:timer_id')
    call mi#gaming#stop()
  else
    call mi#gaming#start()
  endif
endfunction

" command! GameStart call mi#gaming#start()
" command! GameStop call mi#gaming#stop()
" command! GameToggle call mi#gaming#toggle()
