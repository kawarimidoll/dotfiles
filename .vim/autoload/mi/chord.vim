function s:have_same_items(list1, list2) abort
  return a:list1->copy()->sort() == a:list2->copy()->sort()
endfunction

let s:wait = 50

" let s:chord_defs = {
"       \ 'timer1': {
"       \    'keys': [],
"       \    'func': {->},
"       \    'args': [],
"       \    'timers': {}
"       \  },
"       \}

function mi#chord#config(opts) abort
  if has_key(opts, wait)
    let s:wait = opts.wait
  endif
endfunction

" タイマー名と設定の対応テーブル
let s:chord_specs = {}

" キーとタイマー名の対応テーブル
" このキーが押されたらどのタイマーを起動するのか？の紐付けに使う
let s:chord_keys = {}

function mi#chord#def(mode, notes, func, args = []) abort
  if a:notes =~ '^[^ !-~]$'
    echomsg 'invalid note found'
    return
  endif
  for notes in s:chord_specs->keys()
    if s:have_same_items(notes->split('\zs'), a:notes->split('\zs'))
          \ && a:mode ==# s:chord_specs[notes].mode
      echomsg 'already defined'
      return
    endif
  endfor
  let s:chord_specs[a:notes] = {'mode': a:mode, 'func': a:func, 'args': a:args}
  let sid = "\<sid>"
  for k in a:notes->split('\zs')
    let s:chord_keys[k] = get(s:chord_keys, k, []) + [a:notes]
    execute $"{a:mode}noremap {k} <cmd>call {sid}run('{k}')<cr>"
  endfor
endfunction

" todo 別モードの設定で上書きされてしまう問題の修正
" call mi#chord#def('n', 'jk', 'execute', ["echomsg 'my_super!'", ''])
" call mi#chord#def('n', 'j;', 'execute', ["echomsg 'my_awesome!'", ''])
" call mi#chord#def('i', 'jk', 'feedkeys', ["\<esc>", 'ni'])

let s:delayed_feed = {}
function s:delayed_feed.eject(key) abort dict
  if self.stop(a:key)
    call feedkeys(a:key, 'ni')
  endif
endfunction
function s:delayed_feed.reserve(key) abort dict
  call self.eject(a:key)
  let self[a:key] = timer_start(s:wait, {->self.eject(a:key)})
endfunction
function s:delayed_feed.stop(key) abort dict
  if has_key(self, a:key)
    call timer_stop(self[a:key])
    unlet self[a:key]
    return v:true
  endif
  return v:false
endfunction

function s:run(key) abort
  let stop_keys = []
  for timer_name in s:chord_keys[a:key]
    let stop_keys += s:chord_main(a:key, timer_name)
  endfor

  if empty(stop_keys)
    call s:delayed_feed.reserve(a:key)
  else
    for k in stop_keys
      call s:delayed_feed.stop(k)
    endfor
  endif
endfunction

let s:chord_timers = {}
function s:chord_timers.stop(name, key = '') abort dict
  if a:key ==# ''
    let result = v:false
    for k in self.keys(a:name)
      call timer_stop(self[a:name][k])
      let result = v:true
    endfor
    let self[a:name] = {}
    return result
  endif

  if !has_key(self, a:name)
    let self[a:name] = {}
  elseif has_key(self[a:name], a:key)
    call timer_stop(self[a:name][a:key])
    unlet self[a:name][a:key]
    return v:true
  endif
  return v:false
endfunction
function s:chord_timers.set(name, key) abort dict
  let self[a:name][a:key] = timer_start(s:wait, {->self.stop(a:name, a:key)})
endfunction
function s:chord_timers.keys(name) abort dict
  return self[a:name]->keys()
endfunction

function s:chord_main(key, name) abort
  let spec = s:chord_specs[a:name]

  if !s:chord_timers.stop(a:name, a:key)
    let current_keys = s:chord_timers.keys(a:name)->add(a:key)
    if s:have_same_items(current_keys, a:name->split('\zs'))
      call s:chord_timers.stop(a:name)
      call call(spec.func, spec.args)
      return current_keys
    endif
  endif
  call s:chord_timers.set(a:name, a:key)

  return []
endfunction
